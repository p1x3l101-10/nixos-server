{ lib
, dockerTools
, imageName ? "itzg/minecraft-server"
, imageDigest ? "sha256:9fcc91f052c47c5da7ae280b7cd1603ee7d657867c19fe4d6b5260edfd72db30"
, sha256 ? "sha256-VzIfANTMDH3dyc5Icju1b+M9yG8LHyoQdzu4MxwAWS0="
}:

dockerTools.pullImage {
  inherit imageName imageDigest sha256;
  finalImageName = "internal/docker-minecraft";
  finalImageTag = "latest";
}
