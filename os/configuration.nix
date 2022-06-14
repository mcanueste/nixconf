# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  # home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      
      # Import home manager
      (import "${home-manager}/nixos")

      # Import virtualisation config
      ./virtualisation.nix

      # Import packages configuration
      ./packages.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.utf8";
    LC_IDENTIFICATION = "de_DE.utf8";
    LC_MEASUREMENT = "de_DE.utf8";
    LC_MONETARY = "de_DE.utf8";
    LC_NAME = "de_DE.utf8";
    LC_NUMERIC = "de_DE.utf8";
    LC_PAPER = "de_DE.utf8";
    LC_TELEPHONE = "de_DE.utf8";
    LC_TIME = "de_DE.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mcst = {
    isNormalUser = true;
    description = "mcst";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # home manager configs
  home-manager.users.mcst = {
    home.packages = with pkgs; [ 
      fish
      starship
    ];
    programs.bash = {
      enable = true;
      historySize = 500000;
      historyFileSize = 100000;
      historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
      historyIgnore = [ "exit" "ls" "bg" "fg" "history" "clear" ];
      shellOptions = [
        # Append to history file rather than replacing it.
        "histappend"

        # Save multi-line commands as one command 
	"cmdhist"

        # check the window size after each command and, if
        # necessary, update the values of LINES and COLUMNS.
        "checkwinsize"

        # Extended globbing.
        "extglob"
        
	# Turn on recursive globbing (enables ** to recurse all directories)
        "globstar"

	# Case-insensitive globbing (used in pathname expansion)
	"nocaseglob"

        # Warn if closing shell with running jobs.
        "checkjobs"

        # Prepend cd to directory names automatically
        "autocd"

	# Correct spelling errors during tab-completion
	"dirspell"

	# Correct spelling errors in arguments supplied to cd
	"cdspell"

	# This allows you to bookmark your favorite places across the file system
	# Define a variable containing a path and you will be able to cd into it 
	# regardless of the directory you're in
	"cdable_vars"
	
	# Examples:
	# export dotfiles="$HOME/dotfiles"
	# export projects="$HOME/projects"
	# export documents="$HOME/Documents"
	# export dropbox="$HOME/Dropbox"` 
      ];
      initExtra = ''
        # Prevent file overwrite on stdout redirection
        # Use `>|` to force redirection to an existing file
        set -o noclobber
        
        # Enable history expansion with space
        # E.g. typing !!<space> will replace the !! with your last command
        bind Space:magic-space
        
        ## SMARTER TAB-COMPLETION (Readline bindings) ##
        
        # Perform file completion in a case insensitive fashion
        bind "set completion-ignore-case on"
        
        # Treat hyphens and underscores as equivalent
        bind "set completion-map-case on"
        
        # Display matches for ambiguous patterns at first tab press
        bind "set show-all-if-ambiguous on"
        
        # Immediately add a trailing slash when autocompleting symlinks to directories
        bind "set mark-symlinked-directories on"
        
        # Enable incremental history search with up/down arrows (also Readline goodness)
        # Learn more about this here: 
        # http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'
        bind '"\e[C": forward-char'
        bind '"\e[D": backward-char'
      '';
      sessionVariables = {
      	# Automatically trim long paths in the prompt (requires Bash 4.x)
        PROMPT_DIRTRIM = 2; 

	# Record each line as it gets issued
	PROMPT_COMMAND = "history -a";

	# Use standard ISO 8601 timestamp
	# %F equivalent to %Y-%m-%d
	# %T equivalent to %H:%M:%S (24-hours format)
	HISTTIMEFORMAT = "%F %T ";

	# This defines where cd looks for targets
	# Add the directories you want to have fast access to, separated by colon
	# Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, 
	# in home and in the ~/projects folder
	CDPATH = ".:~/Projects";
      };
    };
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "mcanueste";
      userEmail = "mcanueste@gmail.com";
    };
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
