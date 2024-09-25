{ lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.config = { allowUnfree = true; };

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 30;

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lappy";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

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

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "colemak";
    xkb.options = "ctrl:swapcaps";
    displayManager.lightdm = {
      background = /home/nate/misc/pictures/basquiat-wall.png;
      enable = true;
    };
    windowManager.bspwm.enable = true;

    autoRepeatDelay = 250;
    autoRepeatInterval = 30;

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
    extraGroups = [ "wheel" "networkmanager" "video" "netdev" ];
    packages = [
      pkgs.firefox
      pkgs.telegram-desktop

      pkgs.tree-sitter
      pkgs.tree-sitter-grammars.tree-sitter-rust
      pkgs.gcc

      pkgs.nixfmt-classic
      pkgs.nixd

      pkgs.krita
      pkgs.rnote

      pkgs.imagemagick

      pkgs.unzip
      pkgs.mupdf

      pkgs.opentabletdriver

      pkgs.sxiv
      pkgs.feh
      pkgs.gimp

      pkgs.ffmpeg

      pkgs.rofi
      pkgs.ghc
      pkgs.arandr

      pkgs.reaper

      (pkgs.callPackage ../pkgs/gauth.nix { })
    ];
  };

  environment.systemPackages = with pkgs; [
    emacs
    light
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

