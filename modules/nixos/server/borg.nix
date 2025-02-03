{ pkgs, ... }:

{
  users.users.borg = {
    isNormalUser = true;
    home = "/var/lib/borgbackup";
    autoSubUidGidRange = false;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKlmhvzQ1zV76AiZUt13OoFV5vyL6xlFkSfUh1IbNBue sblatt@SS-Mac-sblatt.local"
    ];
    packages = with pkgs; [
      borgbackup
    ];
  };
  services.openssh.settings.AllowUsers = [ "borg" ];
  environment.persistence."/nix/host/state/Servers/BorgBackup".directories = [
    { directory = "/var/lib/borgbackup"; user = "borg"; mode = "0700"; }
  ];
}
