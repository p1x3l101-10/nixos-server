{ lib, ext }:

{ stdenv ? ext.pkgs.stdenvNoCC
, bsdtar ? ext.pkgs.bsdtar
, rsync ? ext.pkgs.rsync
, name ? "genericPack"
, version ? "1"
, packList
}:

stdenv.mkDerivation rec {
  pname = "${name}-bundle";
  inherit version;
  srcs = packList;
  nativeBuildInputs = [
    rsync
    gnutar
  ];
  sourceRoot = ".";
  buildPhase = ''
    mkdir .work
    if [[ -e overrides ]]; then
      mv overrides z-overrides
    fi
    for pack in $(ls .); do
      if [[ -d "$pack" ]]; then
        rsync -anv "$pack/" .work
      fi
    done
    bsdtar -cvhf ./out.zip --format=zip --no-same-permissions --no-same-owner -C ./.work .
  '';
  installPhase = ''
    mv ./out.zip $out
    chmod 644 $out
  '';
}