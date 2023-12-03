{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.lib.conflib; let
  cfg = config.nixhome.scripts;

  nvidia-offload = pkgs.writeShellApplication {
    name = "nvidia-offload";
    runtimeInputs = [];
    text = ''
      #!/usr/bin/env bash
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '';
  };
in {
  options.nixhome.scripts = {
    enable = mkBoolOption {description = "Enable scripts";};
    nvidia-offload = mkBoolOption {description = "Enable nvidia-offload script";};
  };

  config = lib.mkIf cfg.enable {
    home.packages = filterPackages [
      (getPackageIf cfg.nvidia-offload nvidia-offload)
    ];
  };
}
