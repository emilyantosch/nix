{ pkgs, ... }:
{
  programs.bacon = {
    enable = true;
    settings = {
      exports = {
        cargo-json-spans = {
          auto = true;
          exporter = "analyzer";
          line_format = ''
            {diagnostic.level}|:|{span.file_name}|:|{span.line_start}|:|{span.line_end}|:|\
            {span.column_start}|:|{span.column_end}|:|{diagnostic.message}|:|{diagnostic.rendered}|:|\
            {span.suggested_replacement}
          '';
          path = ".bacon-locations";
        };
      };
      jobs = {
        bacon-ls = {
          command = [
            "cargo"
            "clippy"
            "--all-targets"
            "--all-features"
            "--message-format"
            "json-diagnostic-rendered-ansi"
          ];
          need_stdout = true;
          analyzer = "cargo_json";
        };
        default = {
          command = [
            "cargo"
            "build"
            "--all-features"
            "--color"
            "always"
          ];
          need_stdout = true;
        };
      };
    };
  };
}
