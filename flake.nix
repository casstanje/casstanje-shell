{
  description = "Casstanje's catppuccin hyprland shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, catppuccin, ...}@inputs: let
  in
  {
    homeModules = {
      default = {
        imports = [
          ./modules/casstanje-shell.nix
          catppuccin.homeModules.catppuccin
        ];
      };
    };
  };
}