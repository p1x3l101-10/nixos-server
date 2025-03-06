{ pkgs, lib, ... }:

{
  services.minecraft = {
    enable = true;
    generic.pack = builtins.toString (lib.internal.builders.genericPack {
      packList = [
        ./overrides/fafoPack
      ];
    });
    settings = {
      version = "1.20.1";
      eula = true;
      java.version = "21-graalvm";
      type = "neoforge";
      memory = 8;
      port = 25565;
      openFirewall = true;
      whitelist = import ./overrides/whitelist.nix;
      rconStartup = [
        "gamerule playersSleepingPercentage 10"
      ];
      ops = [
        "P1x3l101"
      ];
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/fafoPack".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}