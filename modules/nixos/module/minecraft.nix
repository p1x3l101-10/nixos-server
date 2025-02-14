# NOTE: THIS IS UNFINISHED
# TODO: expand the list of options exposed without relying on cfg.settings.extraEnv
{ config, options, pkgs, lib, ... }:
let
  cfg = config.services.minecraft;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib) types;
  curseforgeMod = _: with lib; {
    options = {
      modId = mkOption {
        type = with types; nullOr int;
        default = null;
        description = "modId or slug must be set";
      };
      slug = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "modId or slug must be set";
      };
      versionId = mkOption {
        type = with types; nullOr int;
        default = null;
      };
      partialFilename = mkOption {
        type = with types; nullOr str;
        default = null;
      };
    };
  };
  modrinthMod = _: with lib; {
    options = {
      modId = mkOption {
        type = types.str;
      };
      versionId = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      dataPack = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  portPair = _: with lib; {
    options = {
      to = mkOption {
        type = types.port;
      };
      from = mkOption {
        type = with types; nullOr port;
        default = null;
      };
    };
  };
in
{
  options.services.minecraft = with lib; {
    enable = mkEnableOption "Minecraft Server";
    curseforge = {
      apiKey = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      pack = {
        slug = mkOption {
          type = with types; nullOr str;
          default = null;
        };
        fileId = mkOption {
          type = with types; nullOr int;
          default = null;
        };
      };
    };
    modrinth = {
      pack = {
        project = mkOption {
          type = with types; nullOr str;
          default = null;
        };
        loader = mkOption {
          type = with types; nullOr (enum [
            "forge"
            "fabric"
            "quilt"
          ]);
          default = null;
        };
        version = mkOption {
          type = with types; nullOr str;
          default = null;
        };
      };
      mods = {
        projects = mkOption {
          type = with types; listOf (coercedTo str (modId: { inherit modId; }) (submodule modrinthMod));
          default = [];
          description = "List of mods from modrinth to install";
          example = ''
            [
              "coroutil"
              { modId = "toms-storage"; versionId = "UjCLHkAa"; }
              { datapack = true; modId = "terralith"; versionId = "2.5.5"; }
            ]
          '';
        };
        downloadDependancies = mkOption {
          type = types.enum [
            "none"
            "required"
            "optional"
          ];
          default = "none";
        };
        allowedVersionType = mkOption {
          type = types.enum [
            "release"
            "beta"
            "alpha"
          ];
          default = "release";
        };
      };
    };
    settings = {
      eula = mkEnableOption "Agree to EULA";
      openFirewall = mkEnableOption "Open firewall ports";
      memory = mkOption {
        type = types.int;
        default = 8;
        description = "The amount of memory (in gigabytes) to allocate";
      };
      javaVersion = mkOption {
        type = types.enum [
          "8"
          "17-alpine"
          "17-graalvm"
          "21-alpine"
        ];
        default = "21-alpine";
        description = "Java version to select";
      };
      type = mkOption {
        type = types.enum [
          "vanilla"
          # Vanilla+
          "paper"
          # Modloaders
          "fabric"
          "forge"
          "quilt"
          # Modpacks
          "auto_curseforge"
          "ftba"
          "modrinth"
          # Other (unsupported, hack away at extraEnv)
          "crucible"
          "limbo"
          "spongevanilla"
          "custom"
        ];
        default = "vanilla";
        description = "Server type to use";
      };
      version = mkOption {
        type = types.str;
        default = "latest";
      };
      port = mkOption {
        type = types.port;
        default = 25565;
      };
      extraEnv = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = "Extra environment variables to merge into server";
      };
      extraPorts = mkOption {
        type = with types; listOf (coercedTo port (to: { inherit to; }) (submodule portPair));
        default = [];
        description = "Extra ports to map";
      };
      rconStartup = mkOption {
        type = with types; listOf str;
        default = [];
        description = "RCon commands to run on server startup";
      };
      extraFiles = mkOption {
        type = with types; nullOr path;
        default = null;
        description = "extra files to be added to the server as a generic pack";
      };
      forgeVersion = mkOption {
        type = with types; nullOr str;
        default = null;
      };
    };
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.minecraft = {
      environment = (lib.nixos-home.attrsets.mergeAttrs (let inherit (lib.nixos-home.environment) mkEnv mkEnvRawList mkEnvRaw; in [
        cfg.settings.extraEnv
        (mkEnv "EULA" (lib.trivial.boolToString cfg.settings.eula))
        # Modrinth mod list
        (mkEnvRawList "MODRINTH_PROJECTS" (lib.forEach cfg.modrinth.mods.projects (x: lib.internal.minecraft.translateModName x "modrinth")) "\n")
        # Type and version
        (mkEnv "VERSION" cfg.settings.version)
        (mkEnv "TYPE" cfg.settings.type)
        # API Keys
        (mkEnvRaw "CF_API_KEY" cfg.curseforge.apiKey)
        # Curseforge modpack
        (mkEnv "CF_SLUG" cfg.curseforge.pack.slug)
        (mkEnv "CF_FILE_ID" cfg.curseforge.pack.fileId)
        # Settings
        (mkEnv "MEMORY" ((builtins.toString cfg.settings.memory) + "G"))
        (mkEnvRaw "RCON_CMDS_STARTUP" (lib.strings.concatStringsSep "\n" cfg.settings.rconStartup))
        (mkEnvRaw "GENERIC_PACK" ( if cfg.settings.extraFiles == null then null else (toString (pkgs.callPackage ./resources/genericPack.nix { src = cfg.settings.extraFiles; }))))
        (mkEnvRaw "forge_version" cfg.settings.forgeVersion)
        (mkEnvRaw "MODRINTH_MODPACK" cfg.modrinth.pack.project)
        (mkEnvRaw "MODRINTH_LOADER" cfg.modrinth.pack.loader)
        (mkEnvRaw "MODRINTH_VERSION" cfg.modrinth.pack.version)
      ]));
      ports = [
        "${builtins.toString cfg.settings.port}:25565"
      ] ++ (lib.optionals (cfg.settings.extraPorts != []) (lib.forEach cfg.settings.extraPorts
        (x:
          (toString (if (x.from != null) then x.from else x.to)) + ":" + (toString x.to)
        )
      ));
      volumes = [
        "/var/lib/minecraft/saves:/data/saves:rw"
        "/var/lib/minecraft/mods:/mods:ro"
        "/var/lib/minecraft/config:/config:ro"
        "/var/lib/minecraft/global:/global:ro"
        "/nix/store:/nix/store:ro"
      ];
      # Sets the javaVersion of the image from the respecive values from the attrSet at the begining
      image = "internal/docker-minecraft:${toString cfg.settings.javaVersion}";
      imageFile = pkgs.internal.dockerMinecraft.override {
        inherit ((import (./resources/minecraft.nix)).versionList.${cfg.settings.javaVersion}) imageDigest sha256;
        finalImageTag = (toString cfg.settings.javaVersion); 
      };
      autoStart = true;
    };
    systemd.tmpfiles.settings."50-minecraft" = {
      "/var/lib/minecraft".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/var/lib/minecraft/saves".d = {
        user = "1000";
        group = "1000";
        mode = "0755";
      };
      "/var/lib/minecraft/config".d = {
        user = "1000";
        group = "1000";
        mode = "0755";
      };
      "/var/lib/minecraft/mods".d = {
        user = "1000";
        group = "1000";
        mode = "0755";
      };
      "/var/lib/minecraft/plugins".d = {
        user = "1000";
        group = "1000";
        mode = "0755";
      };
      "/var/lib/minecraft/global".d = {
        user = "1000";
        group = "1000";
        mode = "1777";
      };
      "/var/lib/minecraft/backups".d = {
        user = "1000";
        group = "1000";
        mode = "0755";
      };
    };
    networking.firewall.allowedTCPPorts = (
      lib.lists.optional cfg.settings.openFirewall cfg.settings.port
      ++
      lib.lists.optionals (cfg.settings.extraPorts != []) (lib.lists.forEach cfg.settings.extraPorts (x: x.to))
    );
    assertions = [
      {
        assertion = cfg.settings.eula;
        message = ''
          You need to agree to the Minecraft EULA in order to run the Minecraft Server
          You can read the EULA at https://www.minecraft.net/en-us/eula
          Once you have agreed to the EULA, set `services.minecraft.settings.eula = true` to agree
        ''; 
      }
    ];
    # Encurage people to not use extraEnv
    warnings = (lib.lists.optional (cfg.settings.extraEnv != {}) ''
      services.minecraft.settings.extraEnv is unsupported
      be sure to check if there is a better way to set values
    '')
    ++
    (lib.lists.optional (lib.lists.any (x: x.from == 25575) cfg.settings.extraPorts)''
      DO NOT port forward RCON on 25575 without first setting RCON_PASSWORD to a secure value.
      It is highly recommended to only use RCON within the container, such as with rcon-cli
    '');
  };
}
