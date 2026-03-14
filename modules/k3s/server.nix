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
  };
}
