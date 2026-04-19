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
        enable = false;
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
          alertmanager = {
            ingress = {
              enabled = true;
              ingressClassName = "traefik";
              hosts = [ "alertmanager.tech1savvy.me" ];
            };

            alertmanagerSpec = {
              retention = "12h";
              resources = {
                requests.memory = "50Mi";
                limits.memory = "100Mi";
              };
            };

            # config = {
            #   route = {
            #     receiver = "email-notifications";
            #     group_by = [ "namespace" ];
            #     group_wait = "30s";
            #     group_interval = "5m";
            #     repeat_interval = "12h";
            #     routes = [
            #       {
            #         receiver = "null";
            #         matchers = [ "alertname = \"Watchdog\"" ];
            #       }
            #     ];
            #   };
            #   receivers = [
            #     { name = "null"; }
            #     {
            #       name = "email-notifications";
            #       email_configs = [
            #         {
            #           to = "amankumar010604@gmail.com";
            #           smarthost = "smtp.gmail.com:587";
            #           from = "amankumar010604@gmail.com";
            #           auth_username = "amankumar010604@gmail.com";
            #           auth_password_from_secret = "alertmanager-smtp";
            #           require_tls = true;
            #         }
            #       ];
            #     }
            #   ];
            # };
          };
          additionalPrometheusRulesMap = {
            custom-alerts = {
              groups = [
                {
                  name = "custom_rules";
                  rules = [
                    {
                      alert = "HighCPUUsage";
                      expr = ''100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80'';
                      for = "5m";
                      labels = {
                        severity = "warning";
                      };
                      annotations = {
                        summary = "High CPU usage detected";
                        description = "CPU usage is above 80% for more than 5 minutes on {{ $labels.instance }}";
                      };
                    }
                    {
                      alert = "HighMemoryUsage";
                      expr = "100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) > 80";
                      for = "5m";
                      labels = {
                        severity = "warning";
                      };
                      annotations = {
                        summary = "High memory usage detected";
                        description = "Memory usage is above 80% on {{ $labels.instance }}";
                      };
                    }
                  ];
                }
              ];
            };
          };

          grafana = {
            enabled = true;
            ingress = {
              enabled = true;
              ingressClassName = "traefik";
              hosts = [ "grafana.tech1savvy.me" ];
            };
          };

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
