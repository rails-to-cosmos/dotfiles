{ config, pkgs, ... }: {
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

    desktopManager = {
      xterm.enable = false;
      xfce.enable = false;
    };

    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };

    videoDrivers = [ "modesetting" ];
    useGlamor = true;

    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "akatovda";
    displayManager.defaultSession = "none+xmonad";
    displayManager.sessionCommands = ''
        ${pkgs.xorg.xset}/bin/xset r rate 210 55
    '';
  };
}
