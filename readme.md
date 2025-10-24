# test-helmchar-victoriametrics

A simple application Helm chart with Grafana dashboards, VictoriaMetrics k8s stack configuration, and ArgoCD values for automated deployment.

## Overview

This repository demonstrates a complete monitoring stack deployment using:
- **VictoriaMetrics k8s Stack** - Time series database and monitoring
- **Grafana** - Visualization dashboards
- **ArgoCD** - GitOps continuous delivery
- **Sample Application** - Demo application with pre-configured dashboards

## Prerequisites

Before you begin, ensure you have the following installed:

- `kubectl` - Kubernetes command-line tool
- `minikube` - Local Kubernetes cluster
- `helm` 3.0.0 or higher - Kubernetes package manager

### Minikube Requirements

Your minikube cluster must have:
- **Minimum 8GB RAM**
- **Minimum 2 CPUs**

## Quick Start

Clone the repository and run the setup script:

```bash
git clone https://github.com/arkani0n/test-helmchar-victoriametrics.git
cd test-helmchar-victoriametrics
chmod +x script.sh
./script.sh
```

## What the Script Does

The `script.sh` automation script performs the following steps:

1. **Starts Minikube** with Kubernetes v1.27.0
2. **Creates Namespaces** - `argocd` and `monitoring`
3. **Adds Helm Repository** for ArgoCD
4. **Installs ArgoCD** chart and ArgoCD applications

After the script completes, ArgoCD takes over and automatically deploys the remaining applications.

## Verification Steps

### 1. Verify ArgoCD is Running

Check that all ArgoCD pods are running:

```bash
kubectl get pods -n argocd
```

**Expected Output:**

```
NAME                                                READY   STATUS    RESTARTS      AGE
argocd-application-controller-0                     1/1     Running   1 (58m ago)   167m
argocd-applicationset-controller-58c575cf89-tvkdj   1/1     Running   1 (58m ago)   167m
argocd-dex-server-84889dbdd5-xvf8t                  1/1     Running   1 (58m ago)   167m
argocd-notifications-controller-78c6bf4799-cppv2    1/1     Running   1 (58m ago)   167m
argocd-redis-784668b699-lcmf9                       1/1     Running   1 (58m ago)   167m
argocd-repo-server-74d6b9cd67-zcmtt                 1/1     Running   1 (58m ago)   167m
argocd-server-f94db698f-p4lgb                       1/1     Running   2 (57m ago)   167m
```

### 2. Verify ArgoCD Applications

Check that ArgoCD applications are created:

```bash
kubectl get applications.argoproj.io -n argocd
```

**Expected Output:**

```
NAME          SYNC STATUS   HEALTH STATUS
argocd        Synced        Healthy
argocd-apps   OutOfSync     Healthy
spam2000      OutOfSync     Healthy
vmks          OutOfSync     Missing
```

> **Note:** Applications will not be immediately synced. The important thing is that they are present and ArgoCD will sync them automatically.

### 3. Access ArgoCD UI (Optional)

If you want to monitor the deployment progress visually:

**Port Forward to ArgoCD Server:**

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

**Get the Initial Admin Password:**

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

**Login:**
- **URL:** https://localhost:8080
- **Username:** `admin`
- **Password:** (output from the command above)

### 4. Access Grafana

Once the monitoring stack is deployed, access Grafana to view dashboards:

**Port Forward to Grafana:**

```bash
kubectl port-forward svc/vmks-grafana 8081:80 -n monitoring
```

**Login:**
- **URL:** http://localhost:8081
- **Username:** `admin`
- **Password:** `admin`

**View Dashboards:**
Navigate to the dashboards section and look in the default folder for pre-configured monitoring dashboards.

## Components

- **ArgoCD** - GitOps continuous delivery tool
- **VictoriaMetrics k8s Stack** - Complete monitoring solution
- **Grafana** - Metrics visualization and dashboards
- **spam2000** - Sample application for demonstration

## Cleanup

To remove all resources:

```bash
minikube delete
```

## Resources

- [VictoriaMetrics Helm](https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-k8s-stack)
- [ArgoCD Helm](https://github.com/argoproj/argo-helm/tree/fix-argo-helm-3-18/charts/argo-cd)
- [ArgoCD Apps Helm](https://github.com/argoproj/argo-helm/tree/fix-argo-helm-3-18/charts/argocd-apps)
- [Grafana Helm](https://github.com/grafana/helm-charts/tree/main/charts/grafana)


## License

This project is provided as-is for demonstration and testing purposes.
