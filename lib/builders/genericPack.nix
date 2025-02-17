{ lib, ext }:

{ stdenv ? ext.pkgs.stdenvNoCC
, zip ? ext.pkgs.zip
, symlinkJoin ? ext.pkgs.symlinkJoin
, name ? "genericPack"
, version ? "1"
, packList
}:

let
  src = symlinkJoin {
    inherit name;
    paths = packList;
  };
in

stdenv.mkDerivation {
  pname = "${name}-bundle";
  inherit version src;
  nativeBuildInputs = [
    zip
  ];
  buildPhase = ''
    mkdir -p ./config ./mods
    touch ./config/.keep
    touch ./mods/.keep
    zip -r ./out.zip ./*
  '';
  installPhase = ''
    mv ./out.zip $out
  '';
}