{ config, pkgs, ... }:

{
  xresources.properties = {
    # Set some Emacs GUI properties in the .Xresources file because they are
    # expensive to set during initialization in Emacs lisp. This saves about
    # half a second on startup time. See the following link for more options:
    # https://www.gnu.org/software/emacs/manual/html_node/emacs/Fonts.html#Fonts
    "Emacs.menuBar" = false;
    "Emacs.toolBar" = false;
    "Emacs.verticalScrollBars" = false;
    "Emacs.Font" = "-JB-JetBrains Mono NL-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1";
  };

  programs.emacs = {
    enable = true;

    extraPackages = epkgs: with epkgs; [
      # Delegate package management to Emacs
      use-package
    ];
  };
}
