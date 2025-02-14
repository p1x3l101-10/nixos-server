{ lib
, stdenvNoCC
, nix-prefetch-docker
}:

stdenvNoCC.mkDerivation rec {
  pname = "update-minecraft";
  version = "1";
  src = ./.;
  buildInputs = [
    nix-prefetch-docker
  ];
  buildPhase = ''
    chmod +x ./update.bash
  '';
  installPhase = ''
    mkdir -p $out/bin
    mv ./update.bash $out/bin/${pname}
  '';
}