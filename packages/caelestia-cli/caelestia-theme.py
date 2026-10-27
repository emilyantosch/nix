#!/usr/bin/env python3
"""Pick the curated caelestia theme that best fits the wallpaper.

The themes are the hand-made "curated" scheme family (see themes/palettes.py);
nothing is generated from the wallpaper. The wallpaper is only used to rank
them: both the image and each theme are reduced to a hue distribution in
OKLab (weighted by chroma) and an overall colourfulness, and the theme whose
hues overlap the wallpaper's most wins (the greyer the wallpaper, the more
colourfulness decides instead). Lightness is ignored on purpose, so the same
comparison works for the dark and the light variant.

Dark/light is whatever the current scheme mode is; switching it keeps the theme.
A theme chosen by hand (set/next/prev) is remembered for that wallpaper.
"""

import argparse
import json
import math
import subprocess
import sys
from pathlib import Path

from caelestia.utils.paths import c_cache_dir, c_state_dir, scheme_data_dir, scheme_path, wallpaper_path_path
from PIL import Image

SCHEME = "curated"
STATE = c_state_dir / "curated-themes.json"
FEATURE_CACHE = c_cache_dir / "curated-themes-features.json"
NAMES = {
    "catppuccin": "Catppuccin",
    "rosepine": "Rosé Pine",
    "dracula": "Dracula",
    "tokyonight": "Tokyo Night",
    "nord": "Nord",
    "solarized": "Solarized",
    "everforest": "Everforest",
    "gruvbox": "Gruvbox",
    "kanagawa": "Kanagawa",
    "flexoki": "Flexoki",
}

HUE_BINS = 24
FULL_CHROMA = 0.09  # OKLab chroma from which a colour counts as fully chromatic
SMOOTH = 1.2  # hue blur in bins (~18deg), so near hues still overlap
TRUST_COLOURFUL = 0.12  # colourful fraction above which the hue match is fully trusted
CHROMA_WEIGHT = 0.08  # penalty for muted-vs-vivid mismatch

# How much of the screen each theme colour roughly covers.
THEME_WEIGHTS = {
    "background": 0.55,
    "surfaceContainer": 0.10,
    "primary": 0.15,
    "secondary": 0.07,
    "tertiary": 0.05,
    **{k: 0.01 for k in ("red", "peach", "yellow", "green", "teal", "blue", "mauve", "pink")},
}

# --- colour features -------------------------------------------------------


def _lin(c: float) -> float:
    c /= 255
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4


def oklab(rgb: tuple[int, int, int]) -> tuple[float, float, float]:
    r, g, b = (_lin(c) for c in rgb)
    l_ = (0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b) ** (1 / 3)
    m_ = (0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b) ** (1 / 3)
    s_ = (0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b) ** (1 / 3)
    return (
        0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
        1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
        0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_,
    )


Features = tuple[list[float], float, float]


def features(colours: dict[tuple[int, int, int], float]) -> Features:
    """(hue distribution, colourful fraction, mean chroma) of weighted colours.

    The hue distribution is normalised, so it only describes *which* hues are
    present; how colourful things are overall is kept separately.
    """
    hist = [0.0] * HUE_BINS
    total = chroma = 0.0
    for rgb, w in colours.items():
        _, a, b = oklab(rgb)
        c = math.hypot(a, b)
        q = min(1.0, c / FULL_CHROMA)
        total += w
        chroma += w * c
        if q > 0:
            pos = (math.degrees(math.atan2(b, a)) % 360) / 360 * HUE_BINS
            i, frac = int(pos) % HUE_BINS, pos - int(pos)
            hist[i] += w * q * (1 - frac)
            hist[(i + 1) % HUE_BINS] += w * q * frac

    kernel = [math.exp(-(d * d) / (2 * SMOOTH * SMOOTH)) for d in range(-3, 4)]
    hue = [sum(hist[(i + d) % HUE_BINS] * k for d, k in zip(range(-3, 4), kernel)) for i in range(HUE_BINS)]
    mass = sum(hue)
    if mass > 0:
        hue = [h / mass for h in hue]
    return hue, sum(hist) / total, chroma / total


def wallpaper_features(path: Path) -> Features:
    """Cached by path, size and mtime: big PNGs take ~1s to decode, which
    makes the hover preview in the launcher lag."""
    st = path.stat()
    key = f"{path}:{st.st_size}:{st.st_mtime_ns}"
    try:
        cache = json.loads(FEATURE_CACHE.read_text())
    except (OSError, json.JSONDecodeError):
        cache = {}
    if key in cache:
        return tuple(cache[key])

    feats = _wallpaper_features(path)
    cache = {k: v for k, v in cache.items() if not k.startswith(f"{path}:")}
    cache[key] = feats
    FEATURE_CACHE.parent.mkdir(parents=True, exist_ok=True)
    FEATURE_CACHE.write_text(json.dumps(cache))
    return feats


def _wallpaper_features(path: Path) -> Features:
    with Image.open(path) as img:
        img.draft("RGB", (256, 256))  # fast JPEG downscale on decode
        img = img.convert("RGB")
        img.thumbnail((64, 64), Image.Resampling.BOX)
        counts: dict[tuple[int, int, int], float] = {}
        pixels = img.get_flattened_data() if hasattr(img, "get_flattened_data") else img.getdata()
        for px in pixels:
            counts[px] = counts.get(px, 0) + 1
    return features(counts)


def theme_colours(theme: str, mode: str) -> dict[str, str]:
    path = scheme_data_dir / SCHEME / theme / f"{mode}.txt"
    return dict(line.split() for line in path.read_text().splitlines() if line.strip())


def theme_features(theme: str, mode: str) -> tuple[list[float], float]:
    colours = theme_colours(theme, mode)
    weighted: dict[tuple[int, int, int], float] = {}
    for key, w in THEME_WEIGHTS.items():
        h = colours[key]
        rgb = (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16))
        weighted[rgb] = weighted.get(rgb, 0) + w
    return features(weighted)


def similarity(wall: Features, theme: Features) -> float:
    (hw, colourful, cw), (ht, _, ct) = wall, theme
    overlap = sum(min(a, b) for a, b in zip(hw, ht))
    # A nearly grey wallpaper has no meaningful hues; let the muted-vs-vivid
    # term decide instead of noise.
    trust = min(1.0, colourful / TRUST_COLOURFUL)
    return trust * overlap - CHROMA_WEIGHT * abs(math.log((cw + 1e-3) / (ct + 1e-3)))


# --- state -----------------------------------------------------------------


def themes() -> list[str]:
    return sorted(p.name for p in (scheme_data_dir / SCHEME).iterdir() if p.is_dir())


def current_scheme() -> dict:
    try:
        return json.loads(scheme_path.read_text())
    except (OSError, json.JSONDecodeError):
        return {"name": "", "flavour": "", "mode": "dark"}


def current_wallpaper() -> str | None:
    try:
        return wallpaper_path_path.read_text().strip() or None
    except OSError:
        return None


def load_overrides() -> dict[str, str]:
    try:
        return json.loads(STATE.read_text()).get("overrides", {})
    except (OSError, json.JSONDecodeError):
        return {}


def save_overrides(overrides: dict[str, str]) -> None:
    STATE.parent.mkdir(parents=True, exist_ok=True)
    STATE.write_text(json.dumps({"overrides": overrides}, indent=2))


def remember(wall: str | None, theme: str | None) -> None:
    if not wall:
        return
    overrides = load_overrides()
    if theme:
        overrides[wall] = theme
    else:
        overrides.pop(wall, None)
    save_overrides(overrides)


# --- actions ---------------------------------------------------------------


def rank(wall: str, mode: str) -> list[tuple[str, float]]:
    wf = wallpaper_features(Path(wall))
    scores = [(t, similarity(wf, theme_features(t, mode))) for t in themes()]
    return sorted(scores, key=lambda s: s[1], reverse=True)


def pick(wall: str, mode: str) -> str:
    """The theme pinned for this wallpaper, else the best match."""
    theme = load_overrides().get(wall)
    if theme not in themes():
        theme = rank(wall, mode)[0][0]
    return theme


def apply(theme: str, mode: str) -> None:
    subprocess.run(["caelestia", "scheme", "set", "-n", SCHEME, "-f", theme, "-m", mode], check=True)


def notify(theme: str, mode: str, note: str = "") -> None:
    body = f"{NAMES.get(theme, theme)} ({mode}){note}"
    subprocess.run(["notify-send", "-a", "caelestia", "-i", "preferences-desktop-theme", "Theme", body], check=False)


def require_wallpaper(arg: str | None) -> str:
    wall = arg or current_wallpaper()
    if not wall:
        sys.exit("no wallpaper set (caelestia wallpaper -f PATH)")
    return str(Path(wall).expanduser().resolve())


def cmd_apply(args: argparse.Namespace) -> None:
    wall = require_wallpaper(args.wallpaper)
    mode = args.mode or current_scheme().get("mode", "dark")
    theme = pick(wall, mode)
    apply(theme, mode)
    print(theme)


def cmd_preview(args: argparse.Namespace) -> None:
    """The theme `apply` would pick, as `caelestia wallpaper -p` style JSON,
    without applying it (for the launcher's hover preview)."""
    wall = require_wallpaper(args.wallpaper)
    mode = args.mode or current_scheme().get("mode", "dark")
    theme = pick(wall, mode)
    print(json.dumps({"name": SCHEME, "flavour": theme, "mode": mode, "colours": theme_colours(theme, mode)}))


def cmd_rank(args: argparse.Namespace) -> None:
    wall = require_wallpaper(args.wallpaper)
    mode = args.mode or current_scheme().get("mode", "dark")
    cur = current_scheme()
    active = cur.get("flavour") if cur.get("name") == SCHEME else None
    pinned = load_overrides().get(wall)
    print(f"{wall} ({mode})")
    for i, (theme, score) in enumerate(rank(wall, mode), 1):
        marks = " ".join(m for m, on in (("active", theme == active), ("pinned", theme == pinned)) if on)
        print(f"{i:3}. {theme:12} {score:6.3f}  {marks}")


def cmd_set(args: argparse.Namespace) -> None:
    if args.theme not in themes():
        sys.exit(f"unknown theme {args.theme!r}; choose from: {', '.join(themes())}")
    mode = current_scheme().get("mode", "dark")
    apply(args.theme, mode)
    remember(current_wallpaper(), args.theme)
    notify(args.theme, mode)


def cmd_step(args: argparse.Namespace) -> None:
    wall = require_wallpaper(None)
    cur = current_scheme()
    mode = cur.get("mode", "dark")
    order = [t for t, _ in rank(wall, mode)]
    i = order.index(cur["flavour"]) if cur.get("name") == SCHEME and cur.get("flavour") in order else -args.step
    theme = order[(i + args.step) % len(order)]
    apply(theme, mode)
    remember(wall, theme)
    notify(theme, mode, f" · match #{order.index(theme) + 1}")


def cmd_auto(_: argparse.Namespace) -> None:
    wall = require_wallpaper(None)
    remember(wall, None)
    mode = current_scheme().get("mode", "dark")
    theme = rank(wall, mode)[0][0]
    apply(theme, mode)
    notify(theme, mode, " · best match")


def cmd_mode(args: argparse.Namespace) -> None:
    cur = current_scheme()
    mode = args.mode
    if mode == "toggle":
        mode = "light" if cur.get("mode") == "dark" else "dark"
    if mode == "get":
        print(cur.get("mode", "dark"))
        return
    if cur.get("name") == SCHEME:
        theme = cur["flavour"]
    else:
        # Not on a curated theme (e.g. picked a built-in one): fall back to
        # the wallpaper's pick so the mode switch can't fail.
        wall = require_wallpaper(None)
        theme = load_overrides().get(wall) or rank(wall, mode)[0][0]
    apply(theme, mode)


def cmd_list(_: argparse.Namespace) -> None:
    cur = current_scheme()
    for t in themes():
        mark = "*" if cur.get("name") == SCHEME and cur.get("flavour") == t else " "
        print(f"{mark} {t:12} {NAMES.get(t, t)}")


def main() -> None:
    parser = argparse.ArgumentParser(prog="caelestia-theme", description=__doc__.split("\n\n")[0])
    sub = parser.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("apply", help="apply the best (or pinned) theme for a wallpaper")
    p.add_argument("wallpaper", nargs="?", help="defaults to the current wallpaper")
    p.add_argument("-m", "--mode", choices=["dark", "light"], help="defaults to the current mode")
    p.set_defaults(func=cmd_apply)

    p = sub.add_parser("preview", help="print the theme apply would pick as scheme JSON, without applying it")
    p.add_argument("wallpaper", nargs="?", help="defaults to the current wallpaper")
    p.add_argument("-m", "--mode", choices=["dark", "light"], help="defaults to the current mode")
    p.set_defaults(func=cmd_preview)

    p = sub.add_parser("rank", help="show how well each theme fits a wallpaper")
    p.add_argument("wallpaper", nargs="?", help="defaults to the current wallpaper")
    p.add_argument("-m", "--mode", choices=["dark", "light"], help="defaults to the current mode")
    p.set_defaults(func=cmd_rank)

    p = sub.add_parser("set", help="use a theme and remember it for this wallpaper")
    p.add_argument("theme")
    p.set_defaults(func=cmd_set)

    p = sub.add_parser("next", help="switch to the next best match (remembered)")
    p.set_defaults(func=cmd_step, step=1)
    p = sub.add_parser("prev", help="switch to the previous match (remembered)")
    p.set_defaults(func=cmd_step, step=-1)

    p = sub.add_parser("auto", help="forget this wallpaper's pinned theme and use the best match")
    p.set_defaults(func=cmd_auto)

    p = sub.add_parser("mode", help="switch between dark and light, keeping the theme")
    p.add_argument("mode", nargs="?", default="toggle", choices=["dark", "light", "toggle", "get"])
    p.set_defaults(func=cmd_mode)

    p = sub.add_parser("list", help="list the curated themes")
    p.set_defaults(func=cmd_list)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
