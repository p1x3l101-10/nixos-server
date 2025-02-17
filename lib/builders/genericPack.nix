{ lib, ext }:

{ stdenv ? ext.pkgs.stdenvNoCC
, tar ? ext.pkgs.tar
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
    tar cvzf --no-preserve-permissions ./out.tar.gz ./*
  '';
  installPhase = ''
    mv ./out.tar.gz $out
  '';
}