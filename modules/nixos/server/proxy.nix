{ pkgs, ... }:

{
  users.users.proxy = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxvRlsW70GEkuqN/tdVM5X8EqdE6M/iA2iOHsA+HX8e sblatt@SS-Mac-sblatt.local" # MacBook
      # NOTE: Make plans to phase out this key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXyvvhbuRPJyJgeaBCNiWI6IU1KP5WXrL2B1Qpvl36v sblatt@S-C1MSWH8RH3QF.normanps.norman.k12.ok.us" # Public-ish key
    ];
    shell = pkgs.shadow;
    home = "/var/empty";
    autoSubUidGidRange = false;
  };
  services.openssh.settings.AllowUsers = [ "proxy" ];
}
