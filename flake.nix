{
  description = "Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "./packages/home-manager/zen-browser";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, hyprpanel, zen-browser, home-manager,... }@inputs: let
      modulePath = ./hosts/. + ("/" + builtins.getEnv "TEST") + "/configuration.nix";
    in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit modulePath;
      };
      modules = [
        {nixpkgs.overlays = [inputs.hyprpanel.overlay];}
        # ./hosts/default/configuration.nix
        modulePath
      ];
    };
  };
}
