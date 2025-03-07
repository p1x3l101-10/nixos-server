{ pkgs, ... }:

{
  users.users.proxy = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxvRlsW70GEkuqN/tdVM5X8EqdE6M/iA2iOHsA+HX8e sblatt@SS-Mac-sblatt.local" # MacBook
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwbUnVjNdHpw4trfz2NEmg6Q901eO6cmELH2EilyFaV cbaxter@SS-Mac-cbaxter.local" # CJ
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALkAoRXoHW+8AL7HTJQvwCFraLk3Fi7YtuB0N8yLpQ9 kentonb@SS-Mac-kentonb.local" # Kenton
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDsCrCpDvwG00kYONWjsKByp7c91+soPLcHhoqjzXleq dylanv3@SS-Mac-dylanv3.local" # Dylan
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIInfQpHlJseFgFIG8cedlMrWyjIgw08MaCbc00kn4lNx matthews7@SS-Mac-matthews7.local" # Spradley
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
