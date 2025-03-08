{ pkgs, lib, ... }:

let
  fetchGHRelease = { owner, repo, version, fileName, hash }: pkgs.fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/${version}/${fileName}";
    inherit hash;
  };
  fetchGTNHMod = { repo, name, version, hash }: fetchGHRelease {
    owner = "GTNewHorizons";
    fileName = "${name}-${version}.jar";
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
          version = "rv3-beta-549-GTNH";
          repo = "Applied-Energistics-2-Unofficial";
          hash = lib.fakeHash;
        })
        (GTNHGenericMod rec {
          name = "ae2stuff";
          version = "0.9.4-GTNH";
          repo = name;
          hash = lib.fakeHash;
        })
        (GTNHGenericMod rec {
          name = "NotEnoughEnergistics";
          version = "1.7.0";
          repo = name;
          hash = lib.fakeHash;
        })
      ];
    });
    modrinth.mods = {
      projects = [
        "ntmspace"
        "notenoughids-unofficial"
      ];
      allowedVersionType = "beta";
    };
    curseforge = {
      mods = [
        "70496"
        "746279"
        "250398"
        "230976"
        "688894"
        "384391"
        "60089"
        "358228"
        "1099276"
        "238603"
        "227639"
        "244258"
        "826970"
        "73488"
        "235140"
      ];
      apiKey = import ./overrides/cfApiKey.nix;
    };
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