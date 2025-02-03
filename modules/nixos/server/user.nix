{ ... }:
{
  users.users.pixel = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7hEnkX2r9nnIoVUa+isMwtdEppqWMTU9VDVE47ftLb MacBook"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9YD5mX4qfWS35Kcrk2hymaXlcSEUs3lWYa9bLKOcNW Pixels-PC"
    ];
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$y$j9T$NSMuZ83C3iGB1HqRhcZOy.$6CGZk2KH94gE/gjBro9vioOkOFJw.a4rhQKJI4HzBB9";
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7hEnkX2r9nnIoVUa+isMwtdEppqWMTU9VDVE47ftLb MacBook"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9YD5mX4qfWS35Kcrk2hymaXlcSEUs3lWYa9bLKOcNW Pixels-PC"
  ];
  users.mutableUsers = false;
  services.openssh.settings.AllowUsers = [ "pixel" "root" ];
  environment.etc.nixos.source = "/home/pixel/nix-server";
}
