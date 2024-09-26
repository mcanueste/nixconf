{pkgs, ...}: {
  # TODO: fix and document these things
  programs.nix-ld = {
    enable = true;
    libraries = [
      # needed by torch-experiments
      pkgs.glib
      pkgs.libGL
      pkgs.libGLU
      pkgs.freeglut
      pkgs.xorg.libX11

      pkgs.stdenv.cc.cc
      pkgs.stdenv.cc.cc.lib # to provide libstdc++.so.6

      # crypto related links
      pkgs.openssl
      pkgs.libxcrypt

      # Game Dev with Bevy
      pkgs.udev
      pkgs.alsa-lib
      pkgs.clang
      pkgs.lld
      pkgs.vulkan-tools
      pkgs.vulkan-headers
      pkgs.vulkan-loader
      pkgs.vulkan-validation-layers

      # If using x11
      # pkgs.xorg.libX11
      # pkgs.xorg.libXcursor
      # pkgs.xorg.libXi
      # pkgs.xorg.libXrandr # To use the x11 feature

      # If using wayland
      pkgs.libxkbcommon
      pkgs.wayland

      # cudaPackages.cudatoolkit
      # cudaPackages.cudnn
      # cudaPackages.cudatoolkit.lib
      # cudaPackages.tensorrt

      # pipewire.lib
      # pkg-config

      # jemalloc
      # rust-jemalloc-sys
      # zlib
      # fuse3
      # icu
      # zlib
      # nss
      # curl
      # expat

      # # List by default
      # zlib
      # zstd
      # curl
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
      # xorg.libXext
      # xorg.libX11
      # xorg.libXfixes
      # libva
      # xorg.libxcb
      # xorg.libXdamage
      # xorg.libxshmfence
      # xorg.libXxf86vm
      # libelf
      #
      # # Required
      # gtk2
      #
      # # Without these it silently fails
      # xorg.libXinerama
      # xorg.libXrender
      # xorg.libXScrnSaver
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
      # expat
      # # Needed for electron
      # libdrm
      # mesa
      # # Needed to run, via virtualenv + pip, matplotlib & tikzplotlib
    ];
  };
}
