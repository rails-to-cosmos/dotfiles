{ pkgs, ... }: {
  home.packages = with pkgs; [
    haskellPackages.xmonad
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
  ];

  home.file.".xmonad/xmonad.hs".source = ./xmonad.hs;
}
