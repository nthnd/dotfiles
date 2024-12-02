{ lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.config = { allowUnfree = true; };

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 30;

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lappy";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-+" ];
  networking.nat.externalInterface = "eth0";
  networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    autoPrune.dates = "monthly";
  };

  time.timeZone = "Africa/Nairobi";
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-ocl
    intel-vaapi-driver
  ];

  hardware.usb-modeswitch.enable = true;
  hardware.bluetooth.enable = true;
  hardware.opentabletdriver.enable = true;

  programs.light = { enable = true; };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "colemak";
      options = "caps:capslock";
    };

    displayManager.lightdm = {
      background = ../assets/wallpapers/basquiat-wall.png;
      enable = true;
    };
    windowManager.bspwm.enable = true;

    autoRepeatDelay = 250;
    autoRepeatInterval = 30;

  };

  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    udevmonConfig = ''
      - JOB: ${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE
        DEVICE:
          EVENTS:
          EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };
  services.unclutter-xfixes = { enable = true; };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput = let
  in {
    enable = true;
    touchpad = {
      accelProfile = "flat";
      naturalScrolling = true;
    };
    mouse = {
      accelProfile = "flat";
      naturalScrolling = false;
    };
  };

  services.fstrim.enable = lib.mkDefault true;

  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "never";
      };
    };
  };

  users.mutableUsers = true;
  users.users.nate = {
    isNormalUser = true;
    initialPassword = "nate";
    extraGroups = [ "wheel" "networkmanager" "video" "netdev" "docker" ];
    packages = [
      pkgs.firefox
      pkgs.telegram-desktop

      pkgs.gcc

      pkgs.nixfmt-classic
      pkgs.nixd

      pkgs.krita
      pkgs.rnote

      pkgs.imagemagick

      pkgs.unzip
      pkgs.mupdf

      pkgs.pandoc
      #      pkgs.texlive

      pkgs.opentabletdriver

      pkgs.sxiv
      pkgs.feh
      pkgs.gimp

      pkgs.ffmpeg

      pkgs.rofi
      pkgs.ghc
      pkgs.arandr

      pkgs.rtorrent

      pkgs.reaper

      pkgs.vlc

      pkgs.k3d
      pkgs.kubectl
      pkgs.kubernetes-helm
      pkgs.kubernetes-helmPlugins.helm-diff
      pkgs.helmfile-wrapped

      pkgs.babashka-unwrapped # without rlwrap

      pkgs.ispell

      pkgs.inetutils

      pkgs.jq
      pkgs.xh

      (pkgs.callPackage ../pkgs/gauth.nix { })
    ];
  };

  environment.systemPackages = with pkgs; [
    emacs
    curl
    ripgrep
    fd
    pwvucontrol
    usbutils
    acpi
  ];

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "emacs.desktop";
      "image/png" = "sxiv.desktop";
    };
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    terminus-nerdfont
    fantasque-sans-mono
    google-fonts
    libre-baskerville
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  documentation = {
    enable = true;
    man.enable = true;
    info.enable = true;
    nixos.enable = true;
  };

  system.stateVersion = "24.05";
}

