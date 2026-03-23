{
  imports = [
    ./networking.nix
    ./charts.nix
    ./secrets.nix

    # Include only one
    ./server.nix
    # ./agent.nix
  ];
  services.k3s = {
    enable = true;
  };
}
