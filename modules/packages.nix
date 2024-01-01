{pkgs, ...}: {
  # Default packages to install at system level
  # TODO: might not need this?
  environment.systemPackages = with pkgs; [
    curl
    wget
    unzip
    coreutils
    lsof
    pciutils
    lshw
    libva-utils
    glxinfo
    kitty
  ];
}
