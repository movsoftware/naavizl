Running Clickhouse
-----------------

git clone https://github.com/movsoftware/clickhouse-operator.git


kubectl apply -f clickhouse-operator/deploy/operator/clickhouse-operator-install.yaml
kubectl get all -n kube-system --selector=app=clickhouse-operator


clickhouse-operator/deploy/zookeeper/quick-start-persistent-volume/zookeeper-1-node-create.sh
kubectl get all -n zoo1ns

kubectl apply -f pvolume.yaml 
kubectl apply -f clickhouse-cluster.yaml 

sh run.sh