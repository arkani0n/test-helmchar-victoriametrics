#!/usr/bin/bash
minikube start --container-runtime=containerd --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0 --extra-config=etcd.listen-metrics-urls=http://0.0.0.0:2381 --kubernetes-version="v1.27.0"
#install argo
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

kubectl create ns argocd
kubectl create ns monitoring
helm install argocd argo/argo-cd --version 9.0.4 -f argocd/values.yaml -n argocd

# If apps applied before argocd server ready, victoria metrics app having issue "Failed to load target state"
argo_cd_rediness="0"
while [  $argo_cd_rediness != "1/1" ]; do
  echo "ArgoCD server not ready, retry in 5s, output $argo_cd_rediness"
  sleep 5
  argo_cd_rediness="$(kubectl get pods -n argocd | grep argocd-server | awk '{printf $2}')"
done
echo "ArgoCD server ready, installing argo apps"

helm install argocd-apps argo/argocd-apps --version 2.0.2 -f argocd-apps/values.yaml -n argocd