{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
  switch-layout = pkgs.writeShellScriptBin "switch-layout" (builtins.readFile ./programs/switch-layout.sh);
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" (builtins.readFile ./programs/nvidia-offload.sh);
in
{
  imports = [
    (import "${home-manager}/nixos")
    ./environment.nix
    ./fonts.nix
    ./programs/xserver.nix
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

  sound.enable = true;

  home-manager.users.akatovda = ({ config, ... }: {
    imports = [
      ./programs/emacs.nix
      ./programs/rofi/configuration.nix
      ./programs/git.nix
      ./programs/syncthing.nix
      ./programs/gpg-agent.nix
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
      nyxt
      switch-layout
      nvidia-offload
      syncthing
      tdesktop
      terminator
      transmission
      vlc
      xournalpp
      youtube-dl
      steam
      steam-run-native
      pamixer
      redshift
      brightnessctl
      wineWowPackages.stable

      (let
        my-python-packages = python-packages: with python-packages; [
          bandit
          dash
          pandas
          pep8
          pip
          plotly
          pylint
          requests
          virtualenv
        ];
        python-with-my-packages = python3.withPackages my-python-packages;
      in
        python-with-my-packages)
    ];
  });
}
