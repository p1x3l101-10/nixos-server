{ ... }:

{
  boot.enableContainers = true;
  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "ens3";
      enableIPv6 = true;
    };
    bridges.br0.interfaces = [ "enp2s0" ];
    interfaces.br0 = {
      useDHCP = true;
      ipv4.addresses = [{
        address = "192.168.100.1";
        prefixLength = 24;
      }];
    };
  };
  environment.persistence."/nix/host/cache".directories = [
    { directory = "/var/lib/machines"; mode = "0700"; }
  ];
}
