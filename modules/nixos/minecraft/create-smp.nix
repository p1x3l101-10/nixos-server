{ ... }:

{
  services.minecraft = {
    enable = true;
    modrinth = {
      mods = [
        "create"
        "create-steam-n-rails"
        "create-jetpack"
        "create-ore-excavation"
        "create-enchantment-industry"
        "create-central-kitchen"
        "interactive"
        "create-power-loader"
        "create-tfmg"
        "create-liquid-fuel"
        "create-armory"
        "create-big-cannons-advanced-technologies"
        "create-clockwork"
        "trackwork"
        "tis3d"
        "tis-create"
        "tis-advanced"
        "almost-unified"
        "ae2"
        "applied-energistics-2-wireless-terminals"
        "create-applied-kinetics"
        "createcrushingae"
        "emi"
        "jei"
        "lithium"
      ];
      downloadDependancies = "required";
    };
    settings = {
      version = "1.20.1";
      eula = true;
      javaVersion = "21-alpine";
      type = "forge";
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