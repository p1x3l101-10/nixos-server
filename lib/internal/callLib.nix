{ lib, ext }:
callLibPrimitive:

path:

let
  fn = callLibPrimitive path;  # Import the function
  argCount = builtins.length (builtins.attrNames (builtins.functionArgs fn));
in

if argCount == 0 then fn
else if argCount == 1 then a: fn a
else if argCount == 2 then a: b: fn a b
else if argCount == 3 then a: b: c: fn a b c
else args: fn args  # For functions with more than 3 args, pass as list or attrset