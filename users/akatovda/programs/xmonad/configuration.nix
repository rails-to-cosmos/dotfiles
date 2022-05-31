{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    haskellPackages.xmonad
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
  ];
}
