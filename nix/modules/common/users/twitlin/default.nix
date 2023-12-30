args@{ pkgs, pkgs-unstable, vscode-extensions, lib, config, ... }:
with lib;

let
  cfg = config.modules.users.twitlin;
in {
  imports = [
    ( import ../../home-manager { username="twitlin"; } )
  ];

  options.modules.users.twitlin = {
    enable = mkEnableOption "twitlin";
    enableDevTools = mkEnableOption "Enable dev tools" // {
      default = false;
    };
    enableKubernetesTools = mkEnableOption "Enable k8s tools" // {
      default = false;
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    (mkIf (pkgs.stdenv.isLinux) (import ./nixos.nix args))
    (mkIf (pkgs.stdenv.isDarwin) (import ./darwin.nix args))

    {
      users.users.twitlin = {
        shell = pkgs.fish;
      };

      modules.users.twitlin.home-manager.enable = true;

      modules.users.twitlin.sops = {
        defaultSopsFile = ./secrets.sops.yaml;
        secrets = {
          atuin_key = {
            path = "${config.home-manager.users.twitlin.xdg.configHome}/atuin/key";
          };
        };
      };

      modules.users.twitlin.shell.atuin = {
        enable = true;
        package = pkgs-unstable.atuin;
        sync_address = "https://atuin.witl.xyz";
        config = {
          key_path = config.home-manager.users.twitlin.sops.secrets.atuin_key.path;
        };
      };

      modules.users.twitlin.shell.fish = {
        enable = true;
      };

      modules.users.twitlin.shell.git = {
        enable = true;
        username = "Tyler Witlin";
        email = "twitlin@witl.xyz";
        signing = {
          signByDefault = true;
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnKXgEGczcu8lGs+DEvRWgI4cSYHkAyTAU6/SMAHjL4 twitlin@mbp16inch2021.3520.dhcp.asu.edu";
        };
        aliases = {
          co = "checkout";
          logo = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ (%cn)\" --decorate";
          yolo = "!git commit -m \"$(curl -s whatthecommit.com/index.txt)\"";
          a = "add";
          ap = "add -p";
          amc = "am --continue";
          b = "branch";
          bm = "branch --merged";
          bnm = "branch --no-merged";
          c = "commit";
          cl = "clonr";
          ca = "commit --amend";
          cane ="commit --amend --no-edit";
          cf = "commit --fixup";
          cm = "commit --message";
          cob = "checkout -b";
          com = "checkout master";
          cp = "cherry-pick";
          d = "diff";
          dc = "diff --cached";
          dom = "diff origin/master";
          fo = "fetch origin";
          g = "grep --line-number";
          mbhom = "merge-base HEAD origin/master";
          mff = "merge --ff-only";
          ol = "log --pretty=oneline";
          l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
          pu = "push";
          puf = "push --force";
          pl = "pull --rebase --autostash";
          r = "restore";
          ra = "rebase --abort";
          rc = "rebase --continue";
          ri = "rebase --interactive";
          rl = "reflog";
          riom = "rebase --interactive origin/master";
          rpo = "remote prune origin";
          s = "status -sb";
          ss = "commit --message snapshot --no-gpg-sign";
          su = "submodule update";
          wd = "diff --patience --word-diff";
        };
        config = {
          core = {
            autocrlf = "input";
          };
          init = {
            defaultBranch = "main";
          };
          pull = {
            rebase = true;
          };
          rebase = {
            autoStash = true;
          };
        };
        ignores = [
          # Mac OS X hidden files
          ".DS_Store"
          # Windows files
          "Thumbs.db"
          # asdf
          ".tool-versions"
          # rtx
          ".rtx.toml"
          # Sops
          ".decrypted~*"
          "*.decrypted.*"
          # Python virtualenvs
          ".venv"
        ];
      };

      modules.users.twitlin.editor.nvim.enable = true;
      modules.users.twitlin.shell.starship.enable = true;
      modules.users.twitlin.shell.tmux.enable = true;
    }

    (mkIf (cfg.enableKubernetesTools) (import ./_kubernetes.nix args))
    (mkIf (cfg.enableDevTools) (import ./_devtools.nix args))
  ]);
}
# ❯ cat ~/.gitconfig
# [user]
#   name = Tyler Witlin
#   email = twitlin@witl.xyz
#   signingKey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnKXgEGczcu8lGs+DEvRWgI4cSYHkAyTAU6/SMAHjL4 twitlin@mbp16inch2021.3520.dhcp.asu.edu
# [gpg]
#   format = ssh
# [format]
#   signOff = true
# [core]
#   editor = nvim
#   excludesfile = /Users/twitlin/.gitignore_global
# [commit]
#   gpgsign = true
# [merge]
#   ff = only
# [pull]
#   rebase = true
# [status]
#   submoduleSummary = false
# [tag]
#   forceSignAnnotated = true
# [init]
#   defaultBranch = main
# [filter "lfs"]
#   smudge = git-lfs smudge -- %f
#   process = git-lfs filter-process
#   required = true
#   clean = git-lfs clean -- %f
# [url "ssh://git@github.com/"]
#   pushInsteadOf = https://github.com/
# [push]
#   autoSetupRemote = true