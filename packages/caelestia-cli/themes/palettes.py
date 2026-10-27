"""The curated theme list: ten families, each with a dark and a light variant.

Colours are the themes' canonical palettes. Per variant:
  bg, fg                      required
  mantle, crust               optional darker/deeper backgrounds
  surface0..2, overlay0..2,   optional neutral ramp steps (bg -> fg); missing
  subtext0..1                 ones are interpolated between given neighbours
  red orange yellow green     required accents
  cyan blue purple pink
  primary/secondary/tertiary  accent name (or hex) used for the material roles
  bright                      optional {accent: hex} for terminal bright colours
  term                        optional full 16-colour terminal palette
  teal sky sapphire lavender  optional extra catppuccin-style names
  rosewater flamingo maroon

The families are picked to spread over the colour wheel so that most
wallpapers have a reasonably close match: violet, rose, magenta, navy, ice,
teal, green, amber, ink and neutral paper.
"""

THEMES = {
    "catppuccin": {
        # Mocha
        "dark": {
            "bg": "1e1e2e", "mantle": "181825", "crust": "11111b",
            "surface0": "313244", "surface1": "45475a", "surface2": "585b70",
            "overlay0": "6c7086", "overlay1": "7f849c", "overlay2": "9399b2",
            "subtext0": "a6adc8", "subtext1": "bac2de", "fg": "cdd6f4",
            "red": "f38ba8", "orange": "fab387", "yellow": "f9e2af", "green": "a6e3a1",
            "cyan": "94e2d5", "blue": "89b4fa", "purple": "cba6f7", "pink": "f5c2e7",
            "teal": "94e2d5", "sky": "89dceb", "sapphire": "74c7ec", "lavender": "b4befe",
            "rosewater": "f5e0dc", "flamingo": "f2cdcd", "maroon": "eba0ac",
            "primary": "purple", "secondary": "blue", "tertiary": "pink",
        },
        # Latte
        "light": {
            "bg": "eff1f5", "mantle": "e6e9ef", "crust": "dce0e8",
            "surface0": "ccd0da", "surface1": "bcc0cc", "surface2": "acb0be",
            "overlay0": "9ca0b0", "overlay1": "8c8fa1", "overlay2": "7c7f93",
            "subtext0": "6c6f85", "subtext1": "5c5f77", "fg": "4c4f69",
            "red": "d20f39", "orange": "fe640b", "yellow": "df8e1d", "green": "40a02b",
            "cyan": "179299", "blue": "1e66f5", "purple": "8839ef", "pink": "ea76cb",
            "teal": "179299", "sky": "04a5e5", "sapphire": "209fb5", "lavender": "7287fd",
            "rosewater": "dc8a78", "flamingo": "dd7878", "maroon": "e64553",
            "primary": "purple", "secondary": "blue", "tertiary": "pink",
        },
    },
    "rosepine": {
        # Rosé Pine (main)
        "dark": {
            "bg": "191724", "surface0": "26233a", "surface1": "403d52", "surface2": "524f67",
            "overlay0": "6e6a86", "subtext0": "908caa", "fg": "e0def4",
            "red": "eb6f92", "orange": "ebbcba", "yellow": "f6c177", "green": "31748f",
            "cyan": "9ccfd8", "blue": "9ccfd8", "purple": "c4a7e7", "pink": "ebbcba",
            "term": [
                "26233a", "eb6f92", "31748f", "f6c177", "9ccfd8", "c4a7e7", "ebbcba", "e0def4",
                "6e6a86", "eb6f92", "31748f", "f6c177", "9ccfd8", "c4a7e7", "ebbcba", "e0def4",
            ],
            "primary": "ebbcba", "secondary": "purple", "tertiary": "cyan",
        },
        # Rosé Pine Dawn
        "light": {
            "bg": "faf4ed", "surface0": "f2e9e1", "surface1": "dfdad9", "surface2": "cecacd",
            "overlay0": "9893a5", "subtext0": "797593", "fg": "575279",
            "red": "b4637a", "orange": "d7827e", "yellow": "ea9d34", "green": "286983",
            "cyan": "56949f", "blue": "56949f", "purple": "907aa9", "pink": "d7827e",
            "term": [
                "f2e9e1", "b4637a", "286983", "ea9d34", "56949f", "907aa9", "d7827e", "575279",
                "9893a5", "b4637a", "286983", "ea9d34", "56949f", "907aa9", "d7827e", "575279",
            ],
            "primary": "d7827e", "secondary": "purple", "tertiary": "cyan",
        },
    },
    "dracula": {
        # Dracula
        "dark": {
            "bg": "282a36", "mantle": "21222c", "crust": "191a21",
            "surface1": "44475a", "overlay0": "6272a4", "fg": "f8f8f2",
            "red": "ff5555", "orange": "ffb86c", "yellow": "f1fa8c", "green": "50fa7b",
            "cyan": "8be9fd", "blue": "bd93f9", "purple": "bd93f9", "pink": "ff79c6",
            "bright": {
                "red": "ff6e6e", "green": "69ff94", "yellow": "ffffa5",
                "blue": "d6acff", "purple": "ff92df", "cyan": "a4ffff",
            },
            "primary": "purple", "secondary": "pink", "tertiary": "cyan",
        },
        # Alucard
        "light": {
            "bg": "fffbeb", "surface1": "cfcfde", "overlay2": "6c664b", "fg": "1f1f1f",
            "red": "cb3a2a", "orange": "a34d14", "yellow": "846e15", "green": "14710a",
            "cyan": "036a96", "blue": "644ac9", "purple": "644ac9", "pink": "a3144d",
            "primary": "purple", "secondary": "pink", "tertiary": "cyan",
        },
    },
    "tokyonight": {
        # Night
        "dark": {
            "bg": "1a1b26", "mantle": "16161e", "crust": "0f0f14",
            "surface0": "292e42", "surface1": "3b4261", "surface2": "414868",
            "overlay0": "545c7e", "overlay1": "565f89", "overlay2": "737aa2",
            "subtext1": "a9b1d6", "fg": "c0caf5",
            "red": "f7768e", "orange": "ff9e64", "yellow": "e0af68", "green": "9ece6a",
            "cyan": "7dcfff", "blue": "7aa2f7", "purple": "bb9af7", "pink": "ff007c",
            "teal": "1abc9c", "sapphire": "2ac3de", "lavender": "9d7cd8",
            "primary": "blue", "secondary": "purple", "tertiary": "cyan",
        },
        # Day
        "light": {
            "bg": "e1e2e7", "mantle": "d0d5e3", "crust": "c4c8da",
            "surface0": "c4c8da", "surface1": "a8aecb", "surface2": "a1a6c5",
            "overlay0": "8990b3", "overlay1": "848cb5", "overlay2": "68709a",
            "subtext1": "6172b0", "fg": "3760bf",
            "red": "f52a65", "orange": "b15c00", "yellow": "8c6c3e", "green": "587539",
            "cyan": "007197", "blue": "2e7de9", "purple": "9854f1", "pink": "d20065",
            "teal": "118c74", "sapphire": "188092", "lavender": "7847bd",
            "primary": "blue", "secondary": "purple", "tertiary": "cyan",
        },
    },
    "nord": {
        # Nord (Polar Night)
        "dark": {
            "bg": "2e3440", "mantle": "272c36", "crust": "222730",
            "surface0": "3b4252", "surface1": "434c5e", "surface2": "4c566a",
            "overlay1": "616e88", "subtext1": "d8dee9", "fg": "eceff4",
            "red": "bf616a", "orange": "d08770", "yellow": "ebcb8b", "green": "a3be8c",
            "cyan": "88c0d0", "blue": "81a1c1", "purple": "b48ead", "pink": "b48ead",
            "teal": "8fbcbb", "sapphire": "5e81ac",
            "primary": "cyan", "secondary": "blue", "tertiary": "purple",
        },
        # Nord on Snow Storm; aurora/frost darkened (same hue) to stay readable
        "light": {
            "bg": "eceff4", "mantle": "e5e9f0", "crust": "d8dee9",
            "surface0": "d8dee9", "overlay2": "4c566a", "subtext0": "434c5e",
            "subtext1": "3b4252", "fg": "2e3440",
            "red": "b55861", "orange": "a7624c", "yellow": "8d7030", "green": "637c4d",
            "cyan": "457c8b", "blue": "5477a1", "purple": "8d6987", "pink": "8d6987",
            "teal": "507b7b", "sapphire": "5e81ac",
            "primary": "blue", "secondary": "cyan", "tertiary": "purple",
        },
    },
    "solarized": {
        "dark": {
            "bg": "002b36", "surface0": "073642", "overlay0": "586e75", "overlay1": "657b83",
            "subtext1": "839496", "fg": "93a1a1",
            "red": "dc322f", "orange": "cb4b16", "yellow": "b58900", "green": "859900",
            "cyan": "2aa198", "blue": "268bd2", "purple": "6c71c4", "pink": "d33682",
            "primary": "blue", "secondary": "cyan", "tertiary": "yellow",
        },
        "light": {
            "bg": "fdf6e3", "mantle": "eee8d5", "surface0": "eee8d5",
            "overlay0": "93a1a1", "overlay1": "839496", "subtext0": "657b83", "fg": "586e75",
            "red": "dc322f", "orange": "cb4b16", "yellow": "b58900", "green": "859900",
            "cyan": "2aa198", "blue": "268bd2", "purple": "6c71c4", "pink": "d33682",
            "primary": "blue", "secondary": "cyan", "tertiary": "yellow",
        },
    },
    "everforest": {
        # Everforest dark, medium contrast
        "dark": {
            "bg": "2d353b", "mantle": "232a2e", "crust": "1e2326",
            "surface0": "3d484d", "surface1": "475258", "surface2": "56635f",
            "overlay0": "7a8478", "overlay1": "859289", "overlay2": "9da9a0", "fg": "d3c6aa",
            "red": "e67e80", "orange": "e69875", "yellow": "dbbc7f", "green": "a7c080",
            "cyan": "83c092", "blue": "7fbbb3", "purple": "d699b6", "pink": "d699b6",
            "primary": "green", "secondary": "cyan", "tertiary": "orange",
        },
        # Everforest light, medium contrast
        "light": {
            "bg": "fdf6e3", "mantle": "f4f0d9", "crust": "efebd4",
            "surface0": "e6e2cc", "surface1": "e0dcc7", "surface2": "bdc3af",
            "overlay0": "a6b0a0", "overlay1": "939f91", "overlay2": "829181", "fg": "5c6a72",
            "red": "f85552", "orange": "f57d26", "yellow": "dfa000", "green": "8da101",
            "cyan": "35a77c", "blue": "3a94c5", "purple": "df69ba", "pink": "df69ba",
            "primary": "green", "secondary": "cyan", "tertiary": "orange",
        },
    },
    "gruvbox": {
        # Gruvbox dark, medium
        "dark": {
            "bg": "282828", "mantle": "1d2021", "crust": "151718",
            "surface0": "3c3836", "surface1": "504945", "surface2": "665c54",
            "overlay0": "7c6f64", "overlay1": "928374", "overlay2": "a89984",
            "subtext0": "bdae93", "subtext1": "d5c4a1", "fg": "ebdbb2",
            "red": "fb4934", "orange": "fe8019", "yellow": "fabd2f", "green": "b8bb26",
            "cyan": "8ec07c", "blue": "83a598", "purple": "d3869b", "pink": "d3869b",
            "term": [
                "282828", "cc241d", "98971a", "d79921", "458588", "b16286", "689d6a", "a89984",
                "928374", "fb4934", "b8bb26", "fabd2f", "83a598", "d3869b", "8ec07c", "ebdbb2",
            ],
            "primary": "yellow", "secondary": "cyan", "tertiary": "orange",
        },
        # Gruvbox light, medium
        "light": {
            "bg": "fbf1c7", "mantle": "f2e5bc", "crust": "ebdbb2",
            "surface0": "ebdbb2", "surface1": "d5c4a1", "surface2": "bdae93",
            "overlay0": "a89984", "overlay1": "928374", "overlay2": "7c6f64",
            "subtext0": "665c54", "subtext1": "504945", "fg": "3c3836",
            "red": "9d0006", "orange": "af3a03", "yellow": "b57614", "green": "79740e",
            "cyan": "427b58", "blue": "076678", "purple": "8f3f71", "pink": "8f3f71",
            "term": [
                "fbf1c7", "cc241d", "98971a", "d79921", "458588", "b16286", "689d6a", "7c6f64",
                "928374", "9d0006", "79740e", "b57614", "076678", "8f3f71", "427b58", "3c3836",
            ],
            "primary": "yellow", "secondary": "cyan", "tertiary": "orange",
        },
    },
    "kanagawa": {
        # Wave
        "dark": {
            "bg": "1f1f28", "mantle": "1a1a22", "crust": "16161d",
            "surface0": "2a2a37", "surface1": "363646", "surface2": "54546d",
            "overlay0": "727169", "subtext1": "c8c093", "fg": "dcd7ba",
            "red": "e46876", "orange": "ffa066", "yellow": "e6c384", "green": "98bb6c",
            "cyan": "7aa89f", "blue": "7e9cd8", "purple": "957fb8", "pink": "d27e99",
            "sky": "7fb4ca", "lavender": "9cabca", "maroon": "c34043",
            "term": [
                "16161d", "c34043", "76946a", "c0a36e", "7e9cd8", "957fb8", "6a9589", "c8c093",
                "727169", "e82424", "98bb6c", "e6c384", "7fb4ca", "938aa9", "7aa89f", "dcd7ba",
            ],
            "primary": "blue", "secondary": "yellow", "tertiary": "orange",
        },
        # Lotus
        "light": {
            "bg": "f2ecbc", "mantle": "e5ddb0", "crust": "dcd5ac",
            "surface0": "e7dba0", "surface1": "d5cea3", "overlay0": "a09cac",
            "overlay1": "8a8980", "overlay2": "716e61", "fg": "545464",
            "red": "c84053", "orange": "cc6d00", "yellow": "77713f", "green": "6f894e",
            "cyan": "597b75", "blue": "4d699b", "purple": "624c83", "pink": "b35b79",
            "sky": "4e8ca2", "lavender": "766b90", "maroon": "d7474b",
            "term": [
                "1f1f28", "c84053", "6f894e", "77713f", "4d699b", "b35b79", "597b75", "545464",
                "8a8980", "d7474b", "6e915f", "836f4a", "6693bf", "624c83", "5e857a", "43436c",
            ],
            "primary": "blue", "secondary": "yellow", "tertiary": "orange",
        },
    },
    "flexoki": {
        "dark": {
            "bg": "100f0f", "mantle": "0b0a0a", "crust": "080707",
            "surface0": "282726", "surface1": "343331", "surface2": "403e3c",
            "overlay0": "575653", "overlay1": "6f6e69", "overlay2": "878580", "fg": "cecdc3",
            "red": "d14d41", "orange": "da702c", "yellow": "d0a215", "green": "879a39",
            "cyan": "3aa99f", "blue": "4385be", "purple": "8b7ec8", "pink": "ce5d97",
            "primary": "cyan", "secondary": "orange", "tertiary": "purple",
        },
        "light": {
            "bg": "fffcf0", "mantle": "f2f0e5", "crust": "e6e4d9",
            "surface0": "e6e4d9", "surface1": "dad8ce", "surface2": "cecdc3",
            "overlay0": "b7b5ac", "overlay1": "878580", "overlay2": "6f6e69",
            "subtext0": "575653", "subtext1": "403e3c", "fg": "100f0f",
            "red": "af3029", "orange": "bc5215", "yellow": "ad8301", "green": "66800b",
            "cyan": "24837b", "blue": "205ea6", "purple": "5e409d", "pink": "a02f6f",
            "primary": "cyan", "secondary": "orange", "tertiary": "purple",
        },
    },
}
