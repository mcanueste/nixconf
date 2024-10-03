{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.kanata = pkgs.libExt.mkEnabledOption "Kanata";

  config = lib.mkIf config.nixconf.kanata {
    users.users.${config.nixconf.username}.extraGroups = [
      "input"
      "uinput"
    ];

    # Used cat /proc/bus/input/devices to get the corne information
    # Also used udevadm info -a -n /dev/input/event29 to get the information
    # Also used udevadm monitor to get the information
    # KERNEL=="event*", SYSFS{manufacturer}=="Microsoft", SYSFS{idProduct}=="0023", NAME="input/cornekbd"
    # ATTRS{name}=="Corne Keyboard", SYMLINK+="cornekbd"
    # ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0461", ATTRS{idProduct}=="4d81", SYMLINK+="myusb"
    services.udev.extraRules = ''
      KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="Corne Keyboard", SYMLINK+="input/cornekbd"
    '';

    services.kanata = {
      enable = true;
      keyboards = let
        extraDefCfg = ''
          process-unmapped-keys yes
        '';

        unicodeAliases = ''
          (defalias
            _ae (unicode ä)
            _Ae (unicode Ä)
            _ue (unicode ü)
            _Ue (unicode Ü)
            _oe (unicode ö)
            _Oe (unicode Ö)
            _sh (unicode ş)
            _Sh (unicode Ş)
            _ch (unicode ç)
            _Ch (unicode Ç)
            _ii (unicode ı)
            _Ii (unicode İ)
            _gg (unicode ğ)
            _Gg (unicode Ğ)

            ss (unicode ß)
            ae (fork @_ae @_Ae (lsft rsft))
            ue (fork @_ue @_Ue (lsft rsft))
            oe (fork @_oe @_Oe (lsft rsft))
            sh (fork @_sh @_Sh (lsft rsft))
            ch (fork @_ch @_Ch (lsft rsft))
            ii (fork @_ii @_Ii (lsft rsft))
            gg (fork @_gg @_Gg (lsft rsft))

            ' (tap-hold $tap-time $hold-time ' (layer-while-held unicodechars))
          )
        '';

        homerowAliases = ''
          (defvar
            tap-time 190
            hold-time 190
          )

          (defalias
            tap (multi (layer-switch nomods) (on-idle-fakekey to-base tap 20))
            a (tap-hold-release-keys $tap-time $hold-time (multi a @tap) lmet $left-hand-keys)
            s (tap-hold-release-keys $tap-time $hold-time (multi s @tap) lalt $left-hand-keys)
            d (tap-hold-release-keys $tap-time $hold-time (multi d @tap) lctrl $left-hand-keys)
            f (tap-hold-release-keys $tap-time $hold-time (multi f @tap) lshft $left-hand-keys)
            j (tap-hold-release-keys $tap-time $hold-time (multi j @tap) rshft $right-hand-keys)
            k (tap-hold-release-keys $tap-time $hold-time (multi k @tap) lctrl $right-hand-keys)
            l (tap-hold-release-keys $tap-time $hold-time (multi l @tap) lalt $right-hand-keys)
            ; (tap-hold-release-keys $tap-time $hold-time (multi ; @tap) lmeta $right-hand-keys)
          )

          (deffakekeys
            to-base (layer-switch base)
          )
        '';
      in {
        default = {
          inherit extraDefCfg;

          devices = [
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
            "/dev/input/by-id/usb-Logitech_USB_Receiver-event-kbd"
          ];

          config = ''
            (defsrc
                    q     w     e     r     t     y     u     i     o     p
              caps  a     s     d     f     g     h     j     k     l     ;     '
                    z     x     c     v     b     n     m     ,     .     /
                                              spc
            )

            (deflayer base
                    q     w     e     r     t     y     u     i     o     p
              esc   @a    @s    @d    @f    g     h     @j    @k    @l    @;    @'
                    @cnz  @cnx  @cnc  v     b     n     m     ,     .     /
                                              @spc
            )

            (deflayer unicodechars
                    XX    XX    XX    XX    XX    XX    @ue   @ii   @oe   XX
              XX    @ae   @sh   XX    lshft @gg   XX    rshft XX    XX    XX    XX
                    XX    XX    @ch   XX    @ss   XX    XX    XX    XX    XX
                                               XX
            )

            (deflayer symbols ;;3-# 4-$ 6-^ 8-* 7-& \-| 5-% 1-! 2-@
                    S-3   S-8   S-[   S-]   XX    XX    7     8     9     S-2
              XX    S-6   S-4   S-9   S-0   XX    XX    4     5     6     S-5   XX
                    S-7   S-\   [     ]     XX    0     1     2     3     S-1
                                               XX
            )

            (deflayer nomods
                    q     w     e     r     t     y     u     i     o     p
              esc   a     s     d     f     g     h     j     k     l     ;     '
                    @cbz  @cbx  @cbc  v     b     n     m     ,     .     /
                                              spc
            )

            (defchords switchnomodschord 500
              (z    ) z
              (  x  ) x
              (    c) c
              (z x c) @switchnomods
            )

            (defchords switchbasechord 500
              (z    ) z
              (  x  ) x
              (    c) c
              (z x c) @switchbase
            )

            (defalias
              spc (tap-hold $tap-time $hold-time spc (layer-while-held symbols))

              switchnomods (layer-switch nomods)
              switchbase (layer-switch base)

              cnz (chord switchnomodschord z)
              cnx (chord switchnomodschord x)
              cnc (chord switchnomodschord c)

              cbz (chord switchbasechord z)
              cbx (chord switchbasechord x)
              cbc (chord switchbasechord c)
            )

            (defvar
              left-hand-keys (
                    q w e r t
                esc         g
                    z x c v b
              )
              right-hand-keys (
                y u i o p
                h         '
                n m , . /
              )
            )

            ${unicodeAliases}
            ${homerowAliases}
          '';
        };

        corne = {
          inherit extraDefCfg;

          devices = [
            "/dev/input/cornekbd"
          ];

          config = ''
            (defsrc
              grv   q     w     e     r     t     y     u     i     o     p     -
              esc   a     s     d     f     g     h     j     k     l     ;     '
              \     z     x     c     v     b     n     m     ,     .     /     =
                                del   tab   bspc  spc   ret   lshft
            )

            (deflayer base
              grv   q     w     e     r     t     y     u     i     o     p     -
              esc   @a    @s    @d    @f    g     h     @j    @k    @l    @;    @'
              \     z     x     c     v     b     n     m     ,     .     /     =
                                del   @tab  @bspc @spc  ret   (caps-word 2000)
            )

            (deflayer unicodechars
              XX    XX    XX    XX    XX    XX    XX    @ue   @ii   @oe   XX    XX
              XX    @ae   @sh   XX    lshft @gg   XX    rshft XX    XX    XX    XX
              XX    XX    XX    @ch   XX    @ss   XX    XX    XX    XX    XX    XX
                                XX    XX    XX    XX    XX    XX
            )

            (deflayer symbols ;;3-# 4-$ 6-^ 8-* 7-& \-| 5-% 1-! 2-@
              XX    S-3   S-8   S-[   S-]   XX    XX    7     8     9     S-2   XX
              XX    S-6   S-4   S-9   S-0   XX    XX    4     5     6     S-5   XX
              XX    S-7   S-\   [     ]     XX    0     1     2     3     S-1   XX
                                XX    XX    XX    XX    XX    XX
            )

            (deflayer navigation
              XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX
              XX    lmet  lalt  lctrl lshft XX    lft   down  up    rght  XX    XX
              XX    XX    XX    XX    XX    XX    home  pgdn  pgup  end   XX    XX
                                XX    XX    XX    XX    XX    XX
            )

            (deflayer numbers
              XX    XX    XX    XX    XX    XX    XX    7     8     9     XX    XX
              XX    lmet  lalt  lctrl lshft XX    XX    4     5     6     XX    XX
              XX    XX    XX    XX    XX    XX    0     1     2     3     XX    XX
                                XX    XX    XX    XX    XX    XX
            )

            (deflayer nomods
              grv   q     w     e     r     t     y     u     i     o     p     -
              esc   a     s     d     f     g     h     j     k     l     ;     '
              \     z     x     c     v     b     n     m     ,     .     /     =
                                del   tab   bspc  spc   ret   lshft
            )

            (defalias
              spc (tap-hold $tap-time $hold-time spc (layer-while-held symbols))
              bspc (tap-hold $tap-time $hold-time bspc (layer-while-held navigation))
              tab (tap-hold $tap-time $hold-time tab (layer-while-held numbers))
            )

            (defvar
              left-hand-keys (
                grv q w e r t
                esc         g
                \   z x c v b
              )
              right-hand-keys (
                y u i o p -
                h         '
                n m , . / =
              )
            )

            ${unicodeAliases}
            ${homerowAliases}
          '';
        };
      };
    };
  };
}
