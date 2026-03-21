{
  imports = [
    ./charts.nix
    ./manifests
  ];
  services.k3s = {
    nodeName = "lab";
    role =
      # By default it also runs workloads as an agent.
      "server";
    extraFlags = [ "--tls-san=lab.tech1savvy.me" ];
  };
}
