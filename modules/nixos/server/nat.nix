{ ... }:

{
  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "ens3";
    enableIPv6 = true;
  };
}