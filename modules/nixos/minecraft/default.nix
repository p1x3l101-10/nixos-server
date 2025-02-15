{ pkgs, lib, ... }:
let
  curseforge-api-key = "$2a$10$bL4bIL5pUWqfcO7KQtnMReakwtfHbNKh6v1uTpKlzhwoueEJQnPnm";
in
{
  services.minecraft = {
    enable = true;
    generic.pack = "https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_2.7.2_Server_Java_17-21.zip";
    settings = {
      eula = true;
      type = "forge";
      javaVersion = "17-graalvm";
      version = "1.7.10";
      memory = 8;
      port = 25565;
      rconStartup = [];
    };
  };
  environment.persistence."/nix/host/state/Servers/Minecraft".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
