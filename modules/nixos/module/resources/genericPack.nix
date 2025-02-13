{ lib
, stdenvNoCC
, zip
, src
}:

stdenvNoCC.mkDerivation {
  pname = "genericPack";
  version = "1";
  inherit src;
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