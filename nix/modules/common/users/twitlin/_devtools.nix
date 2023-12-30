{ pkgs, pkgs-unstable, ... }:

let
  vscode-extensions = (import ../../editor/vscode/extensions.nix){pkgs = pkgs;};
in
{
  # modules.users.twitlin.editor.vscode = {
  #   enable = true;
  #   package = pkgs-unstable.vscode;

  #   extensions = (with vscode-extensions; [
  #     eamodio.gitlens
  #     golang.go
  #     fnando.linter
  #     github.copilot
  #     hashicorp.terraform
  #     jnoortheen.nix-ide
  #     luisfontes19.vscode-swissknife
  #     mrmlnc.vscode-json5
  #     ms-vscode-remote.remote-containers
  #     ms-vscode-remote.remote-ssh
  #     redhat.ansible
  #     ms-python.python
  #     ms-python.vscode-pylance
  #   ]);

  #   config = {
  #     # Extension settings
  #     ansible = {
  #       python.interpreterPath = ".venv/bin/python";
  #     };

  #     linter = {
  #       linters = {
  #         yamllint = {
  #           configFiles = [
  #             ".yamllint.yml"
  #             ".yamllint.yaml"
  #             ".yamllint"
  #             ".ci/yamllint/.yamllint.yaml"
  #           ];
  #         };
  #       };
  #     };

  #     qalc = {
  #       output.displayCommas = false;
  #       output.precision = 0;
  #       output.notation = "auto";
  #     };
  #   };
  # };

  modules.users.twitlin.shell.rtx = {
    enable = true;
    package = pkgs-unstable.rtx;
  };

  modules.users.twitlin.virtualisation.colima = {
    enable = true;
    enableService = true;
    package = pkgs-unstable.colima;
  };

  home-manager.users.twitlin.home.packages = [
    pkgs.envsubst
    pkgs.go-task
  ];
}
