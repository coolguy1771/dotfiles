{ pkgs-unstable, config, ... }:

let
  deviceCfg = config.modules.device;
in
{
  config = {
    modules = {
      device = {
        cpu = "intel";
        gpu = "intel";
        hostId = "775b7d55";
      };

      users.twitlin.enable = true;
      users.groups = {
        external-services = {
          gid = 65542;
        };
        admins = {
          gid = 991;
          members = ["twitlin"];
        };
      };

      filesystem.zfs.enable = true;
      filesystem.zfs.mountPoolsAtBoot = [
        "pluto"
      ];

      monitoring.smartd.enable = true;

      servers.k3s = {
        enable = true;
        package = pkgs-unstable.k3s_1_29;
        extraFlags = [
          "--tls-san=osiris.${deviceCfg.domain}"
        ];
      };
      servers.nfs.enable = true;
      servers.samba.enable = true;
      servers.samba.shares = {
        Backup = {
          path = "/pluto/Backup";
          "read only" = "no";
        };
        twitlin = {
          path = "/pluto/twitlin";
          "read only" = "no";
        };
        mwitlin = {
          path = "/pluto/mwitlin";
          "read only" = "no";
        };
        media = {
          path = "/pluto/media";
          "read only" = "no";
        };
        minio = {
          path = "/pluto/minio";
          "read only" = "no";
        };
        timeMachine = {
          path = "/pluto/timeMachine";
          "vfs objects" = "acl_xattr catia fruit streams_xattr";
          "fruit:time machine" = "yes";
          "comment" = "Time Machine Backups";
          "path" = "/pluto/timeMachine";
          "read only" = "no";
        };
        # Docs = {
        #   path = "/tank/Docs";
        #   "read only" = "no";
        # };
        # Media = {
        #   path = "/tank/Media";
        #   "read only" = "no";
        # };
        # Paperless = {
        #   path = "/tank/Apps/paperless/incoming";
        #   "read only" = "no";
        # };
        # Software = {
        #   path = "/tank/Software";
        #   "read only" = "no";
        # };
      };

      system.openssh.enable = true;
      system.video.enable = true;
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}