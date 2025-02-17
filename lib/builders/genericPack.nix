{ lib, ext }:

{ stdenv ? ext.pkgs.stdenvNoCC
, gnutar ? ext.pkgs.gnutar
, symlinkJoin ? ext.pkgs.symlinkJoin
, name ? "genericPack"
, version ? "1"
, packList
}:

stdenv.mkDerivation {
  pname = "${name}-bundle";
  inherit version;
  srcs = packList;
  nativeBuildInputs = [
    gnutar
  ];
  buildPhase = ''
    for pack in $(ls); do
      mv "$pack/*" .
      mv "$pack/.*" .
      rmdir "$pack"
    done
    tar cvhzf ./out.tar.gz --no-same-permissions --no-same-owner ./*
  '';
  installPhase = ''
    mv ./out.tar.gz $out
    chmod 644 $out
  '';
}