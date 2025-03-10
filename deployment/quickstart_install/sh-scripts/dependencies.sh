#!/bin/bash

echo "************************************************************"
echo "****************** Installing dependencies *****************"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add gresearch https://g-research.github.io/charts
helm repo update

helm install storm gresearch/storm -n=siembol \
    --set supervisor.replicaCount=1  \
    --set supervisor.childopts="-Xmx1g" \
    --set supervisor.slots=3 \
    --set zookeeper.fullnameOverride="siembol-zookeeper"

helm install kafka bitnami/kafka -n=siembol \
    --set zookeeper.enabled=false \
    --set externalZookeeper.servers={siembol-zookeeper-0.siembol-zookeeper-headless.siembol.svc} \
    --set provisioning.enabled=true \
    --set "provisioning.topics[0].name=siembol.alerts" \
    --set "provisioning.topics[1].name=siembol.response.heartbeat"

echo "************************************************************"
echo "Checking status by running: 'kubectl get pods -n siembol'"
kubectl get pods -n siembol
echo "************************************************************"
