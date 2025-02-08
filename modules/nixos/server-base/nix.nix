{ inputs, lib, ... }:

{
  # Trust noone, not even yourself
  nix.settings = {
    substitute = false;
    substituters = lib.mkForce [];
    extra-substituters = lib.mkForce [];
    registry = lib.nixos-home.confTemplates.registry inputs;
  };
}