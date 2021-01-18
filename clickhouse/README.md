Running Clickhouse
-----------------

Install Clickhouse Operator
-------------------------------
kubectl apply -f https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator/clickhouse-operator-install.yaml
git clone https://github.com/movsoftware/clickhouse-operator.git

Install Zookeeper 1 node Configuration
--------------------------------------
Install Zookeper Persistent Volume
kubectl apply -f zookeepervolume.yaml -n zoo1ns
Install Zookeeper
deploy/zookeeper/quick-start-persistent-volume/zookeeper-1-node-create.sh
kubectl get all -n zoo1ns

Install Clickhouse
------------------
Install Clickhouse Persistent Volume
kubectl apply -f clickhousevolume.yaml 
Install Clickhouse Cluster
kubectl apply -f clickhouse-cluster.yaml 

Install Databases
-----------------
sh run.sh
