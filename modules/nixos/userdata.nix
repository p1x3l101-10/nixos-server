{ lib }:

lib.fix (self: {
  data = {
    dylan = {
      proxyKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDsCrCpDvwG00kYONWjsKByp7c91+soPLcHhoqjzXleq dylanv3@SS-Mac-dylanv3.local";
      mcUsername = "Dillpikle2022";
    };
    scott = {
      proxyKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxvRlsW70GEkuqN/tdVM5X8EqdE6M/iA2iOHsA+HX8e sblatt@SS-Mac-sblatt.local";
      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7hEnkX2r9nnIoVUa+isMwtdEppqWMTU9VDVE47ftLb MacBook"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9YD5mX4qfWS35Kcrk2hymaXlcSEUs3lWYa9bLKOcNW Pixels-PC"
      ];
      mcUsername = "P1x3l101";
    };
    cayden = {
      proxyKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwbUnVjNdHpw4trfz2NEmg6Q901eO6cmELH2EilyFaV cbaxter@SS-Mac-cbaxter.local";
    };
    kenton = {
      proxyKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALkAoRXoHW+8AL7HTJQvwCFraLk3Fi7YtuB0N8yLpQ9 kentonb@SS-Mac-kentonb.local";
      mcUsername = "RexyMonke";
    };
    spradley = {
      proxyKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIInfQpHlJseFgFIG8cedlMrWyjIgw08MaCbc00kn4lNx matthews7@SS-Mac-matthews7.local";
    };
  };
  getdata = key: names: (lib.lists.flatten (lib.lists.forEach names (x:
    lib.attrsets.getAttrFromPath ([ x ] ++ (lib.lists.flatten [ key ])) self.data
  )));
})