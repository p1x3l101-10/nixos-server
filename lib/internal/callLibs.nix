{ lib, ext }:
callLib:

folder:

import folder {
  inherit callLib ext;
  lib = lib.extend (final: prev: {
    inherit builins;
  })
}