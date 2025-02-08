{ lib, ... }:

let
  ext = {}; # Any extra configuration to be passed to the functions
  # Create temp callLib function and use it to pull in genLib
  c = f: import f { inherit lib ext; };
  genLib = s: a: c ./internal/genLib.nix c s a;
in 
genLib ./. [
  "internal"
  "attrSets"
  "environment"
]