{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    ai = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable terminal AI tools";
    };
  };

  config = lib.mkIf config.nixconf.term.ai {
    home-manager.users.${config.nixconf.user} = let
      shellAliases = {
        explain = "gh copilot explain";
        suggest = "gh copilot suggest";
        gpt = "chatblade";
      };
    in {
      programs.bash = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};

      home.sessionVariables = {
        OPENAI_API_KEY = "$(cat ~/.ssh/openai.key)";
        OPENAI_API_MODEL = "gpt-4";
      };

      programs.bash = {
        sessionVariables = {
          OPENAI_API_KEY = "$(cat ~/.ssh/openai.key)";
          OPENAI_API_MODEL = "gpt-4";
        };
      };

      programs.fish = {
        shellInitLast = ''
          set -gx OPENAI_API_KEY (cat ~/.ssh/openai.key)
          set -gx OPENAI_API_MODEL "gpt-4"
        '';
      };

      home.packages = [
        pkgs.gh
        pkgs.chatblade
      ];
    };
  };
}
