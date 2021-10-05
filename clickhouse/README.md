Running Clickhouse
-----------------

Install Clickhouse Operator
-------------------------------
git clone https://github.com/movsoftware/clickhouse-operator.git
kubectl apply -f clickhouse-operator/master/deploy/operator/clickhouse-operator-install.yaml

Install Zookeeper 1 node Configuration
--------------------------------------
Install Zookeper Persistent Volume
kubectl apply -f zookeepervolume.yaml -n zoo1ns
Install Zookeeper
cd clickhouse-operator
deploy/zookeeper/quick-start-persistent-volume/zookeeper-1-node-create.sh
kubectl get all -n zoo1ns

Install Clickhouse (2 shard/2 replicator cluster configuration)
------------------
Install Clickhouse Persistent Volumes
kubectl apply -f clickhousevolume.yaml 
kubectl apply -f clickhousevolume2.yaml 
kubectl apply -f clickhousevolume3.yaml 
kubectl apply -f clickhousevolume4.yaml 
Install Clickhouse Cluster
kubectl apply -f clickhouse-cluster.yaml 

Install Databases
-----------------
sh setupdb.sh
