Running Clickhouse
-----------------

The Clickhouse installation procedure uses the clickhouse-operator system provided by Altinity to deploy the Clickhouse datastore on Kubernetes.

First clone the clickhouse-operator from github:

git clone https://github.com/Altinity/clickhouse-operator


Next, install the operator:
kubectl apply -f clickhouse-operator/deploy/operator/clickhouse-operator-install.yaml
kubectl get all -n kube-system --selector=app=clickhouse-operator

Create a zookeeper node to coordinate the Clickhouse containers:
clickhouse-operator/deploy/zookeeper/quick-start-persistent-volume/zookeeper-1-node-create.sh
kubectl get all -n zoo1ns

Apply a persistent volume for local data storage. This is a sample 20GB local volume:
kubectl apply -f pvolume.yaml 

Apply the Clickhouse cluster itself:
kubectl apply -f clickhouse-cluster.yaml 

Run a setup script to configure the Clickhouse database and tables:
sh run.sh