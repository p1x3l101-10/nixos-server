#!/usr/bin/env bash

image="docker.io/itzg/minecraft-server"

versions=(
  "8"
  "17-alpine"
  "17-graalvm"
  "21-alpine"
)

for javaVersion in "${versions[@]}"; do
  mkdir -p ./modules/nixos/module/resources/mc-versions
  nix run nixpkgs#nix-prefetch-docker "$image" "java${javaVersion}" --quiet > "./modules/nixos/module/resources/mc-versions/${javaVersion}.nix"
done