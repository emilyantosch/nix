{
  description = "Nixos config flake";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qs-caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qs-caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    zen-browser.url = "./packages/home-manager/zen-browser";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    bacon.url = "github:Canop/bacon";
    bacon-ls.url = "github:crisidev/bacon-ls";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sherlock.url = "github:Skxxtz/sherlock";
    nyx.url = "./packages/nvix";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin-modules.url = "./modules/nix_darwin";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    copyparty.url = "github:9001/copyparty";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      darwin-modules,
      nyx,
      hyprpanel,
      zen-browser,
      home-manager,
      bacon,
      bacon-ls,
      niri,
      qs-caelestia-cli,
      qs-caelestia-shell,
      copyparty,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      modulePath = ./hosts/. + ("/" + builtins.getEnv "TEST") + "/configuration.nix";
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit modulePath;
          inherit system;
        };
        modules = [
        copyparty.nixosModules.default
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

      darwinConfigurations.emmiMBP = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
          inherit modulePath;
          inherit system;
        };
        modules = [
          ./hosts/emmiMBP/configuration.nix
          inputs.darwin-modules.modules.bare
          inputs.darwin-modules.modules.home

        home-manager.darwinModules.home-manager {
          # home-manager.useGlobalPkgs = true;
          # home-manger.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.emmi = import ./hosts/emmiMBP/home.nix;
        }
        ];

      };

      darwinConfigurations.emilyantoschMBP = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
          inherit modulePath;
          inherit system;
        };
        modules = [
          ./hosts/emilyantoschMBP/configuration.nix
          inputs.darwin-modules.modules.bare
          inputs.darwin-modules.modules.home

        home-manager.darwinModules.home-manager {
          # home-manager.useGlobalPkgs = true;
          # home-manger.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users."emilylucia.antosch" = import ./hosts/emilyantoschMBP/home.nix;
        }
        ];

      };
  };
}
