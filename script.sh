# install victoria metrics
helm repo add vm https://victoriametrics.github.io/helm-charts/
helm repo update

# list versions
#helm search repo vm/victoria-metrics-k8s-stack -l

helm install vmks vm/victoria-metrics-k8s-stack -f values.yaml -n monitoring
#             ^ chart name


## Recommended way for minikube:
minikube start --container-runtime=containerd --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0 --extra-config=etcd.listen-metrics-urls=http://0.0.0.0:2381
helm install vmks vm/victoria-metrics-k8s-stack -f values.yaml -n monitoring

# my chart
# Validate the chart
helm lint .

# Test template rendering (see what will be created)
helm template my-app . -f values.yaml

# Dry run to see if it will work with the cluster
helm install my-app .  -n default


# Add the ArgoCD Helm repository
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Create namespace for ArgoCD
kubectl create namespace argocd

# Install ArgoCD
helm install argocd argo/argo-cd -n argocd

# Port forward to access the UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get the initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d