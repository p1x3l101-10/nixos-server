{ ... }:

{
  imports = [
    ./apps.nix
    ./caching.nix
    ./mail.nix
    ./nextcloud.nix
    ./s3.nix
    ./secrets.nix
    #./ssl.nix # No domain at the moment
  ];
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 ];
    };
    useNetworkd = true;
    networkmanager.enable = lib.mkForce false;
    useHostResolvConf = lib.mkForce false;
  };
  services.resolved.enable = true;
  system.stateVersion = "24.11";
}