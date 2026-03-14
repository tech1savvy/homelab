So you built a **K3s cluster on AWS with Terraform, NixOS config, Helm deployments, CI via GitHub Actions, and you’re running services on it**… and you’re wondering if it’s “too small” to mention on a resume.

Humans are strange. People put _“installed Docker once”_ on resumes and sleep peacefully. Meanwhile you’re orchestrating half a cloud stack and feeling guilty about it.

Short answer: **yes, absolutely put it on your resume.** Not only that, this is **exactly the kind of project that shows real DevOps skills**. The trick is _how you present it_.

---

## Why This Project Is Actually Valuable

What you described touches multiple real-world areas:

| Area                          | What you're demonstrating  |
| ----------------------------- | -------------------------- |
| Infrastructure as Code        | Terraform provisioning AWS |
| Kubernetes                    | K3s cluster management     |
| Configuration Management      | NixOS system configuration |
| Package/Deployment Management | Helm charts                |
| Observability                 | Prometheus + Grafana       |
| Platform Ops                  | Hosting multiple services  |
| CI/CD                         | GitHub Actions pipelines   |

Most junior or even mid engineers **haven't integrated all of those together** in one project.

Also: **self-hosted platforms = very respected in DevOps hiring** because it shows you understand systems end-to-end.

---

## What Matters More Than Size

Hiring managers don't care if the cluster has **1 node or 200 nodes**.

They care about:

- **automation**
- **reproducibility**
- **infrastructure design**
- **operational thinking**

A **single-node K3s homelab** is extremely common as a DevOps learning platform.

Even senior engineers run them.

---

## How NOT To Write It

Bad resume bullet:

> Built a Kubernetes cluster using k3s and installed Rancher.

That sounds like a tutorial copy.

---

## How To Write It Properly

Example:

**Self-Hosted Platform on AWS**

- Provisioned AWS infrastructure using **Terraform** to deploy a **K3s Kubernetes cluster**
- Managed node configuration with **NixOS declarative system configuration**
- Deployed platform services using **Helm**, including **Rancher**, **Prometheus**, and **Grafana**
- Implemented **CI pipelines with GitHub Actions** for automated infrastructure and service deployment
- Hosted multiple open-source applications for personal platform services
- Implemented cluster observability with **Prometheus metrics and Grafana dashboards**

That sounds like **real platform engineering**.

---

## If You Want To Make It Even Stronger

Add one or two things:

- **ArgoCD or Flux (GitOps)**
- **Ingress + TLS (Traefik / Nginx / cert-manager)**
- **Secrets management (SOPS / Vault / SealedSecrets)**
- **Backup strategy**
- **Monitoring alerts**

Not required, but they turn a project from _good_ → _very impressive_.

---

## Brutal Truth (Since you're asking)

Compared to the average resume:

- **Your project is already above average.**

Compared to a senior platform engineer:

- It's **a good homelab**, not production scale.

But resumes don't need production scale. They need **evidence of competence**.

And this does that nicely.

---

## One More Tip (Very Important)

Put the **GitHub repo** on your resume.

DevOps hiring managers love seeing:

```
terraform/
helm/
nixos/
github-actions/
k8s/
```

Instant credibility.

---

If you want, I can also show you:

- **How DevOps engineers structure homelab projects for resumes**
- **What hiring managers actually look for**
- **How to turn this into a “Platform Engineer” level project**

The difference between a **nice project** and a **resume magnet** is usually just a few tweaks.
