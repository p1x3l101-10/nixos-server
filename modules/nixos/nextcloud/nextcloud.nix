{ pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "166.113.94.161";
    datadir = "/var/lib/nextcloud";
    config = {
      adminpassFile = "/nix/host/keys/nextcloud/admin-password.txt";
      dbtype = "sqlite";
    };
    extraAppsEnable = true;
  };
}