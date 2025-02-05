{
  inputs = {
    nixos-home.url = "github:p1x3l101-10/nixos";
    nixpkgs.follows = "nixos-home/nixpkgs";
    snowfall-lib.follows = "nixos-home/snowfall-lib";
    lanzaboote.follows = "nixos-home/lanzaboote";
    disko.follows = "nixos-home/disko";
    impermanence.follows = "nixos-home/impermanence";
    nixos-hardware.follows = "nixos-home/nixos-hardware";
  };
  outputs = inputs: import ./outputs.nix inputs;
}
