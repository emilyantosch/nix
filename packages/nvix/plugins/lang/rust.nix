{
  plugins = {
    rustaceanvim.enable = true;
    crates.enable = true;

    conform-nvim.settings = {
      formatters_by_ft.rust = ["rustfmt"];
      formatters.rustfmt = {
        command = "rustfmt +nightly-2025-11-08";
      };
      };
    };
  }
