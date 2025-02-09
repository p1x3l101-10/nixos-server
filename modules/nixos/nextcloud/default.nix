{ lib, ... }:

# This is the only file that configures the actual host, the rest is for the container

let
  # Habit
  cfg.enable = false;
in {
  containers.nextcloud = lib.modules.mkIf cfg.enable {
    autoStart = true;
    privateNetwork = true;
    localAddress = "192.168.100.4/24";
    hostBridge = "br0";
    ephemeral = true;
    bindMounts = {
      "/nix/host/state/Servers/Nextcloud" = {
        mountPoint = "/var/lib/nextcloud";
        isReadOnly = false;
      };
      "/nix/host/keys/minio/keys/nextcloud".mountPoint = "/run/keys/s3";
      "/nix/host/keys/nextcloud".mountPoint = "/run/keys/nextcloud";
    };
    config = args: import ./container.nix args;
  };
}