{ config, pkgs, ... }:

{
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  environment.interactiveShellInit = ''
    alias tf='terraform'
    alias k='kubectl'
    alias mk='minikube'
  '';
}
