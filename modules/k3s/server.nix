{
  imports = [
    ./charts.nix
    # ./manifests
  ];
  services.k3s = {
    role =
      # By default it also runs workloads as an agent.
      "server";
  };
}
