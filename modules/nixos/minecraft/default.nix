{ pkgs, lib, ... }:
let
  curseforge-api-key = "$2a$10$bL4bIL5pUWqfcO7KQtnMReakwtfHbNKh6v1uTpKlzhwoueEJQnPnm";
in {
  virtualisation.oci-containers.containers.minecraft = {
    environment = {
       EULA = "TRUE";
       CF_API_KEY = curseforge-api-key;
       MEMORY = "8G";
       TYPE = "AUTO_CURSEFORGE";
       CF_SLUG = "terrafirmagreg-modern";
       CF_FILE_ID = "6123835";
       MODRINTH_PROJECTS = ''
        tomstfg-integration:b7OlDn35
        toms-storage:UjCLHkAa
       '' + ''
        iatfg-integration:jXoVQDSZ
        immersive-aircraft:BuPtsmaI
        man-of-many-planes:uZNB5Zrk
       '' + ''
        tfc-canes:QohMlQrN
       '';
    };
    image = "internal/docker-minecraft:latest";
    imageFile = pkgs.internal.dockerMinecraft;
    ports = [
      "25565:25565"
    ];
    volumes = [
      "/var/lib/minecraft/data:/data:rw"
    ];
    autoStart = true;
  };
  systemd.tmpfiles.settings."10-minecraft" = {
    "/var/lib/minecraft".d = {
      user = "root";
      group = "root";
      mode = "0755";
    };
    "/var/lib/minecraft/data".d = {
      user = "root";
      group = "root";
      mode = "0755";
    };
  };
  environment.persistence."/nix/host/state/Servers/Minecraft".directories = [ "/var/lib/minecraft" ];
}