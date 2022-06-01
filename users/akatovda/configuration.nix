{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";

  switch-layout = pkgs.writeShellScriptBin "switch-layout"
    (builtins.readFile ./programs/switch-layout.sh);

  brightness = pkgs.writeShellScriptBin "brightness"
    (builtins.readFile ./programs/brightness.sh);

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
    extraGroups = ["wheel" "networkmanager" "disk" "audio" "sound" "video" "systemd-journal" "input" "tty"];
    createHome = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/bash";
  };

  home-manager.users.akatovda = ({ config, ... }: {
    imports = [
      ./programs/emacs/configuration.nix
      ./programs/rofi/configuration.nix
      ./programs/git/configuration.nix
      ./programs/xmonad/configuration.nix
      ./programs/xmobar/configuration.nix
      ./services/syncthing/configuration.nix
      ./services/gpg-agent/configuration.nix
    ];

    /* Here goes your home-manager config, eg home.packages = [ pkgs.foo ]; */
    home.packages = with pkgs; [
      switch-layout
      brightness
      grafana
      fail2ban
      cask
      docker
      firefox
      git
      htop
      minikube
      nyxt
      python3
      syncthing
      tdesktop
      transmission
      virtualbox
      vlc
      xournalpp
      youtube-dl
      terminator
    ];
  });
}
