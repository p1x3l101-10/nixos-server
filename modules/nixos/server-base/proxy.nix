{ pkgs, lib, ... }:

let
  getdata = key: names: (import ../userdata.nix { inherit lib; }) key names;
in {
  users.users.proxy = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = getdata [ "proxyKey" ] [
      "scott"
      "cayden"
      "kenton"
      "dylan"
      "spradley"
    ];
    shell = pkgs.shadow;
    home = "/var/empty";
    autoSubUidGidRange = false;
  };
  services.openssh.settings.AllowUsers = [ "proxy" ];
  services.openssh.extraConfig = ''
    Match User proxy
      ForceCommand nologin
  '';
}
