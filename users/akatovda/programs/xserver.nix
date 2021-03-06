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
    libinput.mouse.naturalScrolling = true;

    wacom = {
      enable = true;
    };

    videoDrivers = [
      # "nouveau"
      # "intel"
      # "modesetting"
      "nvidia"
    ];

    useGlamor = true;

    screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';

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
        xcompmgr -c &
        ${pkgs.xorg.xset}/bin/xset r rate 210 55
      '';
    };

    windowManager.session = pkgs.lib.singleton {
      name = "exwm";
      start = ''
      ${pkgs.dbus.dbus-launch} --exit-with-session emacs -mm --fullscreen
      '';
    };

  };
}
