{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";

  switch-layout = pkgs.writeShellScriptBin "switch-layout" (builtins.readFile ./programs/switch-layout.sh);
  brightness = pkgs.writeShellScriptBin "brightness" (builtins.readFile ./programs/brightness.sh);

in

{
  imports = [
    (import "${home-manager}/nixos")
    ./environment.nix
    ./fonts.nix
    ./services/xserver/configuration.nix
    ./services/grafana/configuration.nix
  ];

  users.users.akatovda = {
    isNormalUser = true;
    home = "/home/akatovda";
    description = "Dmitry Akatov";
    extraGroups = [
      "audio"
      "disk"
      "docker"
      "input"
      "networkmanager"
      "sound"
      "systemd-journal"
      "tty"
      "video"
      "wheel"
    ];
    createHome = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/bash";
  };

  nixpkgs.config.allowUnfree = true;

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.nvidia.prime.offload.enable = true;
  hardware.nvidia.prime = {
    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "00:02.0";
    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "01:00.0";
  };

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.addNetworkInterface = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;
  virtualisation.docker.extraOptions = "--default-runtime=nvidia";

  home-manager.users.akatovda = ({ config, ... }: {
    imports = [
      ./programs/emacs/configuration.nix
      ./programs/rofi/configuration.nix
      ./programs/git/configuration.nix
      ./services/syncthing/configuration.nix
      ./services/gpg-agent/configuration.nix
    ];

    services.mpris-proxy.enable = true;

    programs.firefox = {
      enable = true;
      # profiles = {
      #   home = {
      #     id = 0;
      #     name = "rails-to-cosmos";
      #     settings = {
      #       "mousewheel.default.delta_multiplier_y" = "-100";
      #     };
      #   };
      # };
    };

    /* Here goes your home-manager config, eg home.packages = [ pkgs.foo ]; */
    home.packages = with pkgs; [
      pavucontrol
      brightness
      cask
      docker
      fail2ban
      git
      grafana
      htop
      kompose
      kubectl
      kubernetes
      minikube
      nyxt
      python3
      switch-layout
      syncthing
      tdesktop
      terminator
      transmission
      virtualbox
      vlc
      xournalpp
      youtube-dl
      pciutils
      jq
    ];
  });
}
