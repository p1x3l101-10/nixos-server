{ inputs, lib, ... }:

{
  # Trust noone, not even yourself
  nix.settings = {
    substitute = false;
    substituters = lib.mkForce [];
    extra-substituters = lib.mkForce [];
  };
  nix.registry = lib.nixos-home.conf-templates.registry inputs;
}