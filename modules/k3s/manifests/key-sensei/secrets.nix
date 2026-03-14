{ config, ... }:
{
  sops.secrets.key-sensei-jwt-secret = { };

  sops.templates.key-sensei-secret = {
    content = builtins.toJSON {
      apiVersion = "v1";
      kind = "Secret";
      metadata.name = "key-sensei-secret";
      metadata.namespace = "key-sensei";
      type = "Opaque";
      stringData.JWT_SECRET = config.sops.placeholder.key-sensei-jwt-secret;
    };
    path = "/var/lib/rancher/k3s/server/manifests/key-sensei-secret.json";
  };
}
