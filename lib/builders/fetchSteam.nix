{
  lib,
  stdenvNoCC,
  depotdownloader,
  cacert,
  writeText,
}: {
  name,
  debug ? false,
  appId,
  depotId ? "",
  manifestId ? "",
  workshopId ? "",
  branch ? null,
  fileList ? [],
  hash,
}: let
  fileListFile = let
    content = lib.concatStringsSep "\n" fileList;
  in
    writeText "steam-file-list-${name}.txt" content;
in
  stdenvNoCC.mkDerivation {
    name = "${name}-depot";
    inherit debug appId depotId manifestId workshopId branch;
    filelist =
      if fileList != []
      then fileListFile
      else null;
    builder = ./fetchSteam.sh;
    buildInputs = [
      depotdownloader
    ];
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    outputHash = hash;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  }