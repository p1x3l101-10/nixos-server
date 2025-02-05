{ ... }:

{
  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "ens3";
    enableIPv6 = true;
  };
  environment.persistence."/nix/host/cache".directories = [ 
    { directory = "/var/lib/machines"; mode = "0700"; }
  ];
}