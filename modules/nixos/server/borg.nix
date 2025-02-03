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
  # Chrooted dir for security
  systemd.tmpfiles."10-ssh-chroot" = {
    "/var/lib/ssh-chroot/borg/var/lib/borgbackup".d = {
      user = "borg";
      group = "users";
      mode = "0755";
    };
    "/var/lib/ssh-chroot/borg/nix/store".d = {
      user = "root";
      group = "root";
      mode = "0755";
    };
  };
  # Bind mount nix store for shells and stuff
  filesystems."/var/lib/ssh-chroot/borg/nix/store" = {
    device = "/nix/store";
    options = [ "bind" "ro" ];
  };
  # Needed dirs
  filesystems."/var/lib/ssh-chroot/borg/var/lib/borgbackup" = {
    device = "/var/lib/borgbackup";
    options = [ "bind" "rw" ];
  };
  services.openssh.extraConfig = ''
    Match User borg
      ChrootDirectory /var/lib/ssh-chroot/borg
  '';
}
