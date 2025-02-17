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
  sourceRoot = ".";
  buildPhase = ''
    mkdir .work
    for pack in $(ls .); do
      if [[ -d "$pack" ]]; then
        if [[ -e "$pack/*" ]]; then
          mv "$pack/*" .work
        fi
        if [[ -e "$pack/.*" ]]; then
          mv "$pack/.*" .work
        fi
        rmdir "$pack"
      fi
    done
    tar cvhzf ./out.tar.gz --no-same-permissions --no-same-owner -C ./.work ./*
  '';
  installPhase = ''
    mv ./out.tar.gz $out
    chmod 644 $out
  '';
}