{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.dev = {
    gh = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "GitHub Client";
    };
  };

  config = let
    shellAliases = {
      explain = "gh copilot explain";
      suggest = "gh copilot suggest";
    };
  in
    lib.mkIf config.nixconf.dev.gh
    {
      home-manager.users.${config.nixconf.system.user} = {
        programs.bash = {inherit shellAliases;};
        programs.zsh = {inherit shellAliases;};
        programs.fish = {inherit shellAliases;};

        programs.gh = {
          enable = true;
          settings = {};
          extensions = [pkgs.gh-dash pkgs.gh-copilot];
        };
      };
    };
}
