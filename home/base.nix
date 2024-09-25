{ config, ... }:

{
  programs.bash.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;
  programs.eza.enable = true;

  programs.git = {
    enable = true;
    userName = "Nathan D. Chane";
    userEmail = "NathanDawit555@gmail.com";
    extraConfig = {
      user.signingKey = "~/.ssh/id_rsa";
      core = { editor = config.home.sessionVariables.EDITOR; };
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "~/.config/git/allowed_signers";
      };
      commit = { gpgsign = true; };
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        offset = "16x32";
        origin = "top-right";
        frame_color = "#9f9f9f";
        frame_width = 1;
        font = "JetBrains Mono 9";
      };

      urgency_normal = {
        background = "#000000";
        foreground = "#ffffff";
        timeout = 10;
      };
    };
  };

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
  };

  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + o; {e,f,t,v,k}" = ''
        {emacs,firefox,telegram-desktop,pwvucontrol,krita}
      '';

      "super + s; {q,r,s}" = ''
        {bspc quit, bspc wm -r, pkill -USR1 -x sxhkd}
      '';

      "super + alt + {q,r}" = ''
        bspc {quit,wm -r}
      '';

      "super + {n,p}" = ''
        bspc node -f {next,prev}.local.!hidden.window
      '';

      "super + Tab" = ''
        bspc desktop -f last
      '';

      "super + {_, shift +}{1-5}" = ''
        bspc {desktop -f, node -d} '^{1-5}' --follow
      '';

      "super + q" = ''
        bspc node -c
      '';

      "super + f" = ''
        bspc node -t ~fullscreen
      '';

      "super + y" = ''
        flameshot gui
      '';

      "super + space" = ''
        rofi -show run
      '';

    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/misc/desktop";
    download = "${config.home.homeDirectory}/misc/downloads";
    documents = "${config.home.homeDirectory}/misc/documents";
    music = "${config.home.homeDirectory}/misc/music";
    pictures = "${config.home.homeDirectory}/misc/pictures";
    publicShare = "${config.home.homeDirectory}/misc/public";
    templates = "${config.home.homeDirectory}/misc/templates";
    videos = "${config.home.homeDirectory}/misc/videos";
  };

  services.picom = {
    enable = true;
    vSync = true;
  };

  home.sessionVariables = {
    CARGO_HOME = "${config.home.homeDirectory}/misc/dirt/cargo";
    RUSTUP_HOME = "${config.home.homeDirectory}/misc/dirt/rustup";
    EDITOR = "emacs";
  };
  home.stateVersion = "24.05";
}
