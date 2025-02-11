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
  # Make adminPass readable by nextcloud:nextcloud
  systemd.tmpfiles.settings."99-make-files-readable-to-user" = {
    "/nix/host/keys/nextcloud/admin-password.txt".z = {
      user = "nextcloud";
      group = "nextcloud";
    };
  };
}