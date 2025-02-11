{ pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "166.113.94.161";
    datadir = "/var/lib/nextcloud";
    config = {
      adminuser = "internal-admin";
      adminpassFile = "/tmp/nextcloud-admin-password.txt";
      dbtype = "sqlite";
    };
    extraAppsEnable = true;
  };
  # Make adminPass readable by nextcloud:nextcloud
  systemd.services."nextcloud-setup-setup" = {
    requiredBy = [ "nextcloud-setup.service" ];
    before = [ "nextcloud-setup.service" ];
    script = ''
      cp /run/keys/nextcloud/admin-password.txt /tmp/nextcloud-admin-password.txt
      chown nextcloud:nextcloud /tmp/nextcloud-admin-password.txt
      chmod 0440 /tmp/nextcloud-admin-password.txt
    '';
  };
}