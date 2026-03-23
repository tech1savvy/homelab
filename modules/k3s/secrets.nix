{ config, ... }:
{
  sops.secrets.alertmanager-smtp-password = { };

  sops.templates.alertmanager-smtp-secret = {
    content = builtins.toJSON {
      apiVersion = "v1";
      kind = "Secret";
      metadata.name = "alertmanager-smtp";
      metadata.namespace = "monitoring";
      type = "Opaque";
      stringData.password = config.sops.placeholder.alertmanager-smtp-password;
    };
    path = "/var/lib/rancher/k3s/server/manifests/alertmanager-smtp-secret.json";
  };
}
