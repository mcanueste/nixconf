{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev.editor = {
    helix = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Helix";
    };
  };

  config = lib.mkIf config.nixconf.dev.editor.helix {
    home-manager.users.${config.nixconf.user} = {
      programs.helix = {
        enable = true;

        settings = {
          theme = "catppuccin_mocha";
          editor = {
            line-number = "relative";
            cursorline = true;
            completion-replace = true;
            rulers = [81];
            color-modes = true;
            lsp = {
              display-messages = true;
              display-inlay-hints = true;
            };
            file-picker = {
              hidden = false;
            };
            indent-guides = {
              render = true;
            };
          };
        };

        languages = {
          language = [
            {
              name = "nix";
              auto-format = true;
              formatter = {
                command = "alejandra";
              };
            }
          ];
        };

        extraPackages = [
          pkgs.nil
          pkgs.alejandra
        ];
      };
    };
  };
}
