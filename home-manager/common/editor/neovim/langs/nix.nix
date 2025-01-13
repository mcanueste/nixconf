{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.nixvim.plugins = {
    lsp.servers.nixd = {
      enable = true;
      settings = {
        formatting.command = ["alejandra"];
        nixpkgs.expr = "import (builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").inputs.nixpkgs { }";
        options = {
          nixos.expr = "(builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").nixosConfigurations.nixos.options";
          home-manager.expr = "(builtins.getFlake \"/home/${config.nixconf.username}/nixconf\").homeConfigurations.\"${config.nixconf.username}@nixos\".options";
        };
      };
    };

    conform-nvim.settings = {
      formatters.alejandra.command = lib.getExe pkgs.alejandra;
      formatters_by_ft.nix = ["alejandra"];
    };
  };
}
