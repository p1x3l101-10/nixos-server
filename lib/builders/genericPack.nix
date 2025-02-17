{ lib, ext }:

{ stdenv ? ext.pkgs.stdenvNoCC
, gnutar ? ext.pkgs.gnutar
, symlinkJoin ? ext.pkgs.symlinkJoin
, name ? "genericPack"
, version ? "1"
, packList
}:

stdenv.mkDerivation rec {
  pname = "${name}-bundle";
  inherit version;
  srcs = packList;
  nativeBuildInputs = [
    gnutar
  ];
  sourceRoot = pname;
  buildPhase = ''
    for pack in $(ls ..); do
      if [[ "$pack" -eq "${pname}" ]]; then
        true
      else
        mv "$pack/*" .
        mv "$pack/.*" .
        rmdir "$pack"
      fi
    done
    tar cvhzf ./out.tar.gz --no-same-permissions --no-same-owner ./*
  '';
  installPhase = ''
    mv ./out.tar.gz $out
    chmod 644 $out
  '';
}