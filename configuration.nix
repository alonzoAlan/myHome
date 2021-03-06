# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, lib, pkgs, ... }:
with pkgs;
let
  my-python-packages = python-packages: with python-packages; [
    #pandas
    #requests
    numpy
    matplotlib
    # ipython
    mysql-connector
    jupyter
    notebook
    faker
    # jupyter_core
    # other python packages you want
  ]; 
  python-with-my-packages = python3.withPackages my-python-packages;
in 
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
     # <home-manager/nixos> 
    ];

  # Allow all the things

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.0.2u"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.hostName = "cosmos"; # Define your hostname.
  networking.wireless = {
               enable = true;  # Enables wireless support via wpa_supplicant.
	             networks.Varikuti.pskRaw = "2f5385967f945b489e113af64fb060b86319cf195898249a8cd0189e63078cbd";
        # };
       userControlled.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };
       # bluetooth
   hardware.bluetooth = {
       enable = true;
       powerOnBoot = true;
       extraConfig = ''
                 [General]
                Enable=Source,Sink,Media,Socket
                '';
   };
  fonts.fonts = with pkgs; [
    pkgs.google-fonts
    # pkgs.input-fonts
    pkgs.vistafonts
    pkgs.font-awesome
    pkgs.hack-font
    pkgs.monoid
		 pkgs.powerline-fonts
    (nerdfonts.override { fonts = [  "VictorMono" "SourceCodePro" "Mononoki" ]; })
		pkgs.ubuntu_font_family
		pkgs.emacs-all-the-icons-fonts
    pkgs.iosevka
  ];
  # nixpkgs.config.allowBroken = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  services.xserver =
    {
      enable = true;
      # Configure keymap in X11
      layout = "us";
      # xkbOptions = "eurosign:e";
      xkbOptions = "caps:swapescape";
      libinput= {
        enable = true;
        naturalScrolling = true;      # Enable touchpad support (enabled default in most desktopManager).
		    additionalOptions = ''
                                                                      Option "AccelSpeed" "1.0"        # Mouse sensivity
                                                                      Option "TapButton2" "0"          # Disable two finger tap
                                                                      Option "VertScroll Delta" "-180"  # scroll sensitivity
                                                                      Option "HorizScroll Delta" "-180"
                                                                      Option "FingerLow" "40"          # when finger pressure drops below this value, the driver counts it as a release.
                                                                      Option "FingerHigh" "70"
                                                                      '';
		  };
        displayManager = {
			  defaultSession = "none+xmonad";
		       	autoLogin.enable = true;
           		autoLogin.user = "vamshi";
			   };
/*
          lightdm = {
            enable = true;
            greeter.enable = false;
                     };
        };
  
     displayManager.lightdm.greeters.enso = {
                                                enable = true;
                                            };
   displayManager = {
                        defaultSession = "none+xmonad";
			#lightdm.autologin = {enable = true; user = "vamshi";};
                        lightdm.greeters.mini = {
                        enable = true;
                        user = "vamshi";
                        extraConfig = ''
                                [greeter]
                                show-password-label = false
                                [greeter-theme]
                                background-image = ""
                                '';
                        };
                }; */
      # desktopManager.cinnamon.enable = true;
      desktopManager.wallpaper.mode = "scale";
       windowManager.xmonad = {
                               enable = true;
		        };
		       # enableContribAndExtras = true;
			      /*
		 #       extraPackages =  haskellPackages: [
		 #                          haskellPackages.xmonad-wallpaper
		 #  		 ]; */
      #  windowManager.awesome = {
      #    enable = true;
      #    luaModules = with pkgs.luaPackages; [
      #   luarocks # is the package manager for Lua modules
      #   # luadbi-mysql # Database abstraction layer
      # ];
      #  };
  };

   xdg.portal.enable = true;
   services.flatpak.enable = true;

  # Enable the GNOME 3 Desktop Environment.
  # services.xserver.enable = true;
 # services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # services.xserver.desktopManager.pantheon.enable = true;
  # services.pantheon.apps.enable = false;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  #services.emacs.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vamshi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };
      # Security and networking
  security.sudo.wheelNeedsPassword = false;

  #home-manager.users.vamshi = { pkgs, ... }: {
  #  home.packages = [ pkgs.atool pkgs.httpie ];
  #  programs.bash.enable = true;
  #};
  #home-manager.useUserPackages = true;
  #home-manager.useGlobalPkgs = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  # # Enable UPower, which is used by taffybar.
  services.upower.enable = true;
  systemd.services.upower.enable = true;
  sound.enable = true;
  services.blueman.enable = true;
  # nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio = {
               enable = true;
               extraModules = [ pkgs.pulseaudio-modules-bt ];
               package = pkgs.pulseaudioFull;
               support32Bit = true; # Steam
               # extraConfig = ''7
               # load-module module-bluetooth-policy auto_switch=2
	             # load-module module-switch-on-connect
	             # load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
               #   '';
  };
# Music daemon, can be accessed through mpc or an other client
   services.mpd = {
         enable = true;
         extraConfig = ''
         audio_output {
         type "pulse" # MPD must use Pulseaudio
         name "Pulseaudio" # Whatever you want
         server "127.0.0.1" # MPD must connect to the local sound server
           }
       '';
    };

  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;
  services.longview.mysqlPasswordFile = "/run/keys/mysql.password";

# nixpkgs.config = {

# packageOverrides = pkgs: rec{

# dmenu = pkgs.dmenu.override {

#   patches = [ ./dmenu-patches/gruvbox.diff
#               ./dmenu-patches/grid.diff
#               ./dmenu-patches/lineheight.diff
#               # ./dmenu-patches/center.diff
#               # ./dmenu-patches/dynamicdmenu.diff
#               # ./dmenu-patches/listfullwidth.diff
#               # ./dmenu-patches/gridnav.diff
#               # ./dmenu-patches/mouseSupport.diff
#               # ./dmenu-patches/noSort.diff
#               # ./dmenu-patches/xyw.diff
#             ];

# };
# };
# };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # keyboard
    xorg.xkbcomp
    xorg.xmodmap
    #internet
    wget 
    #wallpaper setter
    feh
    # image viewer
    sxiv
    #audio
    acpi
    #run prompt
    # dmenu
    # kdenlive
    kdenlive
    libsForQt5.kdenlive
    libsForQt512.kdenlive
    libsForQt514.kdenlive
    #music
    spotify
    #appearence
    lxappearance
    hicolor-icon-theme
    dracula-theme
    # utilities
    #pulsemixer
    htop
    unzip
    okular
    wmctrl
    neofetch
    playerctl
    brightnessctl
    # packages for lang
    python-with-my-packages
    (emacsWithPackages (epkgs: with emacsPackages; [
       pdf-tools
     ]))
 (haskellPackages.ghcWithPackages (ps: with ps; [
       pandoc-citeproc
       shake         # Build tool
       hlint         # Required for spacemacs haskell-mode
       apply-refact  # Required for spacemacs haskell-mode
       hasktags      # Required for spacemacs haskell-mode
       hoogle        # Required for spacemacs haskell-mode
       lucid
       network
       # stylish-haskell # Required for spacemacs haskell-mode
       # ^ marked as broken
       turtle        # Scripting
       regex-compat
       #PyF
       HandsomeSoup
       tokenize
       # chatter
     ]))
  #   ((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [
  #  # epkgs.vterm
	# 	      epkgs.evil
	# 	      epkgs.nord-theme

  # ]))
    neovim
    # lang
    # c compiler
    gcc
    #ocaml
    ocaml
    #ocaml
    # racket
    racket
    #clojure
    clojure
    clojure-lsp
    leiningen
    # Haskell
    cabal-install
    cabal2nix
    ghc
    haskellPackages.xmobar
    haskellPackages.ghcid
    haskellPackages.ghcide
    haskellPackages.Cabal_3_2_1_0
    # taffybar
    # haskellPackages.imalison-taffybar
    # # notifications-tray-icon
    # haskellPackages.status-notifier-item
    # haskellPackages.dbus-hslogger
    #haskellPackages.hlint
   # haskellPackages.hoogle
   # haskellPackages.random_1_2_0
    # JavaScript
   # nodejs
    # Hypertext Preprocessor
    php
    #ruby
    ruby
    #tcl
    tcl
    xdotool
    #unknown
    miraclecast
    libnotify
    moc
  ];

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
