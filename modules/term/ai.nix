{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    ai = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable terminal AI tools";
    };
  };

  config = lib.mkIf config.nixconf.term.ai {
    home-manager.users.${config.nixconf.system.user} = let
      shellAliases = {
        chat = "aichat"; # TODO: investigate aichat usecases
      };
    in {
      programs.bash = {inherit shellAliases;};
      programs.zsh = {inherit shellAliases;};
      programs.fish = {inherit shellAliases;};

      home.packages = [
        # TODO this doesn't work with gpt-4??
        # TODO investigate CLI tools for generating images and audio as well
        pkgs.aichat # https://github.com/sigoden/aichat
        # add ~/.config/aichat/config.yaml file with OpenAI key
        # https://github.com/sigoden/aichat/blob/main/config.example.yaml
      ];
    };
  };
}
