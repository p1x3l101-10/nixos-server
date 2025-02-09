{ lib, inputs, namespace, snowfall-inputs }:

lib.nixos-home.internal.genLib ./. [
  "minecraft"
]