{ config, pkgs, ... }:

{

  imports =
    [
      ./users/akatovda/configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
    networkmanager.enable = true;

    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # wireless.userControlled.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:
  services.openssh.enable = true;  # Enable the OpenSSH daemon.
  services.netdata.enable = true;
  services.netdata.config = {
    global = {
      "memory mode" = "dbengine";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cask
    docker
    fail2ban
    feh
    gcc
    ghc
    git
    gnumake
    gotop
    grafana
    haskell.compiler.ghcjs
    haskellPackages.cabal-install
    haskellPackages.font-awesome-type
    haskellPackages.haskell-language-server
    haskellPackages.hoogle
    haskellPackages.stack
    htop
    htop
    jre8
    kompose
    kubectl
    kubernetes
    kubernetes-helm
    minikube
    nix-top
    pciutils
    python3
    ripgrep
    terraform
    virtualbox
    wget
    wirelesstools
    xcompmgr
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXext
    xorg.libXft
    xorg.libXpm
    xorg.libXrandr
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  # Enable the X11 windowing system.

  # hardware = {
  #   nvidia = {
  #     modesetting = {
  #       enable = true;
  #     };

  #     optimus_prime = {
  #       enable = true;
  #       # values are from lspci
  #       # try lspci | grep -P 'VGA|3D'
  #       intelBusId = "PCI:0:2:0";
  #       nvidiaBusId = "PCI:1:0:0";
  #     };
  #   };
  # }
  # ;
}
