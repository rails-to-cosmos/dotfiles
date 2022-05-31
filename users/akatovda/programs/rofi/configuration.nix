{ config, pkgs, ... }: {
  home.file.".local/share/rofi/themes/dracula.rasi".source = ./themes/dracula.rasi;

  programs.rofi = {
    enable = true;
    theme = "dracula";

    extraConfig = {
      modi = "combi";
      combi-modi = "window,drun";
      lines = 5;
      width = 60;
      location = 2;
      show-icons = true;
      display-drun = "";
      display-window = "";
      drun-display-format = "{name} {generic}";
      window-format = "Switch to {c} {t}";
      window-match-fields = "class";
      drun-match-fields = "name";
    };
  };

}
