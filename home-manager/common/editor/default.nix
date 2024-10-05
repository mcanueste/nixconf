{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./neovim.nix
  ];

  options.nixconf.editor = {
    vscode = lib.mkEnableOption "VSCode";
  };

  config = {
    programs.vscode = {
      enable = config.nixconf.editor.vscode;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons

        vscodevim.vim
        github.copilot
        ms-vscode-remote.remote-ssh
        mhutchie.git-graph
        eamodio.gitlens

        ms-python.python
        ms-python.debugpy
        charliermarsh.ruff
        njpwerner.autodocstring

        rust-lang.rust-analyzer

        golang.go

        jnoortheen.nix-ide
        mkhl.direnv

        ms-vscode.makefile-tools
        skellock.just

        hashicorp.hcl
        hashicorp.terraform

        ms-kubernetes-tools.vscode-kubernetes-tools
      ];
      userSettings = {
        "telemetry.telemetryLevel" = "off";
        "update.showReleaseNotes" = false;

        # Theme
        "workbench.colorTheme" = "Catppuccin Mocha";
        "catppuccin.bracketMode" = "neovim";

        # Font
        "editor.fontSize" = 16;
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace', monospace";
        "terminal.integrated.fontSize" = 16;
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace', monospace";
        "window.zoomLevel" = 1;
        "workbench.startupEditor" = "none";
        "explorer.compactFolders" = false;

        # Whitespace
        "files.trimTrailingWhitespace" = true;
        "files.trimFinalNewlines" = true;
        "files.insertFinalNewline" = true;
        "diffEditor.ignoreTrimWhitespace" = false;

        # Git
        "git.enableCommitSigning" = true;
        "git-graph.repository.sign.commits" = true;
        "git-graph.repository.sign.tags" = true;
        "git-graph.repository.commits.showSignatureStatus" = true;

        # Editor settings
        "editor.formatOnSave" = true;

        # Python
        "[python]" = {
          "editor.defaultFormatter" = "charliermarsh.ruff";
          "notebook.formatOnSave.enabled" = true;
          "analysis.typeCheckingMode" = "standard";
          "testing.pytestEnabled" = true;
          "testing.unittestEnabled" = false;
          "testing.pytestArgs" = ["."];

          "editor.codeActionsOnSave" = {
            "source.fixAll" = "explicit";
            "source.organizeImports" = "explicit";
          };

          "notebook.codeActionsOnSave" = {
            "notebook.source.fixAll" = "explicit";
            "notebook.source.organizeImports" = "explicit";
          };
        };
      };
    };
  };
}
