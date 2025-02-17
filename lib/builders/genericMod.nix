{ lib, ext }:

{ stdenv ? ext.pkgs.stdenvNoCC
, name
, version
, file
}:

stdenv.mkDerivation {
  inherit name version;
  src = file;
  sourceRoot = ".";
  buildPhase = ''
    mkdir -p mods
    mv ${file.name} "./mods/${file.name}"
  '';
  installPhase = ''
    mkdir -p $out
    mv mods $out/mods
  '';
}