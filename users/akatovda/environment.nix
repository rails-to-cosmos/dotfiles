{ config, pkgs, ... }:

{
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
