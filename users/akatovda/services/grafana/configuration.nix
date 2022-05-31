{ config, pkgs, ... }: {
  services.grafana = {
    enable = true;
    port = 2342;
    domain = "localhost";
    addr = "127.0.0.1";
  };
}
