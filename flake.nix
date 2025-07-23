{
  description = "Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    zen-browser.url = "./packages/home-manager/zen-browser";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    bacon.url = "github:Canop/bacon";
    bacon-ls.url = "github:crisidev/bacon-ls";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      hyprpanel,
      zen-browser,
      home-manager,
      bacon,
      bacon-ls,
      ...
    }@inputs:
    let
      modulePath = ./hosts/. + ("/" + builtins.getEnv "TEST") + "/configuration.nix";
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit modulePath;
        };
        modules = [
          {
            nixpkgs.overlays = [
              inputs.hyprpanel.overlay
              inputs.bacon.outputs.overlay.x86_64-linux
              inputs.bacon-ls.outputs.overlay.x86_64-linux
            ];
          }
          ./hosts/default/configuration.nix
          # modulePath
        ];
      };
    };
}
