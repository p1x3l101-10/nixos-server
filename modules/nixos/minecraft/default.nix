{ pkgs, lib, ... }:
let
  curseforge-api-key = "$2a$10$bL4bIL5pUWqfcO7KQtnMReakwtfHbNKh6v1uTpKlzhwoueEJQnPnm";
in
{
  services.minecraft = {
    enable = true;
    settings = {
      eula = true;
      type = "forge";
      version = "1.19.2";
      javaVersion = 17;
      memory = 8;
      port = 25565;
      extraEnv = {
        GENERIC_PACK = "file://" + (pkgs.callPackage ./genericPack.nix {});
      };
      rconStartup = [];
    };
  };
  environment.persistence."/nix/host/state/Servers/Minecraft".directories = [ "/var/lib/minecraft" ];
}
