{ pkgs, lib, ... }:

let
  inherit (import ./key.nix) rootCredentialsFile;
in {
  services.minio = {
    enable = true;
    listenAddress = "127.0.0.1:9000";
    consoleAddress = "127.0.0.1:9001";
    inherit rootCredentialsFile;
  };
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 9000 ];
    };
    useNetworkd = true;
    networkmanager.enable = lib.mkForce false;
    useHostResolvConf = lib.mkForce false;
  };
  environment.systemPackages = [ pkgs.minio-client ];
  systemd.tmpfiles.settings."11-preset-key".${rootCredentialsFile}.f = {
    user = "root";
    group = "root";
    mode = "0400";
    argument = ''
      MINIO_ROOT_USER=nextcloud
      MINIO_ROOT_PASSWORD=CHANGEME
    '';
  };
  system.stateVersion = "24.11";
}