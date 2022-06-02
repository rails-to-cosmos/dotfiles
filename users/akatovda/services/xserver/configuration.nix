{ config, lib, pkgs, ... }: {
  services.xserver = {
    enable = true;
    autorun = true;
    dpi = 96;
    layout = "us";
    xkbOptions = "ctrl:swapcaps";

    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
    libinput.touchpad.disableWhileTyping = true;

    wacom = {
      enable = true;
    };

    # desktopManager = {
    #   xfce.enable = false;
    #   xterm.enable = false;
    # };

    videoDrivers = [ "modesetting" ];
    useGlamor = true;

    displayManager = {
      lightdm = {
        enable = true;
        background = "/home/akatovda/Pictures/japan.jpg";
      };

      autoLogin = {
        enable = true;
        user = "akatovda";
      };

      sessionCommands = ''
        ${pkgs.xorg.xset}/bin/xset r rate 210 55
      '';
    };

    windowManager.session = pkgs.lib.singleton {
      name = "exwm";
      start = ''
      xcompmgr -c &
      ${pkgs.dbus.dbus-launch} --exit-with-session emacs -mm --fullscreen
      '';
    };
  };
}
