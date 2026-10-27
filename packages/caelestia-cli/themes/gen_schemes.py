"""Render the curated palettes in palettes.py into caelestia scheme files.

    python3 gen_schemes.py OUT_DIR [REFERENCE_SCHEME.txt]

Writes OUT_DIR/<theme>/{dark,light}.txt. Each theme only defines its canonical
colours; everything caelestia needs on top (material roles, catppuccin-style
names, terminal and KDE colours) is derived here from those, mixing in OKLab so
derived shades keep the theme's own tint.

If a reference scheme is given, its key set is checked against ours so that
keys added upstream show up as a build warning instead of silently missing.
"""

import sys
from pathlib import Path

from palettes import THEMES

# --- colour math ------------------------------------------------------------


def _to_lin(c: float) -> float:
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4


def _from_lin(c: float) -> float:
    c = max(0.0, min(1.0, c))
    return 12.92 * c if c <= 0.0031308 else 1.055 * c ** (1 / 2.4) - 0.055


def hex_to_lab(h: str) -> tuple[float, float, float]:
    r, g, b = (_to_lin(int(h[i : i + 2], 16) / 255) for i in (0, 2, 4))
    l_ = (0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b) ** (1 / 3)
    m_ = (0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b) ** (1 / 3)
    s_ = (0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b) ** (1 / 3)
    return (
        0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
        1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
        0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_,
    )


def lab_to_hex(lab: tuple[float, float, float]) -> str:
    L, a, b = lab
    l_ = (L + 0.3963377774 * a + 0.2158037573 * b) ** 3
    m_ = (L - 0.1055613458 * a - 0.0638541728 * b) ** 3
    s_ = (L - 0.0894841775 * a - 1.2914855480 * b) ** 3
    rgb = (
        4.0767416621 * l_ - 3.3077115913 * m_ + 0.2309699292 * s_,
        -1.2684380046 * l_ + 2.6097574011 * m_ - 0.3413193965 * s_,
        -0.0041960863 * l_ - 0.7034186147 * m_ + 1.7076147010 * s_,
    )
    return "".join(f"{round(_from_lin(c) * 255):02x}" for c in rgb)


def mix(a: str, b: str, t: float) -> str:
    """Interpolate from a (t=0) to b (t=1) in OKLab."""
    la, lb = hex_to_lab(a), hex_to_lab(b)
    return lab_to_hex(tuple(x + (y - x) * t for x, y in zip(la, lb)))


def luminance(h: str) -> float:
    r, g, b = (_to_lin(int(h[i : i + 2], 16) / 255) for i in (0, 2, 4))
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def contrast(a: str, b: str) -> float:
    la, lb = sorted((luminance(a), luminance(b)), reverse=True)
    return (la + 0.05) / (lb + 0.05)


def ensure_contrast(fg: str, bg: str, target: float, toward: str) -> str:
    """Push fg toward `toward` until it reaches `target` contrast against bg."""
    for step in range(21):
        c = mix(fg, toward, step / 20)
        if contrast(c, bg) >= target:
            return c
    return toward


BLACK, WHITE = "000000", "ffffff"

# --- palette -> scheme ------------------------------------------------------

# Neutral ramp from background (0) to foreground (1). Themes give whatever
# steps they define canonically; missing ones are interpolated between the
# nearest given neighbours at these positions.
RAMP = [
    ("bg", 0.0),
    ("surface0", 0.10),
    ("surface1", 0.18),
    ("surface2", 0.26),
    ("overlay0", 0.36),
    ("overlay1", 0.45),
    ("overlay2", 0.55),
    ("subtext0", 0.66),
    ("subtext1", 0.80),
    ("fg", 1.0),
]

ACCENTS = ["red", "orange", "yellow", "green", "cyan", "blue", "purple", "pink"]


def fill_ramp(p: dict[str, str]) -> dict[str, str]:
    given = [(pos, p[name]) for name, pos in RAMP if name in p]
    out = {}
    for name, pos in RAMP:
        if name in p:
            out[name] = p[name]
            continue
        lo = max((g for g in given if g[0] < pos), key=lambda g: g[0])
        hi = min((g for g in given if g[0] > pos), key=lambda g: g[0])
        out[name] = mix(lo[1], hi[1], (pos - lo[0]) / (hi[0] - lo[0]))
    return out


def build(p: dict, mode: str) -> dict[str, str]:
    dark = mode == "dark"
    r = fill_ramp(p)
    bg, fg = r["bg"], r["fg"]
    acc = {name: p[name] for name in ACCENTS}

    def tone(t: float) -> str:
        return mix(bg, fg, t)

    def bright(name: str) -> str:
        return p.get("bright", {}).get(name) or mix(acc[name], WHITE if dark else BLACK, 0.18 if dark else 0.12)

    def role(name: str) -> str:
        # Material accents are used as indicator/text colours on surfaces, so
        # keep them at >= 3:1 there (WCAG non-text). Named accents below stay
        # canonical; only the material role gets nudged.
        v = p[name]
        c = acc.get(v, v)
        return ensure_contrast(c, tone(0.06 if dark else 0.05), 3.0, WHITE if dark else BLACK)

    mantle = p.get("mantle") or (mix(bg, BLACK, 0.18) if dark else tone(0.04))
    crust = p.get("crust") or (mix(bg, BLACK, 0.32) if dark else tone(0.08))

    surfaces = {
        "background": bg,
        "onBackground": fg,
        "surface": bg,
        "surfaceDim": bg if dark else tone(0.10),
        "surfaceBright": tone(0.20) if dark else bg,
        "surfaceContainerLowest": crust if dark else mix(bg, WHITE, 0.6),
        "surfaceContainerLow": tone(0.035 if dark else 0.025),
        "surfaceContainer": tone(0.06 if dark else 0.05),
        "surfaceContainerHigh": tone(0.11 if dark else 0.075),
        "surfaceContainerHighest": tone(0.16 if dark else 0.10),
        "onSurface": fg,
        "surfaceVariant": tone(0.22 if dark else 0.12),
        "onSurfaceVariant": r["subtext1"],
        "inverseSurface": fg,
        "inverseOnSurface": tone(0.12) if dark else mix(bg, WHITE, 0.3),
        "outline": r["overlay1"],
        "outlineVariant": tone(0.22),
        "shadow": "000000",
        "scrim": "000000",
    }

    def on(c: str) -> str:
        # Text on a filled accent: a deep or pale shade of the same hue,
        # whichever reads better.
        cands = [mix(c, BLACK, 0.78), mix(c, WHITE, 0.92)]
        return max(cands, key=lambda x: contrast(x, c))

    def container(c: str) -> str:
        return mix(bg, c, 0.35 if dark else 0.22)

    def on_container(c: str) -> str:
        cont = container(c)
        return ensure_contrast(mix(c, fg, 0.5), cont, 4.5, WHITE if dark else BLACK)

    def accent_roles(prefix: str, c: str) -> dict[str, str]:
        cap = prefix[0].upper() + prefix[1:]
        return {
            prefix: c,
            f"on{cap}": on(c),
            f"{prefix}Container": container(c),
            f"on{cap}Container": on_container(c),
        }

    def fixed_roles(prefix: str, c: str) -> dict[str, str]:
        cap = prefix[0].upper() + prefix[1:]
        return {
            f"{prefix}Fixed": mix(c, WHITE, 0.65),
            f"{prefix}FixedDim": mix(c, WHITE, 0.35),
            f"on{cap}Fixed": mix(c, BLACK, 0.8),
            f"on{cap}FixedVariant": mix(c, BLACK, 0.55),
        }

    pri, sec, ter = role("primary"), role("secondary"), role("tertiary")

    m = {
        "primary_paletteKeyColor": pri,
        "secondary_paletteKeyColor": sec,
        "tertiary_paletteKeyColor": ter,
        "neutral_paletteKeyColor": tone(0.5),
        "neutral_variant_paletteKeyColor": tone(0.45),
        **surfaces,
        "surfaceTint": pri,
        **accent_roles("primary", pri),
        "inversePrimary": mix(pri, BLACK, 0.35) if dark else mix(pri, WHITE, 0.45),
        **accent_roles("secondary", sec),
        **accent_roles("tertiary", ter),
        **accent_roles("error", acc["red"]),
        **fixed_roles("primary", pri),
        **fixed_roles("secondary", sec),
        **fixed_roles("tertiary", ter),
    }

    order = ["red", "green", "yellow", "blue", "purple", "cyan"]
    if "term" in p:
        term = p["term"]
    elif dark:
        term = [tone(0.15), *(acc[n] for n in order), r["subtext1"], r["overlay0"], *(bright(n) for n in order), fg]
    else:
        term = [r["subtext1"], *(acc[n] for n in order), r["surface2"], r["subtext0"], *(bright(n) for n in order), r["surface1"]]
    m.update({f"term{i}": c for i, c in enumerate(term)})

    blue, purple, cyan, pink, red = acc["blue"], acc["purple"], acc["cyan"], acc["pink"], acc["red"]
    m.update(
        {
            "rosewater": p.get("rosewater") or mix(pink, fg, 0.55),
            "flamingo": p.get("flamingo") or mix(pink, fg, 0.3),
            "pink": pink,
            "mauve": purple,
            "red": red,
            "maroon": p.get("maroon") or mix(red, pink, 0.4),
            "peach": acc["orange"],
            "yellow": acc["yellow"],
            "green": acc["green"],
            "teal": p.get("teal") or cyan,
            "sky": p.get("sky") or mix(cyan, blue, 0.35),
            "sapphire": p.get("sapphire") or mix(cyan, blue, 0.65),
            "blue": blue,
            "lavender": p.get("lavender") or mix(blue, purple, 0.5),
        }
    )

    for k, c in [("klink", blue), ("kvisited", purple), ("knegative", red), ("kneutral", acc["orange"]), ("kpositive", acc["green"])]:
        m[k] = c
        m[f"{k}Selection"] = c

    m.update(
        {
            "text": fg,
            "subtext1": r["subtext1"],
            "subtext0": r["subtext0"],
            "overlay2": r["overlay2"],
            "overlay1": r["overlay1"],
            "overlay0": r["overlay0"],
            "surface2": r["surface2"],
            "surface1": r["surface1"],
            "surface0": r["surface0"],
            "base": bg,
            "mantle": mantle,
            "crust": crust,
        }
    )

    m.update(accent_roles("success", acc["green"]))
    return {k: v.lower() for k, v in m.items()}


def main() -> None:
    out = Path(sys.argv[1])
    reference = Path(sys.argv[2]) if len(sys.argv) > 2 else None
    ref_keys = None
    if reference:
        ref_keys = [line.split(" ")[0] for line in reference.read_text().splitlines() if line.strip()]

    for name, variants in THEMES.items():
        for mode in ("dark", "light"):
            scheme = build(variants[mode], mode)
            if ref_keys is not None:
                missing = [k for k in ref_keys if k not in scheme]
                if missing:
                    print(f"warning: {name}/{mode} lacks upstream keys: {missing}", file=sys.stderr)
            path = out / name / f"{mode}.txt"
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("".join(f"{k} {v}\n" for k, v in scheme.items()))


if __name__ == "__main__":
    main()
