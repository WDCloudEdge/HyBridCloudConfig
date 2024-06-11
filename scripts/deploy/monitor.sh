##Jaeger
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
##Prometheus
kubectl apply -f ./deploy/prometheus/setup
kubectl apply -f ./deploy/prometheus
##ELK
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.11.4-linux-x86_64.tar.gz

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.11.4-linux-x86_64.tar.gz.sha512

shasum -a 512 -c elasticsearch-8.11.4-linux-x86_64.tar.gz.sha512

tar -xzf elasticsearch-8.11.4-linux-x86_64.tar.gz

cd elasticsearch-8.11.4/

sh ./bin/elasticsearch

##Kibana
./bin/elasticsearch-create-enrollment-token -s kibana

docker run --name kib01 --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:8.11.3

##Chaos-mesh
helm repo add chaos-mesh https://charts.chaos-mesh.org

kubectl create ns chaos-mesh

helm install chaos-mesh chaos-mesh/chaos-mesh --namespace=chaos-mesh

##Tcpdump
sudo yum install tcpdump-4.9.2