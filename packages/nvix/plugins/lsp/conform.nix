# Formatter with lsp fallback
{ lib, pkgs, ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      default_format_opts.lsp_format = "fallback";
      formatters_by_ft = {
        "_" = [
          "squeeze_blanks"
          "trim_whitespace"
          "trim_newlines"
        ];
      };
      formatters.squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
    };
  };
  autoCmd = [
  {
    event = ["BufWritePre"];
    pattern = "*";
    callback = {
      __raw = ''function(args) require("conform").format({bufnr = args.buf, timeout_ms = 200, lsp_format = "fallback" }) end'';
    };
  }
  ];
}
