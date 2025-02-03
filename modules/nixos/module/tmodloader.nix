{ config, options, pkgs, lib, ... }:
let
  cfg = config.services.tmodloader;
  mkOption = lib.mkOption;
  mkEnableOption = lib.mkEnableOption;
  types = lib.types;
  mkJourneyOption = mkOption {
    type = types.enum [
      "locked"
      "hostOnly"
      "all"
    ];
    default = cfg.journey.defaultPerm;
    example = "all";
    description = "Journey mode control";
  };
  fromJourney = (o:
    toString (lib.attrByPath [ o ] 0 {
      locked = 0;
      hostOnly = 1;
      all = 2;
    })
  );
in
{
  options.services.tmodloader = {
    enable = mkEnableOption "tModLoader server";
    persist = mkEnableOption "Impermanance support";
    difficulty = mkOption {
      type = with types; enum [
        "journey"
        "classic"
        "expert"
        "master"
      ];
      default = "classic";
      example = "journey";
    };
    port = mkOption {
      type = types.port;
      default = 7777;
    };
    password = mkOption {
      type = types.str;
      default = "N/A";
      example = "strongPassword";
    };
    world = {
      name = mkOption {
        type = types.str;
        default = "The Sacred Valley";
      };
      seed = mkOption {
        type = with types; oneOf [ str int ];
        default = "nix";
        example = "forTheWorthy";
        description = "World seed, accepts a number or string";
      };
      size = mkOption {
        type = types.enum [
          "small"
          "medium"
          "large"
        ];
        default = "large";
        description = "World Size";
      };
    };
    mods = {
      enabled = mkOption {
        type = with types; listOf int;
        default = [ ];
        description = "List of Steam Workshop ids to enable";
      };
      download = mkOption {
        type = with types; listOf int;
        default = cfg.mods.enabled;
        description = ''
          List of Steam Workstop ids to download
          NOTE: This is only needed to cache a download
        '';
      };
      config = mkOption {
        type = with types; attrsOf attrs;
        default = { };
        example = {
          NoFishingQuests_Config = {
            useCustomCurrency = true;
            goldMultiplier = "2.0";
          };
        };
        description = ''
          The mod configuration
          These are turned into JSON files under `<data>/ModConfigs/<name>.json`
        '';
      };
    };
    journey = {
      defaultPerm = mkOption {
        type = types.enum [
          "locked"
          "hostOnly"
          "all"
        ];
        default = "locked";
        example = "all";
        description = "Default setting for all journey settings";
      };
      setFrozen = mkJourneyOption;
      setDawn = mkJourneyOption;
      setNoon = mkJourneyOption;
      setDusk = mkJourneyOption;
      setMidnight = mkJourneyOption;
      godmode = mkJourneyOption;
      windStrength = mkJourneyOption;
      rainStrength = mkJourneyOption;
      timeSpeed = mkJourneyOption;
      rainFrozen = mkJourneyOption;
      windFrozen = mkJourneyOption;
      placementRange = mkJourneyOption;
      setDifficulty = mkJourneyOption;
      biomeSpread = mkJourneyOption;
      spawnRate = mkJourneyOption;
    };
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to automatically open the specified ports in the firewall.";
    };
    image = mkOption {
      type = types.package;
      default = pkgs.internal.dockerTmodloader;
      example = pkgs.internal.dockerTmodloader.override { imageDigest = "sha256:digest-here"; sha256 = "valid-hash"; };
      description = "tModLoader server image";
    };
    extraConfig = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = ''
        Extra values to add to config
        This is put first, and is overridden by other config values
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.tmodloader = {
      environment = lib.recursiveUpdate cfg.extraConfig {
        TMOD_PASS = cfg.password;
        TMOD_WORLDNAME = cfg.world.name;
        TMOD_WORLDSEED = cfg.world.seed;
        TMOD_DIFFICULTY = toString (lib.attrByPath [ cfg.difficulty ] 0 {
          journey = -1;
          classic = 0;
          expert = 1;
          master = 2;
        });
        TMOD_WORLDSIZE = toString (lib.attrByPath [ cfg.difficulty ] 0 {
          small = 0;
          medium = 1;
          large = 2;
        });
        TMOD_AUTODOWNLOAD = lib.concatStringsSep "," (lib.forEach cfg.mods.download (x: toString x));
        TMOD_ENABLEDMODS = lib.concatStringsSep "," (lib.forEach cfg.mods.enabled (x: toString x));
        TMOD_JOURNEY_SETFROZEN = fromJourney cfg.journey.setFrozen;
        TMOD_JOURNEY_SETDAWN = fromJourney cfg.journey.setDawn;
        TMOD_JOURNEY_SETNOON = fromJourney cfg.journey.setNoon;
        TMOD_JOURNEY_SETDUSK = fromJourney cfg.journey.setDusk;
        TMOD_JOURNEY_SETMIDNIGHT = fromJourney cfg.journey.setMidnight;
        TMOD_JOURNEY_GODMODE = fromJourney cfg.journey.godmode;
        TMOD_JOURNEY_WIND_STRENGTH = fromJourney cfg.journey.windStrength;
        TMOD_JOURNEY_RAIN_STRENGTH = fromJourney cfg.journey.rainStrength;
        TMOD_JOURNEY_TIME_SPEED = fromJourney cfg.journey.timeSpeed;
        TMOD_JOURNEY_RAIN_FROZEN = fromJourney cfg.journey.rainFrozen;
        TMOD_JOURNEY_WIND_FROZEN = fromJourney cfg.journey.windFrozen;
        TMOD_JOURNEY_PLACEMENT_RANGE = fromJourney cfg.journey.placementRange;
        TMOD_JOURNEY_SET_DIFFICULTY = fromJourney cfg.journey.setDifficulty;
        TMOD_JOURNEY_BIOME_SPREAD = fromJourney cfg.journey.biomeSpread;
        TMOD_JOURNEY_SPAWN_RATE = fromJourney cfg.journey.spawnRate;
      };
      image = "internal/docker-tmodloader:latest";
      imageFile = cfg.image;
      ports = [
        "${toString cfg.port}:7777"
      ];
      volumes = [
        "/var/cache/tModLoader/workshop:/data/steamMods"
        "/var/cache/tModLoader/dotnet:/terraria-server/dotnet"
        "/var/lib/tModLoader:/data/tModLoader/Worlds"
        "/etc/tModLoader/ModConfigs:/data/tModLoader/ModConfigs"
      ];
      autoStart = true;
    };
    systemd.tmpfiles.settings."10-tmodloader" = {
      "/var/lib/tModLoader".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/var/cache/tModLoader/workshop".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/var/cache/tModLoader/dotnet".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/etc/tModLoader/ModConfigs".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
    };
    virtualisation.containers.enable = true;
    environment.persistence."/nix/host/state/Servers/tModLoader" = lib.mkIf cfg.persist {
      directories = [
        "/var/lib/tModLoader"
      ];
    };
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ cfg.port ];
    environment.etc = lib.mapAttrs' (name: value: lib.nameValuePair ("tModLoader/ModConfigs/" + name + ".json") { text = (builtins.toJSON value); mode = "0444"; }) cfg.mods.config;
  };
}
