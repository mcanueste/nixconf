{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.editor = {
    vscode = lib.mkEnableOption "VSCode";
  };

  config = {
    # I only use it to help other devs use it for python development at work: not a prod setup
    programs.vscode = {
      enable = config.nixconf.editor.vscode;
      package = pkgs.vscode.fhsWithPackages (ps:
        with ps; [
          zlib
          openssl.dev
          pkg-config
        ]);
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        ms-vscode-remote.remote-ssh
        ms-python.python
        ms-python.debugpy
        charliermarsh.ruff
        njpwerner.autodocstring
        mkhl.direnv
        ms-vscode.makefile-tools
        skellock.just
      ];
      userSettings = {
        "telemetry.telemetryLevel" = "off";
        "update.showReleaseNotes" = false;

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
