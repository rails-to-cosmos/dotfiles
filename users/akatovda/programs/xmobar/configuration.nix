{ pkgs, ... }: {
  nixpkgs.config.xmobar.enableXft = true;

  nixpkgs.config.haskellPackageOverrides = self: super: with pkgs.haskell.lib; {
    xmobar = (overrideCabal super.xmobar (drv: {
      # Skip -fwith_datezone
      configureFlags = [ "-fwith_xft" "-fwith_utf8" "-fwith_inotify"
                         "-fwith_iwlib" "-fwith_mpd" "-fwith_alsa"
                         "-fwith_mpris" "-fwith_dbus" "-fwith_xpm" ];
    })).override {
      timezone-series = null;
      timezone-olson = null;
    };
  };

  environment.systemPackages = with pkgs; [
    haskellPackages.xmobar
  ];
}
