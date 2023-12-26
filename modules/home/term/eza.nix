{
  lib,
  config,
  ...
}: {
  options.nixconf.term = {
    eza = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable eza";
    };
  };

  config = lib.mkIf config.nixconf.term.eza {
    programs.eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
  };
}
