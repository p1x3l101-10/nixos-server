# NOTE: THIS IS UNFINISHED
# TODO: expand the list of options exposed without relying on cfg.settings.extraEnv
{ config, options, pkgs, lib, ... }:
let
  cfg = config.services.minecraft;
  inherit (lib) mkIf mkOption mkEnableOption types;
  inherit (import ./resources/minecraft.nix) versionList;
  curseforgeMod = _: with lib; {
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
    from = "curseforge"; # DO NOT CHANGE THIS
  };
  modrinthMod = _: with lib; {
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
    from = "modrinth"; # DO NOT CHANGE THIS
  };
  port = _: {
    to = mkOption {
      type = types.port;
    };
    from = mkOption {
      type = with types; nullOr port;
      default = null;
    };
  };
  # Set `from` to either "modrinth" or "curseforge"
  translateModName =  { from
                      , dataPack ? false
                      , modId
                      , slug ? null
                      , versionId
                      , partialFilename ? null
                      }@mod: let inherit (lib) optional singleton; in (
                        if (from == "modrinth")
                        then
                          lib.concatStringsSep ":"
                          (optional dataPack "datapack")
                          ++ singleton modId
                          ++ (optional (versionId != null) versionId)
                        else # curseforge
                          (if (slug != null) then slug else modId)
                          + (
                              if (versionId != null) then ":${versionId}"
                              else if (partialFilename != null) then "@${partialFilename}"
                              else ""
                            )
                      );

  mkEnvRaw = name: value: (mkIf (value != null) lib.nameValuePair name value);
  mkEnvList = name: value: seperator: (mkIf (value != []) lib.nameValuePair name (lib.concatStringsSep seperator value));
  mkEnv = name: value: (mkIf (value != null) lib.nameValuePair name (lib.toUpper value));
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
          type = types.str;
          default = "";
        };
        fileId = mkOption {
          type = with types; nullOr int;
          default = null;
        };
      };
    };
    modrinth = {
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
          8
          17
          21
        ];
        default = 21;
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
          # Other (unsupported, hack away at extraEnvironment)
          "crucible"
          "limbo"
          "spongevanilla"
          "custom"
        ];
        default = "vanilla";
        description = "Server type to use";
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
      extrPorts = mkOption {
        type = with types; listOf (coercedTo str (to: { inherit to; }) (submodule port));
        default = [];
        description = "Extra ports to map";
      };
    };
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.minecraft = {
      environment = lib.mkMerge [
        cfg.settings.extraEnv
        (mkEnv "EULA" (builtins.toString cfg.settings.eula))
        # Modrinth mod list
        (mkEnvList "MODRINTH_PROJECTS" (lib.forEach translateModName cfg.modrinth.mods.projects) "\n")
        # Type and version
        (mkEnv "VERSION" cfg.settings.version)
        (mkEnv "TYPE" cfg.settings.type)
        # API Keys
        (mkEnvRaw "CF_API_KEY" cfg.curseforge.apiKey)
        # Curseforge modpack
        (mkEnv "CF_SLUG" cfg.curseforge.pack)
        (mkEnv "CF_FILE_ID" cfg.curseforge.fileId)
        # Settings
        (mkEnv "MEMORY" ((builtins.toString cfg.settings.memory) + "G"))
      ];
      ports = [
        "${builtins.toString cfg.settings.port}:25565"
      ] ++ (lib.optionals (cfg.settgs.extraPorts != []) (lib.forEach cfg.settings.extraPorts
        (x:
          (toString (if (x.from != null) then x.from else x.to)) + ":" + (toString x.to)
        )
      ));
      volumes = [
        "/var/lib/minecraft/data:/data:rw"
      ];
      # Sets the javaVersion of the image from the respecive values from the attrSet at the begining
      image = "internal/docker-minecraft:${toString cfg.settings.javaVersion}";
      imageFile = pkgs.internal.dockerMinecraft.override {
        inherit (versionList.${toString cfg.settings.javaVersion}) imageDigest sha256;
        finalImageTag = (toString cfg.settings.javaVersion); 
      };
      autoStart = true;
    };
    systemd.tmpfiles.settings."10-minecraft" = {
      "/var/lib/minecraft".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
      "/var/lib/minecraft/data".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
    };
    networking.firewall.allowedTCPPorts = (
      lib.optional cfg.settings.openFirewall cfg.settings.port
      ++
      lib.optionals (cfg.settings.extraPorts != []) (lib.forEach cfg.settings.extraPorts (x: x.to))
    );
    assertions = [
      {
        assertion = !cfg.settings.eula;
        message = ''
          You need to agree to the Minecraft EULA in order to run the Minecraft Server
          You can read the EULA at https://www.minecraft.net/en-us/eula
          Once you have agreed to the EULA, set `services.minecraft.settings.eula = true` to agree
        ''; 
      }
    ];
    # Encurage people to not use extraEnv
    warnings = lib.optional (cfg.settings.extraEnv != []) ''
      services.minecraft.settings.extraEnv is unsupported
      be sure to check if there is a better way to set values
    '';
  };
}
