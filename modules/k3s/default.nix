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

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "key-sensei-secret" = {
        format = "yaml";
        path = "/var/lib/rancher/k3s/server/manifests.d/key-sensei-secret.yaml";
      };
    };
  };
}
