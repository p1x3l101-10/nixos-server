# NOTE: THIS IS UNFINISHED
# Plans: use itzg docker minecraft server
# That is what i know afterall...
{ config, options, pkgs, lib, ... }:
let
  cfg = config.services.minecraft;
in {
  options.services.minecraft = with lib; {
    enable = mkEnableOption "Minecraft Server";
    javaVersion = mkOption {
      type = types.enum [
        8
        17
        21
        "latest"
      ];
      default = "latest";
      example = 8;
      description = "Java version to select";
    };
  };
}