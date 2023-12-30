{ config, ... }:
let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.twitlin = {
    isNormalUser = true;
    uid = 568;
    extraGroups = [
      "wheel"
    ] ++ ifGroupsExist [
      "network"
      "samba-users"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnKXgEGczcu8lGs+DEvRWgI4cSYHkAyTAU6/SMAHjL4 twitlin@mbp16inch2021.3520.dhcp.asu.edu"
    ];
  };
}