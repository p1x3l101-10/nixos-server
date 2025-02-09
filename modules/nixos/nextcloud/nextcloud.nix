{ pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "blatt.zip";
    datadir = "/var/lib/nextcloud";
    config = {
      adminpassFile = "/nix/host/keys/nextcloud/admin-password.txt";
      dbtype = "sqlite";
    };
    extraAppsEnable = true;
  };
}