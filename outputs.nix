inputs: let
  lib = inputs.snowfall-lib.mkLib {
    inherit inputs;
    src = ./.;
  };
in lib.mkFlake {
  systems = {
    modules.nixos = with inputs; [
      nixos-home.nixosModules.default
    ];
    hosts.pixels-server.modules = with inputs; [
    ] ++ (with nixos-hardware.nixosModules; [
      common-pc
      common-pc-ssd
      common-cpu-intel-cpu-only
    ]);
  };
  supportedSystems = [ "x86_64-linux" ];
  outputs-builder = channels: {
    formatter = channels.nixpkgs.nixpkgs-fmt;
  };
  aliases.nixosModules.default = "module";
  channels-config = {
    contentAddressedByDefault = true;
    overlays = with inputs; [ nixos-home.overlays.only-nix3 ];
    # List of unfree packages to allow
    # I could enable them all using one config, but that seems unsafe...
    # Make packages work using this one simple trick, Stallman hates him!
    allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [ ];
  };
}
