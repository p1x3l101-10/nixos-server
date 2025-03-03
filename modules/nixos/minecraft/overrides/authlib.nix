{ pkgs, ... }:

let
  authlib = pkgs.fetchurl {
    url = "https://authlib-injector.yushi.moe/artifact/53/authlib-injector-1.2.5.jar";
    sha256 = "3bc9ebdc583b36abd2a65b626c4b9f35f21177fbf42a851606eaaea3fd42ee0f";
  };
in {
  virtualisation.oci-containers.containers.minecraft = {
    environment = {
      JVM_OPTS = "-javaagent:${authlib}=ely.by";
    };
    volumes = [
      "/nix/store:/nix/store:ro"
    ];
  };
}