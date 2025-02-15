{ pkgs, lib, ... }:
let
  curseforge-api-key = "$2a$10$bL4bIL5pUWqfcO7KQtnMReakwtfHbNKh6v1uTpKlzhwoueEJQnPnm";
in
{
  services.minecraft = {
    enable = true;
    modrinth.pack.project = "/global/pack.mrpack";
    settings = {
      eula = true;
      type = "forge";
      javaVersion = "17-graalvm";
      memory = 8;
      port = 25565;
      rconStartup = [];
    };
  };
  environment.persistence."/nix/host/state/Servers/Minecraft".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
