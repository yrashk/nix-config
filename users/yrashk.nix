{ config, pkgs, ... }:

{
  isNormalUser = true;
  description = "Yurii Rashkovskii";
  home = "/home/yrashk";
  extraGroups = ["wheel" "vboxusers" "docker"];
  uid = 1000;
  hashedPassword = "$6$YZ2znbV6G4$dbKGu7E/ywwHVmZy9Ez3nenesHncLyKqQKYwdWo9QTLerhDH3NCxleuT8fl5vDCGEzDQrLwpd/VMmDgy90D3q1"; 
  shell = pkgs.fish;
}
