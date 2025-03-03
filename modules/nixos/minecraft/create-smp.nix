{ ... }:

{
  services.minecraft = {
    enable = true;
    modrinth = {
      mods = {
        projects = [
          "create"
          "almost-unified"
          "emi"
          "emi-ores"
          "jei"
          "lithium"
          "appleskin"
          "modernfix"
          "ferrite-core"
          "elytra-trims"
          "do-a-barrel-roll"
          "doggy-talents-next"
          "no-chat-reports"
          "corpse"
          "create-stones"
          "create-deep-dark"
          "create-copper-zinc"
          "create-renewable-diamonds"
          "create-renewable-netherite"
          "create-renewable-brass"
          "simplest-copper-gear"
          "simplest-paxels"
          "simplest-hammers"
          "simplest-excavators"
          "emi-loot"
          "jade"
          "jade-addons-forge"
          # Addons to wait on:
          /*
          TFMG
          Enchantment industry
          Central Kitchen
          Jetpack
          Big cannons
          TIS-3D
          TIS-Create
          TIS-Advanced
          Some create chunkloader mod
          liquid fuel?
          */
        ];
        downloadDependancies = "required";
        allowedVersionType = "beta";
      };
    };
    settings = {
      version = "1.21.1";
      eula = true;
      javaVersion = "21-alpine";
      type = "neoforge";
      memory = 8;
      port = 25565;
      openFirewall = true;
      whitelist = import ./overrides/whitelist.nix;
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/create-smp".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}