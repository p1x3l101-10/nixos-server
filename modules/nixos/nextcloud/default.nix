{ lib, ... }:

# This is the only file that configures the actual host, the rest is for the container

let
  # Habit
  cfg.enable = true;
in {
  containers.nextcloud = lib.modules.mkIf cfg.enable {
    autoStart = true;
    privateNetwork = true;
    localAddress = "192.168.100.4/24";
    hostBridge = "br0";
    ephemeral = true;
    forwardPorts = [
      {
        containerPort = 80;
        hostPort = 4443;
        protocol = "tcp";
      }
    ];
    bindMounts = {
      "/nix/host/state/Servers/Nextcloud" = {
        mountPoint = "/var/lib/nextcloud";
        isReadOnly = false;
      };
      "/nix/host/keys/minio/keys/nextcloud".mountPoint = "/run/keys/s3";
      "/nix/host/keys/nextcloud".mountPoint = "/run/keys/nextcloud";
    };
    config = { ... }: { imports = [ ./container.nix ]; };
  };
  networking.firewall.allowedTCPPorts = [ 4443 ]; # Maps to 7001 externally
}