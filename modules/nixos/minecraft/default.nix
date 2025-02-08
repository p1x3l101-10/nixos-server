{ pkgs, lib, ... }:
let
  curseforge-api-key = "$2a$10$bL4bIL5pUWqfcO7KQtnMReakwtfHbNKh6v1uTpKlzhwoueEJQnPnm";
in
{
  services.minecraft = {
    enable = true;
    curseforge = {
      apiKey = "$2a$10$bL4bIL5pUWqfcO7KQtnMReakwtfHbNKh6v1uTpKlzhwoueEJQnPnm";
      pack = {
        slug = "terrafirmagreg-modern";
        fileId = 6123835;
      };
    };
    modrinth.mods.projects = [
      # Toms
      { modId = "tomstfg-integration"; versionId = "b7OlDn35"; }
      { modId = "toms-storage"; versionId = "UjCLHkAa"; }
      # Immersive Aircraft
      { modId = "iatfg-integration"; versionId = "jXoVQDSZ"; }
      { modId = "immersive-aircraft"; versionId = "BuPtsmaI"; }
      { modId = "man-of-many-planes"; versionId = "uZNB5Zrk"; }
      # Canes
      { modId = "tfc-canes"; versionId = "QohMlQrN"; }
      # Weather
      { modId = "tfc-weather"; versionId = "tf6FcQfM"; }
      { modId = "weather-storms-tornadoes"; versionId = "ZKVtwI5D"; }
      { modId = "coroutil"; versionId = "6rPDKAT8"; }
      # Support indicator
      { modId = "tfc-support-indicator"; versionId = "jeOTOlLX"; }
    ];
    settings = {
      eula = true;
      type = "auto_curseforge";
      javaVersion = 21;
      memory = 8;
      port = 25565;
    };
  };
  environment.persistence."/nix/host/state/Servers/Minecraft".directories = [ "/var/lib/minecraft" ];
}
