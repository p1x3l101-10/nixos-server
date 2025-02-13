{ lib
, stdenvNoCC
, zip
, src ? null
}:

stdenvNoCC.mkDerivation {
  pname = "genericPack";
  version = "1";
  inherit src;
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