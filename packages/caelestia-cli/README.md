# Caelestia CLI + curated wallpaper themes

The Caelestia CLI with an extra scheme, `curated`: ten hand-picked themes, each
with a dark and a light variant. Whenever the wallpaper changes, `caelestia-theme`
ranks the ten against the wallpaper and applies the best one. The colours always
come from the themes' own palettes, never from the picture.

| theme        | dark            | light           |
| ------------ | --------------- | --------------- |
| `catppuccin` | Mocha           | Latte           |
| `rosepine`   | Rosé Pine       | Dawn            |
| `dracula`    | Dracula         | Alucard         |
| `tokyonight` | Night           | Day             |
| `nord`       | Polar Night     | Snow Storm      |
| `solarized`  | Dark            | Light           |
| `everforest` | Dark (medium)   | Light (medium)  |
| `gruvbox`    | Dark (medium)   | Light (medium)  |
| `kanagawa`   | Wave            | Lotus           |
| `flexoki`    | Dark            | Light           |

## Usage

| what                         | how                                                            |
| ---------------------------- | -------------------------------------------------------------- |
| auto-pick on wallpaper change | `wallpaper.postHook` in `foreign/caelestia/cli.json`          |
| next / previous best match   | `Super+T` / `Super+Shift+T` (`caelestia-theme next`/`prev`)    |
| pick a theme by name         | `caelestia-theme set kanagawa`, or the launcher: `>scheme curated` |
| back to the automatic pick   | `caelestia-theme auto`                                         |
| dark ↔ light                 | `Super+Ctrl+T`, `caelestia-theme mode [dark\|light\|toggle]`, or the shell's own toggle |
| see why a theme was picked   | `caelestia-theme rank [WALLPAPER] [-m dark\|light]`            |

Dark/light is simply the current scheme mode; switching it keeps the theme. A
theme chosen with `set`/`next`/`prev` is pinned to that wallpaper
(`~/.local/state/caelestia/curated-themes.json`) and comes back with it.
Choosing a built-in scheme from the launcher works too, but only until the
next wallpaper change.

## How it works

- `themes/palettes.py` holds the canonical colours. `themes/gen_schemes.py` turns
  them into Caelestia's 110-key scheme files at build time (material roles,
  catppuccin-style names, terminal and KDE colours), mixing in OKLab so derived
  shades keep each theme's tint. Material accent roles get nudged to at least
  3:1 contrast against surfaces. The named colours stay canonical.
- `caelestia-theme.py` compares the wallpaper and each theme as hue
  distributions in OKLab, weighted by chroma, plus how muted or vivid they are.
  Lightness is ignored, so the same ranking works for both modes. The more
  grey a wallpaper is, the less its hues count.

To change the selection, edit `palettes.py` (any key set works as long as every
theme has `dark` and `light`) and rebuild.
