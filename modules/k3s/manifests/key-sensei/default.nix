{
  imports = [
    ./secrets.nix
  ];

  services.k3s.manifests = {
    key-sensei-namespace = {
      enable = true;
      source = ./00-namespace.yaml;
    };
    key-sensei-configmap = {
      enable = true;
      source = ./01-configmap.yaml;
    };
    key-sensei-mongodb = {
      enable = true;
      source = ./03-mongodb-statefulset.yaml;
    };
    key-sensei-server = {
      enable = true;
      source = ./04-server-deployment.yaml;
    };
    key-sensei-server-service = {
      enable = true;
      source = ./05-server-service.yaml;
    };
    key-sensei-client = {
      enable = true;
      source = ./06-client-deployment.yaml;
    };
    key-sensei-client-service = {
      enable = true;
      source = ./07-client-service.yaml;
    };
    key-sensei-ingress = {
      enable = true;
      source = ./08-ingress.yaml;
    };
  };
}
