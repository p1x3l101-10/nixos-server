{ ... }:

{
  services.tmodloader = {
    enable = true;
    openFirewall = true;
    difficulty = "journey";
    world = {
      name = "Gallifrey";
      seed = "for the worthy";
    };
    journey.setDifficulty = "all"; # Temp for setting master
    journey = {
      windStrength = "all";
      placementRange = "all";
    };
    port = 24454;
    mods.enabled = [
      # Content Mods
      ## Big mods
      2817254924 # Gensokyo
      2824688072 # Calamity Mod
      2563862309 # The Stars Above
      2838015851 # Catalyst Mod
      ## Small mods
      2973922820 # Touhou Little Friends ~ Adventure with cute partners
      2824688804 # Calamity's Vanities
      2995193002 # Calamity: Wrath of the Gods
      2669644269 # Boss Checklist
      2565639705 # Ore Excavator (1.4.3/1.4.4 Veinminer)
      2815010161 # Shared World Map
      2877850919 # Smarter Cursor
      2563082541 # Angler Shop
      2687866031 # Census - Town NPC Checklist
      2599842771 # AlchemistNPC Lite
      3024992349 # Better zenith in Calamity
      2974503494 # More Pylons
      2860270524 # Calamity Ranger Expansion
      3246145263 # Calamity Texture Pack Glowmask Fix
      2827162563 # Improved Item Info
      3124369320 # More Trophies and Relics [Modded Support]
      3346854898 # Auto Reforge Golden Fix
      2979448082 # Summoner UI (Latest Stable Release)
      2896816354 # Unusacies' Battle Rods
      2812377597 # No Pylon Restrictions
      3415536524 # Calamity Mage Addon (Accessory Update)
      3412290677 # Industrial Excavation
      3328770071 # Unusacies Mixed Accessories
      2992213994 # Instant Platform Fallthrough
      2710494433 # Too Many Accessories
      2907520140 # The Kill Bind Mod
      2990764001 # Shimmer Extra
      3058372966 # Aether's Blessing: Shimmer QoL
      2767965680 # Tome of Research Sharing
      2674701188 # Cellphone is Wormhole
      2816880803 # Cellphone & Pylons
      3116957194 # Optimizerraria
      2979146327 # Chance Class Mod
      2934087687 # Auto-Trash Researched Items
      2896592287 # ResearchFromShop
      3412277684 # 杂鱼~ 杂鱼~
      3420147549 # Shared Health
      ## Music Mods
      2824688266 # Calamity Mod Music
      2816188633 # Vanilla Calamity Mod Music

      # Library Mods
      2785100219 # Subworld Library
      3222493606 # Luminance

      # Compat Mods
      ## Weapon Scaling to make things work w/ calamity endgame
      2571636086 # W1K's Weapon Scaling
      3133081405 # W1KScaling Gensokyo Patch
      3199703539 # W1k's Scaling Calamity Patch
    ];
    mods.config = {
      NoFishingQuests_Config = {
        useCustomCurrency = true;
        goldMultiplier = "2.0";
      };
      StarsAbove_StarsAboveServersideConfig.DisableCompatibilityMode = false;
      SharedMap_Config = {
        sharecooldown = 0;
        requestcooldown = 0;
      };
      NoPylonRestrictions_Config = {
        rangelimit = false;
        npclimit = false;
        preplantera = false;
        typelimit = false;
        biomelimit = false;
        vendorStatus = 0;
        pylonvendor = {
          Name = "GoblinTinkerer";
          DisplayName = "Goblin Tinkerer";
        };
        custompylons = [
          { Mod = "CalamityMod"; Name = "AstralPylon"; DisplayName = "Astral Pylon"; }
          { Mod = "CalamityMod"; Name = "CragsPylon"; DisplayName = "Crags Pylon"; }
          { Mod = "CalamityMod"; Name = "SulphurPylon"; DisplayName = "Sulphur Pylon"; }
          { Mod = "CalamityMod"; Name = "SunkenPylon"; DisplayName = "Sunken Pylon"; }
          { Mod = "EventTrophies"; Name = "RelicPylonItem"; DisplayName = "Relic Pylon"; }
          { Mod = "EvilPylon"; Name = "BonePylon"; DisplayName = "Bone Pylon"; }
          { Mod = "EvilPylon"; Name = "CorruptionPylon"; DisplayName = "Corruption Pylon"; }
          { Mod = "EvilPylon"; Name = "CrimsonPylon"; DisplayName = "Crimson Pylon"; }
          { Mod = "EvilPylon"; Name = "HellPylon"; DisplayName = "Hell Pylon"; }
          { Mod = "EvilPylon"; Name = "CloudPylon"; DisplayName = "Cloud Pylon"; }
        ];
      };
    };
  };
  environment.persistence."/nix/host/state/Servers/tModLoader".directories = [ "/var/lib/tModLoader" ];
}
