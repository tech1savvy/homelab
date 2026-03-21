{
  services.k3s = {
    autoDeployCharts = {
      # Cert Manager
      "cert-manager" = {
        enable = false;
        name = "cert-manager";
        repo = "https://charts.jetstack.io";
        version = "v1.19.4";
        hash = "sha256-0MIC9XuGU+uVf7Wy+UcsGxHPa1Gsxcd35Lgk97Wp6oc=";
        targetNamespace = "cert-manager";
        createNamespace = true;

        values = {
          crds.enabled = true;
        };
      };
      # Rancher
      "rancher" = {
        enable = false;
        name = "rancher";
        repo = "https://releases.rancher.com/server-charts/stable";
        version = "v2.13.3";
        hash = "sha256-6fLKUiAZaI/dH8ePwQt8IMspX+4lFju8Y2nnv7inQvc=";
        targetNamespace = "cattle-system";
        createNamespace = true;

        values = {
          hostname = "rancher.tech1savvy.me";
        };
      };
      # Monitoring
      "kube-prometheus-stack" = {
        enable = true;
        name = "kube-prometheus-stack";
        repo = "https://prometheus-community.github.io/helm-charts";
        version = "82.4.3";
        hash = "sha256-YtL8OB7tpPsruOYxBNXMHRkqPqpT59DMQ/o9qXv9sLk=";
        targetNamespace = "monitoring";
        createNamespace = true;

        values = {
          prometheus.prometheusSpec = {
            scrapeInterval = "90s";
            scrapeTimeout = "15s";
            evaluationInterval = "90s";
            retention = "12h";
            retentionSize = "3GiB";
            resources = {
              requests.memory = "256Mi";
              limits.memory = "512Mi";
            };
          };
          alertmanager.alertmanagerSpec = {
            retention = "12h";
            resources = {
              requests.memory = "50Mi";
              limits.memory = "100Mi";
            };
          };
          grafana.enabled = false;
          prometheus.ingress = {
            enabled = true;
            ingressClassName = "traefik";
            hosts = [ "prometheus.tech1savvy.me" ];
          };
          kube-state-metrics = {
            resources = {
              requests.memory = "100Mi";
              limits.memory = "200Mi";
            };
          };
          prometheus-node-exporter = {
            resources = {
              requests.memory = "50Mi";
              limits.memory = "100Mi";
            };
          };
          defaultRules.rules.windows = false;
          defaultRules.rules.etcd = false;
          defaultRules.rules.kubeControllerManager = false;
          defaultRules.rules.kubeScheduler = false;
          defaultRules.rules.kubeProxy = false;

          # k3s: etcd not used (uses SQLite/external datastore)
          kubeEtcd.enabled = false;
          # k3s: controller-manager built into k3s server binary
          kubeControllerManager.enabled = false;
          # k3s: scheduler built into k3s server binary
          kubeScheduler.enabled = false;
          # k3s: uses Flannel, kube-proxy optimized/built-in
          kubeProxy.enabled = false;
        };
      };
    };
  };
}
