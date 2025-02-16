{ pkgs, lib, ... }:
let
  curseforge-api-key = "$2a$10$bL4bIL5pUWqfcO7KQtnMReakwtfHbNKh6v1uTpKlzhwoueEJQnPnm";
in
{
  services.minecraft = {
    enable = true;
    generic.pack = builtins.toString (pkgs.fetchurl {
      url = "https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_2.7.2_Server_Java_17-21.zip";
      hash = "sha256-IDf53ScNurrewUBbAw5McmzXXuCyRbLs+F0ObY3wUlg=";
    });
    settings = {
      eula = true;
      type = "custom";
      javaVersion = "21-graalvm";
      version = "1.7.10";
      memory = 8;
      port = 25565;
      rconStartup = [
        "bq_admin default load" # Reload for updates
        "bq_admin hardcore true"
      ];
      customServer = "lwjgl3ify-forgePatches.jar";
      jvmOpts = "-Dfml.readTimeout=180 @java9args.txt";
      whitelist = [
        "P1x3l101"
      ];
    };
  };
  virtualisation.oci-containers.containers.minecraft.volumes = [
    "/var/lib/minecraft/visualprospecting:/data/visualprospecting:rw"
    "/var/lib/minecraft/journeymap:/data/journeymap:rw"
    "/var/lib/minecraft/TCNodeTracker:/data/TCNodeTracker:rw"
    "/var/lib/minecraft/schematics:/data/schematics:rw"
  ];
  systemd.tmpfiles.settings."50-minecraft" = {
    "/var/lib/minecraft/visualprospecting".d = {
      user = "1000";
      group = "1000";
      mode = "0755";
    };
    "/var/lib/minecraft/journeymap".d = {
      user = "1000";
      group = "1000";
      mode = "0755";
    };
    "/var/lib/minecraft/TCNodeTracker".d = {
      user = "1000";
      group = "1000";
      mode = "0755";
    };
    "/var/lib/minecraft/schematics".d = {
      user = "1000";
      group = "1000";
      mode = "0755";
    };
  };
  environment.persistence."/nix/host/state/Servers/Minecraft".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
