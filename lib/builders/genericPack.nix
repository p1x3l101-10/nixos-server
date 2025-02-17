{ lib, ext }:

{ stdenv ? ext.pkgs.stdenvNoCC
, gnutar ? ext.pkgs.gnutar
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
    gnutar
  ];
  buildPhase = ''
    mkdir -p ./config ./mods
    chmod -R 775 ./*
    touch ./config/.keep
    touch ./mods/.keep
    tar cvhzf ./out.tar.gz --no-same-permissions --no-same-owner ./*
  '';
  installPhase = ''
    mv ./out.tar.gz $out
  '';
}