{
  pkgs,
  inputs,
  config,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Flakes settings
  nix.package = pkgs.nixVersions.unstable;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.warn-dirty = false;

  # Optimise store
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  # Automate garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  # Avoid unwanted garbage collection when using nix-direnv
  nix.settings.keep-outputs = true;
  nix.settings.keep-derivations = true;

  # Binary caches
  nix.settings = {
    trusted-users = ["root" "${config.nixconf.user}"];
    substituters = [
      "https://cache.nixos.org"
      # "https://cache.garnix.io" no need for this
      # "https://hyprland.cachix.org" really slow...
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    jemalloc
    rust-jemalloc-sys
    stdenv.cc.cc
    zlib
    pkg-config
    fuse3
    icu
    zlib
    nss
    openssl
    curl
    expat

    # # List by default
    # zlib
    # zstd
    # stdenv.cc.cc
    # curl
    # openssl
    # attr
    # libssh
    # bzip2
    # libxml2
    # acl
    # libsodium
    # util-linux
    # xz
    # systemd
    #
    # # My own additions
    # xorg.libXcomposite
    # xorg.libXtst
    # xorg.libXrandr
    # xorg.libXext
    # xorg.libX11
    # xorg.libXfixes
    # libGL
    # libva
    # pipewire.lib
    # xorg.libxcb
    # xorg.libXdamage
    # xorg.libxshmfence
    # xorg.libXxf86vm
    # libelf
    #
    # # Required
    # glib
    # gtk2
    #
    # # Without these it silently fails
    # xorg.libXinerama
    # xorg.libXcursor
    # xorg.libXrender
    # xorg.libXScrnSaver
    # xorg.libXi
    # xorg.libSM
    # xorg.libICE
    # gnome2.GConf
    # nspr
    # nss
    # cups
    # libcap
    # SDL2
    # libusb1
    # dbus-glib
    # ffmpeg
    # # Only libraries are needed from those two
    # libudev0-shim
    #
    # # needed to run unity
    # gtk3
    # icu
    # libnotify
    # gsettings-desktop-schemas
    # # https://github.com/NixOS/nixpkgs/issues/72282
    # # https://github.com/NixOS/nixpkgs/blob/2e87260fafdd3d18aa1719246fd704b35e55b0f2/pkgs/applications/misc/joplin-desktop/default.nix#L16
    # # log in /home/leo/.config/unity3d/Editor.log
    # # it will segfault when opening files if you don’t do:
    # # export XDG_DATA_DIRS=/nix/store/0nfsywbk0qml4faa7sk3sdfmbd85b7ra-gsettings-desktop-schemas-43.0/share/gsettings-schemas/gsettings-desktop-schemas-43.0:/nix/store/rkscn1raa3x850zq7jp9q3j5ghcf6zi2-gtk+3-3.24.35/share/gsettings-schemas/gtk+3-3.24.35/:$XDG_DATA_DIRS
    # # other issue: (Unity:377230): GLib-GIO-CRITICAL **: 21:09:04.706: g_dbus_proxy_call_sync_internal: assertion 'G_IS_DBUS_PROXY (proxy)' failed
    #
    # # Verified games requirements
    # xorg.libXt
    # xorg.libXmu
    # libogg
    # libvorbis
    # SDL
    # SDL2_image
    # glew110
    # libidn
    # tbb
    #
    # # Other things from runtime
    # flac
    # freeglut
    # libjpeg
    # libpng
    # libpng12
    # libsamplerate
    # libmikmod
    # libtheora
    # libtiff
    # pixman
    # speex
    # SDL_image
    # SDL_ttf
    # SDL_mixer
    # SDL2_ttf
    # SDL2_mixer
    # libappindicator-gtk2
    # libdbusmenu-gtk2
    # libindicator-gtk2
    # libcaca
    # libcanberra
    # libgcrypt
    # libvpx
    # librsvg
    # xorg.libXft
    # libvdpau
    # # ...
    # # Some more libraries that I needed to run programs
    # gnome2.pango
    # cairo
    # atk
    # gdk-pixbuf
    # fontconfig
    # freetype
    # dbus
    # alsaLib
    # expat
    # # Needed for electron
    # libdrm
    # mesa
    # libxkbcommon
    # # Needed to run, via virtualenv + pip, matplotlib & tikzplotlib
    # stdenv.cc.cc.lib # to provide libstdc++.so.6
  ];

  imports = [
    ./browsers.nix
    ./chat.nix
    ./desktop
    ./editors
    ./font.nix
    ./gaming.nix
    ./hardware
    ./locale.nix
    ./media.nix
    ./networking.nix
    ./packages.nix
    ./security.nix
    ./term
    ./tools
    ./user.nix
    ./virtualization.nix
  ];
}
