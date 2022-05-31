{ config, pkgs, ... }: {
  fonts = {
    fontconfig.enable = true;
    fontconfig.hinting.autohint = true;
    fontconfig.antialias = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      fira
      fira-code
      fira-mono
      font-awesome
      ibm-plex
      nerdfonts
      opensans-ttf
      overpass
      roboto
      source-code-pro
      terminus_font_ttf
      ubuntu_font_family
      fantasque-sans-mono
      fira-code-symbols
      material-design-icons
      material-icons
      jetbrains-mono
    ];
  };
}
