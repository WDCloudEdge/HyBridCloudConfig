## Description

The benchmark of hybrid-deployed microservice systems in a cloud-edge collaborative environment.

## Version Control

Kubernetes v1.22.16

Kuboard v3.3.0

Istio v1.13.4

Jaeger v1.52

Elasticsearch/Kibana v8.11.3

Tcpdump v4.9.2

nacos v2.2.1

## Quick Start

### ELK

<strong>Download and install archive for Linux</strong>

```shell
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.11.4-linux-x86_64.tar.gz

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.11.4-linux-x86_64.tar.gz.sha512

shasum -a 512 -c elasticsearch-8.11.4-linux-x86_64.tar.gz.sha512

tar -xzf elasticsearch-8.11.4-linux-x86_64.tar.gz

cd elasticsearch-8.11.4/
```

<strong>Run Elasticsearch from the command line</strong>

```shell
sh ./bin/elasticsearch
```

### Kibana

```shell
./bin/elasticsearch-create-enrollment-token -s kibana

docker run --name kib01 --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:8.11.3
```

### Chaos Mesh

```shell
helm repo add chaos-mesh https://charts.chaos-mesh.org

kubectl create ns chaos-mesh

helm install chaos-mesh chaos-mesh/chaos-mesh --namespace=chaos-mesh
```

### Jaeger

```shell
docker run -d --net elastic --name jaeger1.52 \
 -e COLLECTOR_OTLP_ENABLED=true \
 -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
 -e SPAN_STORAGE_TYPE=elasticsearch \
 -e ES_SERVER_URLS=https://es01:9200 \
 -e ES_TLS_CA=/home/certs/http_ca.crt \
 -e ES_PASSWORD=mViZGpR8tBP-+-NX8bt2 \
 -e ES_USERNAME=elastic \
 -e ES_TLS_ENABLED=true \
 -p 5775:5775/udp \
 -p 6831:6831/udp \
 -p 6832:6832/udp \
 -p 5778:5778 \
 -p 16686:16686 \
 -p 14250:14250 \
 -p 14268:14268 \
 -p 14269:14269 \
 -p 4317:4317 \
 -p 4318:4318 \
 -p 9411:9411 \
 -v /jaeger:/home \
 jaegertracing/all-in-one:1.52
```

### Minio

```shell
helm repo add minio-operator https://operator.min.io

helm search repo minio-operator

helm install --namespace minio-operator --create-namespace operator minio-operator/operator

SA_TOKEN=$(kubectl -n minio-operator get secret console-sa-secret -o jsonpath="{.data.token}" | base64 --decode)
echo $SA_TOKEN

helm install --namespace MINIO_TENANT_NAMESPACE --create-namespace MINIO_TENANT_NAME minio-operator/tenant
```

### Kuboard

```shell
docker pull eipwork/kuboard:v3

sudo docker run -d \
 --restart=unless-stopped \
 --name=kuboard \
 -p 80:80/tcp \
 -p 30081:10081/tcp \
 -e KUBOARD_ENDPOINT="http://IP:80" \
 -e KUBOARD_AGENT_SERVER_TCP_PORT="30081" \
 -v /root/kuboard-data:/data \
 eipwork/kuboard:v3
```

### OpenYurt

```shell
helm repo add openyurt https://openyurtio.github.io/openyurt-helm

helm upgrade --install yurt-manager -n kube-system openyurt/yurt-manager

helm upgrade --install yurt-hub -n kube-system --set kubernetesServerAddr=https://1.2.3.4:6443 openyurt/yurthub

helm upgrade --install raven-agent -n kube-system openyurt/raven-agent
```

### ETCD

#### Download

```shell
tar -xvf etcd-v3.5.0-linux-amd64.tar.gz

cd etcd-v3.4.13-linux-amd64

mv etcd etcdctl /usr/bin/

```

#### Tools to Install SSL

```shell
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 
chmod +x cfssl_linux-amd64 cfssljson_linux-amd64 cfssl-certinfo_linux-amd64
```

#### Edit `ca-config.json` and `ca-csr.json`

pass

#### Create ETCD certificate (`server-csr.json`)

#### Generating Keys

```shell
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www server-csr.json |cfssljson -bare server
```

#### Create ETCD Config（etcd.conf）

#### Running

```shell
systemctl daemon-reload

systemctl enable etcd

systemctl start etcd
```

#### Tcpdump

```shell
sudo yum install tcpdump-4.9.2
```

### Nacos

### ttservice

### test-database-horsecoder-com

The dns name of the database, created by the service component in Kubernetes.