{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.editor = {
    vscode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable VSCode";
    };
  };

  config = lib.mkIf config.nixconf.dev.editor.vscode {
    home-manager.users.${config.nixconf.system.user} = {
      programs.vscode = {
        enable = true;
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        extensions = with pkgs.vscode-extensions; [
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          hashicorp.hcl
          hashicorp.terraform
          ms-python.python
          # ms-python.vscode-pylance
          charliermarsh.ruff
        ];
      };
    };
  };
}
