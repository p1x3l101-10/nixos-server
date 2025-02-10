{ lib, ... }:

# This is the only file that configures the actual host, the rest is for the container

let
  # Habit
  cfg.enable = true;
in lib.nixos-home.attrsets.mergeAttrs [
  {
    containers.s3 = lib.modules.mkIf cfg.enable {
      autoStart = true;
      privateNetwork = true;
      localAddress = "10.10.10.3/24";
      hostBridge = "br0";
      ephemeral = true;
      bindMounts = {
        "/nix/host/keys/minio".isReadOnly = false;
        "/nix/host/state/Servers/Minio" = {
          isReadOnly = false;
          mountPoint = "/var/lib/minio";
        };
      };
      config = { ... }: { imports = [ ./container.nix ]; };
    };
  }
  lib.internal.sss.makeTmpFiles [
  "nextcloud"
  ]
]