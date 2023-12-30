{ config, ... }:
let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.twitlin = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
    ] ++ ifGroupsExist [
      "network"
      "samba-users"
    ];
    password = "$6$BF1VGgxuvHvcDzid$OUjyjst5IUOruRYyqloSLL7gxXAt8ipi31xO.3jvl9HzKz8p0UBkz32Ex2rUqhF3smpfbJU3Yzws/yxin32tX0";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnKXgEGczcu8lGs+DEvRWgI4cSYHkAyTAU6/SMAHjL4 twitlin@mbp16inch2021.3520.dhcp.asu.edu"
    ];
  };
}