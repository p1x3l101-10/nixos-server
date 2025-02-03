{ ... }:

{
  services.tmodloader = {
    enable = true;
    persist = true;
    openFirewall = true;
    difficulty = "expert";
    world = {
      name = "Bacchus";
      seed = "1220350133";
    };
    port = 24454;
    mods.enabled = [
      # Content Mods
      ## Big mods
      2817254924 # Gensokyo
      2824688072 # Calamity Mod
      2563862309 # The Stars Above
      2909886416 # Thorium
      3015412343 # Calamity Mod Infernum Mode
      2838015851 # Catalyst Mod
      ## Small mods
      2973922820 # Touhou Little Friends ~ Adventure with cute partners
      2563309347 # Magic Storage
      2824688804 # Calamity's Vanities
      2995193002 # Calamity: Wrath of the Gods
      3071240652 # Automation & Defense
      3030483105 # Enchanted Moons
      2669644269 # Boss Checklist
      2565639705 # Ore Excavator (1.4.3/1.4.4 Veinminer)
      2815010161 # Shared World Map
      2877850919 # Smarter Cursor
      2563082541 # Angler Shop
      2619954303 # Recipe Browser
      2687866031 # Census - Town NPC Checklist
      2599842771 # AlchemistNPC Lite
      3227702022 # Bound NPC Immunity
      3024992349 # Better zenith in Calamity
      2706139083 # Craftable Accessories
      2825810436 # Craftable
      2891420130 # Craftable Calamity Items
      2974503494 # More Pylons
      2860270524 # Calamity Ranger Expansion
      3246145263 # Calamity Texture Pack Glowmask Fix
      2827162563 # Improved Item Info
      2821625825 # Golden Trough
      3124369320 # More Trophies and Relics [Modded Support]
      3165492818 # Auto Fisher
      3008058007 # Nurse Overhaul
      3346854898 # Auto Reforge Golden Fix
      3402595565 # Multiworld Pylon
      3346335121 # Cursor Bug Net
      3407770135 # Guaranteed Traveling Merchant
      2979448082 # Summoner UI (Latest Stable Release)
      2896816354 # Unusacies' Battle Rods
      2563277843 # The Clicker Class
      2812377597 # No Pylon Restrictions
      3415536524 # Calamity Mage Addon (Accessory Update)
      3412290677 # Industrial Excavation
      3328770071 # Unusacies Mixed Accessories
      2992213994 # Instant Platform Fallthrough
      ## Music Mods
      2824688266 # Calamity Mod Music
      2816188633 # Vanilla Calamity Mod Music
      3015416182 # Infernum Mode Music

      # Library Mods
      2785100219 # Subworld Library
      2908170107 # absoluteAquarian Utilities (SerousCommonLib)
      3222493606 # Luminance
      3395336633 # Clicker Extra API

      # Compat Mods
      3106201538 # Thorium + Calamity Convergence Mod REDUX
      2816999612 # Recipe Browser && Magic Storage
      3184307602 # Calamity Clickers
      2906406399 # Infernum Master and Legendary Modes Patch
      ## Multiplayer Patches
      3112745338 # Infernum Multiplayer Patch
      ## Weapon Scaling to make things work w/ calamity endgame
      2571636086 # W1K's Weapon Scaling
      2940199906 # Weapon Scaling Thorium Patch
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
          { Mod = "MultiworldPylon"; Name = "MultiworldPylonItem"; DisplayName = "Multiworld Pylon"; }
        ];
      };
    };
  };
}
