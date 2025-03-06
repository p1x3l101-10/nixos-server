{ pkgs, lib, ... }:

{
  services.minecraft = {
    enable = true;
    generic = {
      forceUpdate = true;
      pack = builtins.toString (lib.internal.builders.genericPack {
        packList = [
          ./overrides/gtnh
          (lib.internal.builders.genericMod rec {
            name = "ocwasm";
            version = "0.5.2";
            file = pkgs.fetchurl {
              url = "https://github.com/DCNick3/OC-Wasm-GTNH/releases/download/1.7.10-0.5.2/${name}-1.7.10-${version}.jar";
              hash = "sha256-sMMdWxKBQCqtijxLos7GYjlxHtrsFfh+XzTjTcabnek=";
            };
          })
          (pkgs.fetchzip {
            url = "https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_2.7.2_Server_Java_17-21.zip";
            hash = "sha256-/1zYsc0P6X5guWHWX0Y57KL9kbzQNmQ+PJreq50wQOw=";
            stripRoot=false;
          })
        ];
      });
    };
    settings = {
      eula = true;
      type = "custom";
      java = {
        version = "21-graalvm";
        args = "-Dfml.readTimeout=180 @java9args.txt";
      };
      version = "1.7.10";
      memory = 8;
      port = 25565;
      rconStartup = [
        "bq_admin default load" # Reload for updates
        "bq_admin hardcore true"
        "difficulty hard"
      ];
      customServer = "lwjgl3ify-forgePatches.jar";
      whitelist = import ./overrides/whitelist.nix;
    };
  };
  virtualisation.oci-containers.containers.minecraft.volumes = [
    "/var/lib/minecraft/data:/data:rw" # Persist all the random data bc journeymap is stupid and cant use the world id
    "/var/lib/minecraft/backups:/backups:rw" # Serverutilities backups
    "/var/lib/minecraft/world:/data/World:rw" # Use old world location 
  ];
  # Make a data folder to mount to
  systemd.tmpfiles.settings."50-minecraft" = {
    "/var/lib/minecraft/data".d = {
      user = "1000";
      group = "1000";
      mode = "0755";
    };
    "/var/lib/minecraft/backups".d = {
      user = "1000";
      group = "1000";
      mode = "0755";
    };
  };
  # Persist server
  environment.persistence."/nix/host/state/Servers/Minecraft/GTNH".directories = [
    { directory = "/var/lib/minecraft"; user = "1000"; group = "1000"; }
  ];
}
