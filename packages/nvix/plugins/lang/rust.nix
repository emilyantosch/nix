{
  plugins = {
    rustaceanvim.enable = false;
    crates.enable = true;
    lsp.servers.rust-analyzer = {
      enable = true;
      package = null;
      cargoPackage = null;
      rustcPackage = null;
      rustfmtPackage = null;
      # filetypes = ["rs" "toml"];
      settings.rustfmt.extraArgs = ["+nightly-2025-11-03"];
    };
  };
}
