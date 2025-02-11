{ lib, ... }:

# This is the only file that configures the actual host, the rest is for the container

let
  # Habit
  cfg.enable = true;
in {
  config = lib.modules.mkIf cfg.enable (lib.nixos-home.attrsets.mergeAttrs [
    {
      containers.nextcloud = {
        autoStart = true;
        privateNetwork = true;
        localAddress = "10.10.10.4/24";
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
            hostPath = "/nix/host/state/Servers/Nextcloud";
            isReadOnly = false;
          };
          "/nix/host/keys/minio/keys/nextcloud" = {
            mountPoint = "/run/keys/s3";
            hostPath = "/nix/host/keys/minio/keys/nextcloud";
          };
          "/nix/host/keys/nextcloud" = {
            mountPoint = "/run/keys/nextcloud";
            hostPath = "/nix/host/keys/nextcloud";
            isReadOnly = false;
          };
        };
        config = { ... }: { imports = [ ./container.nix ]; };
      };
      networking.firewall.allowedTCPPorts = [ 4443 ]; # Maps to 7001 externally
    }
    {
      systemd.tmpfiles.settings = {
        "50-host-state"."/nix/host/state/Servers/Nextcloud".d = { mode = "0755"; };
        "50-host-keys"."/nix/host/keys/nextcloud".d = { mode = "0700"; };
      };
    }
  ]);
}