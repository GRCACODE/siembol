#!/bin/bash

echo "************************************************************"
echo "****************** Installing dependencies *****************"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm dependency update deployment/helm-k8s/storm/
helm install storm deployment/helm-k8s/storm/ -n=siembol

helm install kafka bitnami/kafka -n=siembol \
    --set zookeeper.enabled=false \
    --set externalZookeeper.servers={siembol-zookeeper-0.siembol-zookeeper-headless.siembol.svc}

echo "************************************************************"
echo "Checking status by running: 'kubectl get pods -n siembol'"
kubectl get pods -n siembol
echo "************************************************************"
