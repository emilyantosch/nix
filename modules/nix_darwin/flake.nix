{
  description = "Nix-Darwin Flake Parts";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
        flake-parts,
        ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        ...
      }:
      {
        imports = [
          ./plugins
          ./modules/flake
        ];
      }
    );
    
}
