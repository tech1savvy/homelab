{
  imports = [
    ./networking.nix
    ./charts.nix

    # Include only one
    ./server.nix
    # ./agent.nix
  ];
  services.k3s = {
    enable = true;
  };
}
