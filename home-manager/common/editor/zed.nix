{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.editor = {
    zed = lib.mkEnableOption "Zed";
  };

  config = {
    programs.zed-editor = {
      enable = config.nixconf.editor.zed;

      extensions = [
        "ansible"
        "basher"
        "cargo-tom"
        "catppuccin"
        "csv"
        "docker-compose"
        "dockerfile"
        "fish"
        "golangci-lint"
        "graphql"
        "groovy"
        "helm"
        "html"
        "just"
        "log"
        "lua"
        "make"
        "mermaid"
        "meson"
        "neocmake"
        "nginx"
        "nix"
        "ocaml"
        "pylsp"
        "python-refactoring"
        "ruff"
        "snippets"
        "sql"
        "terraform"
        "tmux"
        "toml"
        # "elixir"
      ];

      userSettings = {
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

        vim_mode = true;
        vim = {
          use_multiline_find = true; # Make vim's `f` and `t` multiline
          use_smartcase_find = true; # use smart case when using `f` and `t`
          toggle_relative_line_numbers = true; # relative numbers on norm, abs on insert.
        };

        cursor_blink = false;
        relative_line_numbers = true;
        # command_aliases = {
        #     "W" = "w";
        #     "Wq" = "wq";
        #     "Q" = "q";
        # };

        autosave.after_delay.milliseconds = 1000;
        # base_keymap = "None"; # do we still need base keymap?

        # Dev Related
        load_direnv = "shell_hook"; # load direnv automatically, used with direnv plugin

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

        inline_completions = {
          disabled_globs = [
            # disable completions from these files
            ".env"
            ".venv"
            ".direnv"
          ];
        };

        inlay_hints = {
          enabled = true;
          show_background = false;
          edit_debounce_ms = 700;
          scroll_debounce_ms = 50;
        };

        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        file_types = {
          Helm = [
            "**/templates/**/*.tpl"
            "**/templates/**/*.yaml"
            "**/templates/**/*.yml"
            "**/helmfile.d/**/*.yaml"
            "**/helmfile.d/**/*.yml"
          ];
        };

        lsp = {
          bash-language-server = {
            settings = {
              shellcheckPath = lib.getExe pkgs.shellcheck;
              shfmt.path = lib.getExe pkgs.shfmt;
            };
          };

          nixd = {
            binary.path = lib.getExe pkgs.nixd;
            settings = {
              diagnostic.suppress = ["sema-extra-with"];
              formatting.command = [(lib.getExe pkgs.alejandra)];
              nixpkgs.expr = "import (builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").inputs.nixpkgs { }";
              options = {
                nixos.expr = "(builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").nixosConfigurations.nixos.options";
                home-manager.expr = "(builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").homeConfigurations.\"${config.nixconf.username}@nixos\".options";
              };
            };
          };

          terraform-ls = {
            initialization_options = {
              experimentalFeatures = {
                prefillRequiredFields = true;
              };
            };
          };

          # TODO: how do we map the settings?
          # dockerls = {
          #   settings.docker.languageserver.formatter.ignoreMultilineInstructions = true;
          # };

          rust-analyzer = {
            binary.path = lib.getExe pkgs.rust-analyzer;
            settings = {
              check.command = lib.getExe pkgs.clippy;
              inlayHints.lifetimeElisionHints.enable = "always";
            };
          };
        };

        languages = {
          Nix.language_servers = ["nixd" "!nil"];

          # TODO: shellharden
        };
      };

      userKeymaps = [
        {
          # Navigate between panes in docks
          context = "Dock";
          bindings = {
            "ctrl-w h" = "[workspace::ActivatePaneInDirection, Left]";
            "ctrl-w l" = "[workspace::ActivatePaneInDirection, Right]";
            "ctrl-w k" = "[workspace::ActivatePaneInDirection, Up]";
            "ctrl-w j" = "[workspace::ActivatePaneInDirection, Down]";
          };
        }
        {
          # subword navigation for snake_case and camelCase
          context = "VimControl && !menu && vim_mode != operator";
          bindings = {
            "w" = "vim::NextSubwordStart";
            "b" = "vim::PreviousSubwordStart";
            "e" = "vim::NextSubwordEnd";
            "g e" = "vim::PreviousSubwordEnd";
          };
        }
        {
          # add surround in visual mode with shift-s
          context = "vim_mode == visual";
          bindings = {
            "shift-s" = [
              "vim=:PushOperator"
              {"AddSurrounds" = {};}
            ];
          };
        }
        {
          context = "Editor && !menu";
          bindings = {
            "ctrl-s" = "editor==Save";
            # "ctrl-c"= "editor==Copy";          # vim default= return to normal mode
            # "ctrl-x"= "editor==Cut";           # vim default= decrement
            # "ctrl-v"= "editor==Paste";         # vim default= visual block mode
            # "ctrl-y"= "editor==Undo";          # vim default= line up
            # "ctrl-f"= "buffer_search==Deploy"; # vim default= page down
            # "ctrl-o"= "workspace==Open";       # vim default= go back
            # "ctrl-a"= "editor==SelectAll";     # vim default= increment
          };
        }
      ];
    };
  };
}
