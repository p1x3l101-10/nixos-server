{
  inputs = {
    nixos-home.url = "github:p1x3l101-10/nixos";
    nixpkgs.follows = "nixos-home";
    snowfall-lib.follows = "nixos-home";
    lanzaboote.follows = "nixos-home";
    disko.follows = "nixos-home";
    peerix.follows = "nixos-home";
    impermanence.follows = "nixos-home";
  };
  outputs = inputs: import ./outputs.nix inputs;
}
