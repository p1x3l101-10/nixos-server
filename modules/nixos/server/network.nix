{ lib, ... }:

{
  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks = {
      "10-wired" = {
        name = "enp2s0";
        DHCP = "yes";
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
  services.resolved = {
    enable = true;
    llmnr = true;
    dnsovertls = true;
  };
  # Disable alterantives
  networking = {
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;
    useNetworkd = true;
  };
}