{ lib, ... }:

{
  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks = {
      "10-wired" = {
        name = "eth0";
        DHCP = "yes";
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    llmnr = "true";
    dnsovertls = "true";
  };
  networking = {
    defaultGateway = {
      address = "10.10.10.255";
      inteface = "eth0";
    };
    firewall = {
      allowedTCPPorts = [ 80 ];
      extraCommands = ''
        iptables -F INPUT # TODO: might not be necessary
        iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
        iptables -A INPUT -s "10.10.10.255" -p tcp --dport 80 -j ACCEPT
        iptables -A INPUT -j DROP
      '';
    };
    # Disable alterantives
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;
    useNetworkd = true;
    useHostResolvConf = lib.mkForce false;
  };
}