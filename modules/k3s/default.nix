{ config, ... }:
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

    secrets.key-sensei-jwt-secret = { };

    templates.key-sensei-secret = {
      content = builtins.toJSON {
        apiVersion = "v1";
        kind = "Secret";
        metadata.name = "key-sensei-secret";
        metadata.namespace = "key-sensei";
        type = "Opaque";
        stringData.JWT_SECRET = config.sops.placeholder.key-sensei-jwt-secret;
      };
      path = "/var/lib/rancher/k3s/server/manifests.d/key-sensei-secret.json";
    };
  };
}
