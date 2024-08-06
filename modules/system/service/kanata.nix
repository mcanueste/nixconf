{
  lib,
  config,
  ...
}: {
  options.nixconf.system.service = {
    kanata = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable kanata.";
    };
  };

  config = lib.mkIf config.nixconf.system.service.kanata {
    users.users.${config.nixconf.system.user}.extraGroups = [
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

        thumbNoOp = "XX";
        thumbCorneNoOp = "XX XX XX XX XX XX";
        thumbNoMod = "spc";
        thumbCorneNoMod = "del   tab   bspc  spc   ret   (caps-word 2000)";

        thumbs = isCorne: thumb: thumbCorne:
          if isCorne
          then thumbCorne
          else thumb;

        symbolsSetup = isCorne: ''
          (deflayer symbols ;;3-# 4-$ 6-^ 8-* 7-& \-| 5-% 1-! 2-@
                  S-3   S-8   S-[   S-]   S-2   +     7     8     9     S--
            grv   S-6   S-4   S-9   S-0   S-5   =     4     5     6     -     S-grv
                  S-7   S-\   [     ]     S-1   0     1     2     3     \
                         ${thumbs isCorne thumbNoOp thumbCorneNoOp}
          )

          (defalias
            spc (tap-hold $tap-time $hold-time spc (layer-while-held symbols))
          )
        '';

        auxSetup = isCorne: ''
          (deflayer aux
                  XX    XX    XX    XX    XX    XX    XX    XX    XX    XX
            XX    @m1   @m2   @m3   @m4   @m5   @m6   @m7   @m8   @m9   @m0   XX
                  XX    XX    XX    XX    XX    XX    XX    XX    XX    XX
                         ${thumbs isCorne thumbNoOp thumbCorneNoOp}
          )

          (defvar
            tap-dance-time 190
          )

          (defalias
            ' (tap-hold $tap-time $hold-time ' (layer-while-held aux))

            m1 (tap-dance $tap-dance-time (M-1 S-M-1 XX XX))
            m2 (tap-dance $tap-dance-time (M-2 S-M-2 XX XX))
            m3 (tap-dance $tap-dance-time (M-3 S-M-3 XX XX))
            m4 (tap-dance $tap-dance-time (M-4 S-M-4 XX XX))
            m5 (tap-dance $tap-dance-time (M-5 S-M-5 XX XX))
            m6 (tap-dance $tap-dance-time (M-6 S-M-6 XX XX))
            m7 (tap-dance $tap-dance-time (M-7 S-M-7 XX XX))
            m8 (tap-dance $tap-dance-time (M-8 S-M-8 XX XX))
            m9 (tap-dance $tap-dance-time (M-9 S-M-9 XX XX))
            m0 (tap-dance $tap-dance-time (M-0 S-M-0 XX XX))
          )
        '';

        unicodeSetup = isCorne: ''
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

            esc (tap-hold $tap-time $hold-time esc (layer-while-held unicodechars))
          )

          (deflayer unicodechars
                  XX    XX    XX    XX    XX    XX    @ue   @ii   @oe   XX
            XX    @ae   @sh   XX    lshft @gg   XX    rshft XX    XX    XX    XX
                  XX    XX    @ch   XX    @ss   XX    XX    XX    XX    XX
                         ${thumbs isCorne thumbNoOp thumbCorneNoOp}
          )
        '';

        homeRowSetup = isCorne: ''
          (defvar
            tap-time 190
            hold-time 190

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

          (deflayer nomods
                  q     w     e     r     t     y     u     i     o     p
            esc   a     s     d     f     g     h     j     k     l     ;     '
                  z     x     c     v     b     n     m     ,     .     /
                         ${thumbs isCorne thumbNoMod thumbCorneNoMod}

          )
        '';

        comboSetup = ''
          (defchords symbols 50
            (,    ) ,
            (  .  ) .
            (    /) /
            (, .  ) ;
            (  . /) :
          )

          (defalias
            ;;c, (chord symbols ,)
            ;;c. (chord symbols .)
            ;;c/ (chord symbols /)
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
              @esc  @a    @s    @d    @f    g     h     @j    @k    @l    @;    @'
                    z     x     c     v     b     n     m     ,     .     /
                                              @spc
            )

            ${symbolsSetup false}
            ${unicodeSetup false}
            ${auxSetup false}
            ${homeRowSetup false}
          '';
        };
        corne = {
          inherit extraDefCfg;

          devices = [
            "/dev/input/cornekbd"
          ];

          config = ''
            (defsrc
                    q     w     e     r     t     y     u     i     o     p
              esc   a     s     d     f     g     h     j     k     l     ;     '
                    z     x     c     v     b     n     m     ,     .     /
                                del   tab   bspc  spc   ret   lshft
            )

            (deflayer base
                    q     w     e     r     t     y     u     i     o     p
              @esc  @a    @s    @d    @f    g     h     @j    @k    @l    @;    @'
                    z     x     c     v     b     n     m     ,     .     /
                                del   @tab  @bspc @spc  ret   (caps-word 2000)
            )

            (deflayer navigation
                    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX
              XX    lmet  lalt  lctrl lshft XX    lft   down  up    rght  XX    XX
                    XX    XX    XX    XX    XX    home  pgdn  pgup  end   XX
                                XX    XX    XX    XX    XX    XX
            )

            (deflayer numbers
                    XX    XX    XX    XX    XX    XX    7     8     9     XX
              XX    lmet  lalt  lctrl lshft XX    XX    4     5     6     XX    XX
                    XX    XX    XX    XX    XX    0     1     2     3     XX
                                XX    XX    XX    XX    XX    XX
            )

            (defalias
              bspc (tap-hold $tap-time $hold-time bspc (layer-while-held navigation))
              tab (tap-hold $tap-time $hold-time tab (layer-while-held numbers))
            )

            ${symbolsSetup true}
            ${unicodeSetup true}
            ${auxSetup true}
            ${homeRowSetup true}
          '';
        };
      };
    };
  };
}
