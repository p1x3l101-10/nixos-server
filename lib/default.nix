{ lib, inputs, namespace, snowfall-inputs }:

let
  inherit (lib.nixos-home.internal) genLib callLibPrimitive;
  genLib1 = genLib callLibPrimitive;
in genLib1 ./. [
  "minecraft"
  "sss"
]