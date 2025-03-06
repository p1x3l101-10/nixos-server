{ pkgs, lib, ... }:

{
  services.minecraft = {
    enable = true;
    generic.pack = builtins.toString (lib.internal.builders.genericPack {
      packList = [
        ./overrides/fafoPack
      ];
    });
    curseforge = {
      apiKey = import ./overrides/cfApiKey.nix;
      mods = [
        # Required
        "projecte"
        "team-projecte"
      ];
    };
    modrinth = {
      mods = {
        projects = [
          # Required
          "corpse"
          # Nice to have
          "jei"
          "emi"
          "emi-ores"
          "emi-loot"
          "appleskin"
          # Server-side
          "radium"
          "dynamic-lights"
          "better-spawner-control"
          "modernfix"
          "ferrite-core"
        ];
        downloadDependancies = "required";
        allowedVersionType = "beta";
      };
    };
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
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/fafoPack".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}