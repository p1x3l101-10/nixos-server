{ pkgs, ... }:

{
  users.users.proxy = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxvRlsW70GEkuqN/tdVM5X8EqdE6M/iA2iOHsA+HX8e sblatt@SS-Mac-sblatt.local" # MacBook
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwbUnVjNdHpw4trfz2NEmg6Q901eO6cmELH2EilyFaV cbaxter@SS-Mac-cbaxter.local" # CJ
    ];
    shell = pkgs.shadow;
    home = "/var/empty";
    autoSubUidGidRange = false;
  };
  services.openssh.settings.AllowUsers = [ "proxy" ];
  services.openssh.extraConfig = ''
    Match User proxy
      ForceCommand nologin
  '';
}
