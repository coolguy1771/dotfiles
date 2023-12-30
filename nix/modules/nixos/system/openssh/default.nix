{ lib, config, ... }:
with lib;

let
  cfg = config.modules.system.openssh;
in {
  options.modules.system.openssh = { enable = mkEnableOption "openssh"; };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        # Harden
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        # Automatically remove stale sockets
        StreamLocalBindUnlink = "yes";
        # Allow forwarding ports to everywhere
        GatewayPorts = "clientspecified";
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
          "aes256-ctr"
          "aes192-ctr"
          "aes128-ctr"
        ];
        KbdInteractiveAuthentication = false;
        KexAlgorithms = [
          "curve25519-sha256@libssh.org"
          "ecdh-sha2-nistp521"
          "ecdh-sha2-nistp384"
          "ecdh-sha2-nistp256"
          "diffie-hellman-group-exchange-sha256"
        ];
        Macs = [
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
          "hmac-sha2-512"
          "hmac-sha2-256"
          "umac-128@openssh.com"
        ];
        LogLevel = "VERBOSE";
        };
      extraConfig = ''
        ChallengeResponseAuthentication no
        PrintLastLog no
      '';
      sftpFlags = [
        "-f AUTHPRIV"
        "-l INFO"
      ];
    };

    security = mkIf cfg.enable {
      # Passwordless sudo when SSH'ing with keys
      pam.enableSSHAgentAuth = true;
    };
  };
}