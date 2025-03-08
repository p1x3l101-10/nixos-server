{ pkgs, lib, ... }:

let
  fetchGHRelease = { owner, repo, version, fileName, hash }: pkgs.fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/${version}/${fileName}";
    inherit hash;
  };
  fetchGTNHMod = { repo, name, version, hash }: fetchGHRelease {
    owner = "GTNewHorizons";
    version = "${version}-GTNH";
    fileName = "${name}-${version}-GTNH";
    inherit repo version hash;
  };
  GTNHGenericMod = { repo, name, version, hash }: lib.internal.builders.genericMod {
    inherit name version;
    file = fetchGTNHMod { inherit repo name version hash; };
  };
in {
  services.minecraft = {
    enable = true;
    generic.pack = builtins.toString (lib.internal.builders.genericPack {
      packList = [
        (GTNHGenericMod {
          name = "appliedenergistics2";
          version = "rv3-beta-549";
          repo = "Applied-Energistics-2-Unofficial";
          hash = lib.fakeHash;
        })
        (GTNHGenericMod rec {
          name = "ae2stuff";
          version = "0.9.4";
          repo = name;
          hash = lib.fakeHash;
        })
        (GTNHGenericMod rec {
          name = "NotEnoughEnergistics";
          version = "1.7.10";
          repo = name;
          hash = lib.fakeHash;
        })
      ];
    });
    settings = {
      eula = true;
      java.version = "8";
      type = "forge";
      version = "1.7.10";
      memory = 8;
      rconStartup = [
        "difficulty hard"
      ];
    };
  };
}