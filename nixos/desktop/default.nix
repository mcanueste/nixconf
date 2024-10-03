{
  lib,
  config,
  ...
}: {
  imports = [
    ./cosmic.nix
    ./gnome.nix
  ];

  options.nixconf.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop configs.";
    };
  };

  config = lib.mkIf config.nixconf.desktop.enable {


    # enable desktop portal
    xdg.portal.enable = true;
  };
}
