{ config, pkgs, ... }: {
  services.syncthing = {
    enable = false;
  };
}
