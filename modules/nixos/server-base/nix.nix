{ inputs, lib, ... }:

{
  # Trust noone, not even yourself
  nix.settings = {
    substitute = false;
    substituters = lib.mkForce [];
    extra-substituters = lib.mkForce [];
    registry = (inputs.nixos-home.lib.confTemplates.registry (builtins.removeAttrs inputs ["disko"])) // {
      disko.flake = inputs.disko; # Prints out so many warnings on eval
    };
  };
}