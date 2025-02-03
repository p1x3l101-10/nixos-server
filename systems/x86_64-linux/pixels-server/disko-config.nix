{ inputs, ... }:

inputs.nixos-home.lib.confTemplates.disko {
  disk-id = "nvme-WDC_PC_SN520_SDAPNUW-512G-1014_19131B802948_1";
  esp-size = "1G";
  swap-size = "50G";
  tmp-size = "20G";
}
