{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Dmitry Akatov";
    userEmail = "akatovda@gmail.com";
  };
}
