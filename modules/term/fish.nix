# Fish Shell Configuration
# This is the main interactive shell I use.
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    fish = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fish";
    };
  };

  config = lib.mkIf config.nixconf.term.fish {
    environment.pathsToLink = ["/share/fish"];

    home-manager.users.${config.nixconf.user} = {
      xdg.configFile."fish/themes/".source =
        # Run `fish_config theme save "Catppuccin Mocha"`
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
          sha256 = "Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
        }
        + "/themes";

      programs.fish = {
        enable = true;
        shellInit = ''
          set fish_greeting # Disable greeting
        '';
      };
    };
  };
}
