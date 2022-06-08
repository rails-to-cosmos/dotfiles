{ config, pkgs, ... }:

{
  home.file.".emacs.d/init.el".source = ./emacs.d/init.el;
  home.file.".emacs.d/packages".source = ./emacs.d/packages;
  home.file.".emacs.d/lisp".source = ./emacs.d/lisp;
  home.file.".emacs.d/snippets".source = ./emacs.d/snippets;

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
      a
      aes
      aio
      all-the-icons
      anaconda-mode
      auto-virtualenvwrapper
      bind-key
      cask
      cask-mode
      cider
      clojure-mode
      company
      company-anaconda
      company-nixos-options
      company-quickhelp
      company-statistics
      consult
      danneskjold-theme
      dante
      default-text-scale
      diminish
      dired-narrow
      dired-rainbow
      docker
      dockerfile-mode
      elfeed
      eshell-prompt-extras
      exec-path-from-shell
      expand-region
      exwm
      f
      feature-mode
      firestarter
      flycheck
      flycheck-indicator
      flycheck-pycheckers
      font-utils
      haskell-mode
      highlight
      jupyter
      kubel
      load-relative
      magit
      marginalia
      multiple-cursors
      nix-mode
      orderless
      paredit
      paredit-everywhere
      projectile
      promise
      pyvenv
      queue
      rainbow-delimiters
      rainbow-mode
      restart-emacs
      reverse-im
      rg
      ripgrep
      slime
      smartparens
      sudo-edit
      ts
      ucs-utils
      undo-tree
      unicode-fonts
      vertico
      virtualenvwrapper
      wallpaper
      wgrep
      whitespace-cleanup-mode

      suggest
      ctable

      yasnippet
      calfw
      calfw-org
      calfw-ical

      navigel
    ];
  };
}
