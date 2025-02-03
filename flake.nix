{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixos-home = {
      url = "github:p1x3l101-10/nixos";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        snowfall-lib.follows = "snowfall-lib";

        impermanence.follows = "impermanence";
        # Note: to keep in line with upstream, run this command to update lock file:
        # `nix flake update --inputs-from 'github:p1x3l101-10/nixos'`
      };
    };
  };
  outputs = inputs: import ./outputs.nix inputs;
}
