{
  lib,
  config,
  ...
}: {
  imports = [
    ./lsp.nix
  ];

  options.nixconf.editor = {
    zed = lib.mkEnableOption "Zed";
  };

  config = {
    programs.zed-editor = {
      enable = config.nixconf.editor.zed;

      userSettings = {
        # Available providers and models
        # zed.dev - claude-3-5-sonnet-latest
        # copilot_chat - o1-preview, o1-mini, gpt-4, gpt-4o, claude-3-5-sonnet
        assistant = {
          version = "2";
          default_model = {
            provider = "copilot_chat";
            model = "o1-mini";
          };
          inline_alternatives = [
            {
              provider = "copilot_chat";
              model = "claude-3-5-sonnet";
            }
          ];
        };

        # zed system settings
        hour_format = "hour24";

        # theme settings
        theme = {
          mode = "system";
          light = "Catppuccin Latte";
          dark = "Catppuccin Mocha";
        };
        tabs = {
          file_icons = true;
          git_status = true;
        };
        buffer_font_family = "JetBrainsMono Nerd Font";
        buffer_font_size = 16;

        cursor_blink = false;
        relative_line_numbers = true;

        autosave.after_delay.milliseconds = 1000;

        preview_tabs = {
          enable_preview_from_file_finder = true;
          enable_preview_from_code_navigation = true;
        };

        search = {
          whole_word = false;
          case_sensitive = false;
          include_ignored = false;
          regex = false;
        };

        terminal = {
          alternate_scroll = "off";
          blinking = "terminal_controlled";
          copy_on_select = false;
          dock = "bottom";
          detect_venv.on = {
            directories = [".env" "env" ".venv" "venv"];
            activate_script = "default";
          };
          font_family = "JetBrainsMono Nerd Font";
          font_size = 16;
          button = false;
          shell.program = "fish";
        };
      };
    };
  };
}
