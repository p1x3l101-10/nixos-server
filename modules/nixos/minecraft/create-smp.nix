{ ... }:

{
  services.minecraft = {
    enable = true;
    modrinth = {
      mods = [
        "create"
        "create-steam-n-rails"
        "create-jetpack"
        "create-enchantment-industry"
        "create-central-kitchen"
        "create-power-loader"
        "create-tfmg"
        "create-liquid-fuel"
        "create-armory"
        "create-big-cannons"
        "create-big-cannons-advanced-technologies"
        "tis3d"
        "tis-create"
        "tis-advanced"
        "almost-unified"
        "emi"
        "emi-ores"
        "jei"
        "lithium"
        "starlight-forge"
        "appleskin"
        "nochatreports"
        "modernfix"
        "ferrite-core"

      ];
      downloadDependancies = "required";
    };
    settings = {
      version = "1.20.1";
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