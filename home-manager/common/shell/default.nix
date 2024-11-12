{pkgs, ...}: let
  enable = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
in {
  imports = [
    ./bash.nix
  ];

  options.nixconf.shell = {
    starship = pkgs.libExt.mkEnabledOption "Starship";

    fish = pkgs.libExt.mkEnabledOption "Fish";
  };

  config = {
    programs = {
      bat = {
        enable = true;
        catppuccin.enable = true;
        extraPackages = with pkgs.bat-extras; [
          batgrep
          batman
          prettybat
        ];
      };

      dircolors = enable;

      direnv = builtins.removeAttrs enable ["enableFishIntegration"]; # fish integration enabled by default

      eza =
        enable
        // {
          git = true;
          icons = "auto";
        };

      fzf =
        enable
        // {
          catppuccin.enable = true;
          tmux.enableShellIntegration = true;
          defaultCommand = "${pkgs.fd}/bin/fd --type f";
          fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
          fileWidgetOptions = [
            "--preview '${pkgs.bat}/bin/bat --style=numbers --color=always --line-range :500 {}'"
          ];
          changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
          changeDirWidgetOptions = ["--preview '${pkgs.tree}/bin/tree -C {} | head -200'"];
        };

      yazi =
        enable
        // {
          catppuccin.enable = true;
          keymap = {};
          settings = {};
        };

      zoxide = enable;

      starship =
        enable
        // {
          catppuccin.enable = true;

          settings = {
            scan_timeout = 10;
            add_newline = true;
            # format = "$all"; # Disable default prompt format
            battery = {disabled = true;};
            fill = {disabled = true;};
          };
        };

      fish = {
        enable = true;
        catppuccin.enable = true;
        shellInit = ''
          set fish_greeting # Disable greeting
          fish_vi_key_bindings
        '';
      };
    };

    home.packages = [
      pkgs.aichat
    ];
  };
}
