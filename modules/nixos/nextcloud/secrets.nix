{ ... }:

{
  services.nextcloud.secretFile = "/run/keys/nextcloud/secrets.json";
  systemd.tmpfiles.settings."11-preset-key"."/run/keys/nextcloud/secrets.json".f = {
    user = "nextcloud";
    group = "nextcloud";
    mode = "0440";
    argument = "{}";
  };
}