{ ... }:

{
  mergeAttrs = attrList: import ./mergeAttrs.nix attrList;
}