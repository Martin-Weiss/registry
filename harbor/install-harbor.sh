#!/bin/bash
source ./variables.txt
for PV in registry chartmuseum jobservice database redis trivy; do
	mkdir -p /data/harbor/data/$PV-pv
done
chown -R 999:999 /data/harbor/data/database-pv
chown -R 999:999 /data/harbor/data/redis-pv
chown -R 10000:10000 /data/harbor/data/trivy-pv
chown -R 10000:10000 /data/harbor/data/registry-pv
chown -R 10000:10000 /data/harbor/data/chartmuseum-pv
chown -R 10000:10000 /data/harbor/data/jobservice-pv

cp harbor-$HARBOR_CHART_VERSION/images/*.tar /var/lib/rancher/k3s/agent/images/
systemctl restart k3s
cp /data/harbor/manifests/*.yaml /var/lib/rancher/k3s/server/manifests/
kubectl create ns harbor
kubectl -n harbor create secret tls registry01.suse --key="/data/certificates/$KEY" --cert="/data/certificates/$CERTIFICATE"
kubectl -n harbor create secret generic rootca.suse --from-file=ca.crt="/data/certificates/$CA_CERTIFICATE"
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm upgrade --install harbor harbor-$HARBOR_CHART_VERSION/harbor-$HARBOR_CHART_VERSION.tgz -f harbor-$HARBOR_CHART_VERSION/harbor-$HARBOR_CHART_VERSION.values.yaml --namespace harbor
