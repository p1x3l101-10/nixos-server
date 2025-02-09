{ lib, ext }:

# Set `from` to either "modrinth" or "curseforge"
{ from
, dataPack ? false
, modId
, slug ? null
, versionId
, partialFilename ? null
}@mod:

let
  inherit (lib.lists) optional singleton;
in (
  if (from == "modrinth") then
    lib.concatStringsSep ":"
      (optional dataPack "datapack")
      ++ singleton modId
      ++ (optional (versionId != null) versionId)
  else # curseforge
    (if (slug != null) then slug else modId)
    + (
      if (versionId != null) then ":${versionId}"
      else if (partialFilename != null) then "@${partialFilename}"
    else ""
  )
)