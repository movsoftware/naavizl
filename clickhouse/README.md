Running Clickhouse
-----------------

Install Clickhouse Operator
-------------------------------
git clone https://github.com/movsoftware/clickhouse-operator.git
kubectl apply -f clickhouse-operator/deploy/operator/clickhouse-operator-install-bundle.yaml

Install Zookeeper 1 node Configuration
--------------------------------------
Install Zookeper Persistent Volume
kubectl apply -f zookeepervolume.yaml -n zoo1ns
Install Zookeeper
cd clickhouse-operator
deploy/zookeeper/quick-start-persistent-volume/zookeeper-1-node-create.sh
kubectl get all -n zoo1ns

If you want a 2 shard/replicator clickhouse:
Install Clickhouse (2 shard/2 replicator cluster configuration)
------------------
Install Clickhouse Persistent Volumes
kubectl apply -f clickhousevolume.yaml 
kubectl apply -f clickhousevolume2.yaml 
kubectl apply -f clickhousevolume3.yaml 
kubectl apply -f clickhousevolume4.yaml 
Install Clickhouse Cluster
kubectl apply -f clickhouse-cluster.yaml 


Install Databases (2 shard/2 replicator)
-----------------
sh setupdb.sh

If you want a 1 shard/replicator clickhouse:
Install Clickhouse (1 shard/1 replicator cluster configuration)
------------------
Install Clickhouse Persistent Volume
kubectl apply -f clickhousevolume.yaml
Install Clickhouse Cluster
kubectl apply -f clickhouse-cluster-1-node.yaml

Install Databases (1 shard/1 replicator)
-----------------
sh setupdb-1-node.sh


