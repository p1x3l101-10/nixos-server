{ pkgs, ... }:

{
  services.minecraft = {
    enable = true;
    curseforge = {
      apiKey = import ./overrides/cfApiKey.nix;
      mods = [
        "projecte"
        "projectextended"
        "team-projecte"
      ];
    };
    modrinth = {
      mods = {
        projects = [
          "jei"
          "emi"
          "emi-ores"
          "emi-loot"
          "appleskin"
        ];
        downloadDependancies = "required";
        allowedVersionType = "beta";
      };
    };
    settings = {
      version = "1.20.1";
      eula = true;
      java.version = "21-alpine";
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