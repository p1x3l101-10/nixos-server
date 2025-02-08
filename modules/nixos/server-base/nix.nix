{ inputs, lib, ... }:

{
  # Trust noone, not even yourself
  nix.settings = {
    substitute = false;
    substituters = lib.mkForce [];
    extra-substituters = lib.mkForce [];
    registry = inputs.nixos-home.lib.confTemplates.registry inputs;
  };
}