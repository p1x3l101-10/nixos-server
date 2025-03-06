{ pkgs, lib, ... }:

let
  genEmc = set: (
    pkgs.writeTextDir "config/ProjectE/custom_emc.json" (
      builtins.toJSON (
        {
          entries = [
            (
              lib.attrsets.mapAttrsToList (name: value:
                {
                  item = name;
                  emc = value;
                }
              ) set
            )
          ];
        }
      )
    )
  );
in
{
  services.minecraft = {
    enable = true;
    generic.pack = builtins.toString (lib.internal.builders.genericPack {
      packList = [
        ./overrides/fafoPack
        (genEmc {
          "tfmg:lithium_ingot" = 1024;
          "create:zinc_ingot" = 256;
          "tfmg:fireclay_ball" = 16;
          "create:andesite_casing" = 76;
        })
      ];
    });
    curseforge = {
      mods = [
        { modId = 399700; }
        { modId = 1062867; }
        { modId = 226410; }
        { modId = 689273; }
      ];
      apiKey = import ./overrides/cfApiKey.nix;
    };
    modrinth.mods = {
      projects = [
        "pNabrMMw"
        "6BuhSIkm"
        "EsAfCjCV"
        "XxWD5pD3"
        "SyKS54UY"
        "lhGA9TYQ"
        "joEfVgkn"
        "9s6osm5g"
        "Wnxd13zP"
        "bQ5TJA1E"
        "WrpuIfhw"
        "LNytGWDc"
        "ResbpANg"
        "USgVjXsk"
        "vvuO3ImH"
        "fRiHVvU7"
        "qbbO7Jns"
        "sG4TqDb8"
        "uXXizFIs"
        "hYykXjDp"
        "8BmcQJ2H"
        "5ZwdcRci"
        "ZVzW5oNS"
        "u6dRKJwZ"
        "T38eAZQC"
        "2M11Juic"
        "HXlL9LeK"
        "nPQ9xkPg"
        "bobSIZE9"
        "a6F3uASn"
        "OFVYKsAk"
        "tqQpq1lt"
        "nmDcB62a"
        "qQyHxfxd"
        "LPjGiSO4"
        "5A34Stj8"
        "7W0bejp5"
        "2gvRmQXx"
        "sk4iFZGy"
        "sk9knFPE"
        "aKCwCJlY"
        "j3FONRYr"
        "xYfyUTuc"
        "L23x7zL8"
        "x19saRaY"
        "lWDHr9jE"
        "kkmrDlKT"
        "8oi3bsk5"
        "vBbPDuOs"
        "Ua7DFN59"
        "XNlO7sBv"
        "o1C1Dkj5"
        "2BwBOmBQ"
        "z9Ve58Ih"
        "HjmxVlSr"
        "Z2mXHnxP"
        "3dT9sgt4"
        "kidLKymU"
        "t5FRdP87"
        "Ht4BfYp6"
        "cs7iGVq1"
        "ZYgyPyfq"
        "pJGcKPh1"
        "kubejs"
        "mekanism"
      ];
      allowedVersionType = "beta";
      downloadDependancies = "required";
    };
    settings = {
      version = "1.20.1";
      eula = true;
      java.version = "21-graalvm";
      type = "neoforge";
      memory = 8;
      port = 25565;
      openFirewall = true;
      whitelist = import ./overrides/whitelist.nix;
      rconStartup = [
        "gamerule playersSleepingPercentage 10"
      ];
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/fafoPack".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}