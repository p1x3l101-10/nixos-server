{ lib
, stdenvNoCC
, zip
}:

stdenvNoCC.mkDerivation {
  pname = "genericPack";
  version = "1.0.0";
  src = ./pack;
  nativeBuildInputs = [
    zip
  ];
  buildPhase = ''
    zip -r ./out.zip ./*
  '';
  installPhase = ''
    mv ./out.zip $out
  '';
}