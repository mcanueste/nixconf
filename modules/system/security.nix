{
  lib,
  config,
  ...
}: {
  options.nixconf.system.security = {
    certs = lib.mkOption {
      default = [];
      description = "Self-signed CA Cert paths";
      type = lib.types.listOf lib.types.path;
    };

    openssh = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable openssh for remote connections to host";
    };

    sshd = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable sshd for remote connections to host";
    };

    sftp = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable openssh SFTP for remote connections to host";
    };

    gvfs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Gnome Virtual FS for mounting remote resources (i.e. phones)";
    };
  };

  config = {
    security = {
      # control system wide priviledges without sudo
      polkit.enable = true;

      # setup self-signed CA cert files if any
      pki.certificateFiles = config.nixconf.system.security.certs;

      # Whether to enable the RealtimeKit system service, which hands
      # out realtime scheduling priority to user processes on
      # demand. For example, the PulseAudio server uses this to
      # acquire realtime priority.
      rtkit.enable = true;
    };

    # Some programs need SUID wrappers, can be configured further
    # or are started in user sessions.
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Enable the OpenSSH daemon.
    services = {
      openssh = {
        enable = config.nixconf.system.security.openssh;

        # require public key authentication for better security
        settings.PasswordAuthentication = false;
        settings.KbdInteractiveAuthentication = false;
        #settings.PermitRootLogin = "yes";

        allowSFTP = config.nixconf.system.security.sftp;
      };

      # SSH daemon.
      sshd.enable = config.nixconf.system.security.sshd;

      # Mount MTP devices (iPhone, Android, etc.)
      # Seamlessly access files and folders on remote resources.
      # Necessarry for file managers, mounts, trash, etc.
      gvfs.enable = config.nixconf.system.security.gvfs;
    };
  };
}
