inputs: inputs.snowfall-lib.mkFlake {
  systems = {
    modules.nixos = with inputs; [
      nixos-home.nixosModules.required
    ];
  };
  inherit inputs;
  src = ./.;
  supportedSystems = [ "x86_64-linux" ];
  outputs-builder = channels: {
    formatter = channels.nixpkgs.nixpkgs-fmt;
  };
  channels-config = {
    contentAddressedByDefault = true;
    # List of unfree packages to allow
    # I could enable them all using one config, but that seems unsafe...
    # Make packages work using this one simple trick, Stallman hates him!
    allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [ ];
  };
}
