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
  lwjgl3ify-forgePatches = pkgs.stdenvNoCC.mkDerivation rec {
    name = "lwjgl3ify-forgePatches";
    version = "2.1.9";
    src = pkgs.fetchurl {
      url = "https://github.com/GTNewHorizons/lwjgl3ify/releases/download/${version}/lwjgl3ify-${version}-forgePatches.jar";
      hash = "sha256-Wn02CV98S5wrw3LhX4TB+JfOzjUDVT+kk32q2+0TTCY=";
    };
    sourceRoot = ".";
    unpackPhase = ''
      cp ${src} "./${src.name}"
    '';
    installPhase = ''
      mkdir -p $out
      mv ./${src.name} $out/lwjgl3ify-forgePatches.jar
    '';
  };
in {
  services.minecraft = {
    enable = true;
    generic.pack = builtins.toString (lib.internal.builders.genericPack {
      packList = [
        lwjgl3ify-forgePatches
        (GTNHGenericMod {
          name = "appliedenergistics2";
          version = "rv3-beta-549-GTNH";
          repo = "Applied-Energistics-2-Unofficial";
          hash = "sha256-Uh9r5+HTTRPVqTFvsKx40ucEX8YTrzIvCeimGwSZMaA=";
        })
        (GTNHGenericMod rec {
          name = "ae2stuff";
          version = "0.9.4-GTNH";
          repo = name;
          hash = "sha256-+QWYZ1fT43aM9BWUVvwojB6RXORjCt7n6I+1HBezGvY=";
        })
        (GTNHGenericMod rec {
          name = "NotEnoughEnergistics";
          version = "1.7.0";
          repo = name;
          hash = "sha256-h4nZ+U03r8jPCZEzzH83yt7FPcM9V7ERpEgqmLglMrE=";
        })
      ];
    });
    modrinth.mods = {
      projects = [
        "ntmspace"
        "notenoughids-unofficial"
        "gtnhlib"
      ];
      allowedVersionType = "beta";
    };
    curseforge = {
      mods = [
        "70496"
        "746279"
        "230976"
        "384391"
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
      type = "custom";
      java = {
        version = "21-graalvm";
        args = [
          "@${builtins.fetchurl {
            url = "https://raw.githubusercontent.com/GTNewHorizons/lwjgl3ify/refs/heads/master/java9args.txt";
            sha256 = "sha256:0mvlkwbi9v1dxir1fj9vrd2liwlakqzmajl4grwwg6ynb1qw2jai";
          }}"
        ];
      };
      customServer = "lwjgl3ify-forgePatches.jar";
      version = "1.7.10";
      memory = 8;
      rconStartup = [
        "difficulty hard"
      ];
    };
  };
}