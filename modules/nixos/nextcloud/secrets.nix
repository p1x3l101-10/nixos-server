{ ... }:

{
  services.nextcloud.secretFile = "/run/keys/nextcloud/secrets.json";
  systemd.tmpfiles.settings."11-preset-key"."/run/keys/nextcloud/secrets.json".f = {
    user = "root";
    group = "root";
    mode = "0400";
    argument = "{}";
  };
}