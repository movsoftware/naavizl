#! /bin/bash

CMD=$(cat <<-END
CREATE DATABASE IF NOT EXISTS nflows;
END
)
echo $CMD | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client 
echo $CMD | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-1-0 -- clickhouse-client 
echo $CMD | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-0-0 -- clickhouse-client 
echo $CMD | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-1-0 -- clickhouse-client 

CMD2=$(cat <<-END
CREATE TABLE IF NOT EXISTS nflows.nflows on cluster '{cluster}' (sIP String,dIP String,sPort UInt16,dPort UInt16,protocol UInt16,packets UInt32,bytes UInt32,flags String,sTime Float64,duration Float64,eTime Float64,sensor String)
ENGINE=ReplicatedMergeTree('/clickhouse/{cluster}/tables/{shard}/nflows', '{replica}')
ORDER BY (sIP,dIP,sPort,dPort)
SAMPLE BY sIP
PARTITION BY toDate(toInt64(sTime))
TTL FROM_UNIXTIME(toInt64(sTime)) + toIntervalDay(7)
SETTINGS index_granularity = 8192
END
)
echo $CMD2 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client
echo $CMD2 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-1-0 -- clickhouse-client
echo $CMD2 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-0-0 -- clickhouse-client
echo $CMD2 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-1-0 -- clickhouse-client

CMD3=$(cat <<-END
CREATE TABLE IF NOT EXISTS nflows.smflows on cluster '{cluster}' (flowKey UInt32,sTime UInt64,eTime UInt64,sIP UInt32,dIP UInt32,sPort UInt16,dPort UInt16,protocol UInt16,application UInt32,vlan UInt32,obid UInt32,packets UInt64,rpackets UInt64,bytes UInt64,rbytes UInt64,iflags String,riflags String,uflags String,ruflags String)
ENGINE=ReplicatedMergeTree('/clickhouse/{cluster}/tables/{shard}/smflows', '{replica}')
ORDER BY (sIP,dIP,sPort,dPort)
SAMPLE BY sIP
PARTITION BY toDate(sTime/1000)
TTL FROM_UNIXTIME(toInt64(sTime/1000)) + toIntervalDay(7)
SETTINGS index_granularity = 8192
END
)
echo $CMD3 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client
echo $CMD3 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-1-0 -- clickhouse-client
echo $CMD3 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-0-0 -- clickhouse-client
echo $CMD3 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-1-0 -- clickhouse-client

CMD4=$(cat <<-END
CREATE TABLE IF NOT EXISTS distributed_nflows
(
sIP String,dIP String,sPort UInt16,dPort UInt16,protocol UInt16,packets UInt32,bytes UInt32,flags String,sTime Float64,duration Float64,eTime Float64,sensor String
)
ENGINE = Distributed('{cluster}', 'nflows', 'nflows', rand());
END
)
echo $CMD4 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client
echo $CMD4 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-1-0 -- clickhouse-client
echo $CMD4 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-0-0 -- clickhouse-client
echo $CMD4 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-1-0 -- clickhouse-client

CMD5=$(cat <<-END
CREATE TABLE IF NOT EXISTS distributed_smflows
(
flowKey UInt32,sTime UInt64,eTime UInt64,sIP UInt32,dIP UInt32,sPort UInt16,dPort UInt16,protocol UInt16,application UInt32,vlan UInt32,obid UInt32,packets UInt64,rpackets UInt64,bytes UInt64,rbytes UInt64,iflags String,riflags String,uflags String,ruflags String
)
ENGINE = Distributed('{cluster}', 'nflows', 'smflows', rand());
END
)
echo $CMD5 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client
echo $CMD5 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-1-0 -- clickhouse-client
echo $CMD5 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-0-0 -- clickhouse-client
echo $CMD5 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-1-0 -- clickhouse-client

CMD6=$(cat <<-END
CREATE TABLE IF NOT EXISTS nflows.smbadflows on cluster '{cluster}' (flowKey UInt32,sTime UInt64,eTime UInt64,sIP UInt32,dIP UInt32,sPort UInt16,dPort UInt16,protocol UInt16,application UInt32,vlan UInt32,obid UInt32,packets UInt64,rpackets UInt64,bytes UInt64,rbytes UInt64,iflags String,riflags String,uflags String,ruflags String,sIPisocode String,dIPisocode String)
ENGINE=ReplicatedMergeTree('/clickhouse/{cluster}/tables/{shard}/smbadflows', '{replica}')
ORDER BY (sIP,dIP,sPort,dPort)
SAMPLE BY sIP
PARTITION BY toDate(sTime/1000)
TTL FROM_UNIXTIME(toInt64(sTime/1000)) + toIntervalDay(7)
SETTINGS index_granularity = 8192
END
)
echo $CMD6 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client
echo $CMD6 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-1-0 -- clickhouse-client
echo $CMD6 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-0-0 -- clickhouse-client
echo $CMD6 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-1-0 -- clickhouse-client

CMD7=$(cat <<-END
CREATE TABLE IF NOT EXISTS distributed_smbadflows
(
flowKey UInt32,sTime UInt64,eTime UInt64,sIP UInt32,dIP UInt32,sPort UInt16,dPort UInt16,protocol UInt16,application UInt32,vlan UInt32,obid UInt32,packets UInt64,rpackets UInt64,bytes UInt64,rbytes UInt64,iflags String,riflags String,uflags String,ruflags String,sIPisocode String,dIPisocode String
)
ENGINE = Distributed('{cluster}', 'nflows', 'smbadflows', rand());
END
)
echo $CMD7 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client
echo $CMD7 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-1-0 -- clickhouse-client
echo $CMD7 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-0-0 -- clickhouse-client
echo $CMD7 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-1-0 -- clickhouse-client

CMD8=$(cat <<-END
CREATE TABLE IF NOT EXISTS nflows.badflows on cluster '{cluster}' (sIP String,dIP String,sPort UInt16,dPort UInt16,protocol UInt16,packets UInt32,bytes UInt32,flags String,sTime Float64,duration Float64,eTime Float64,sensor String,sIPisocode String,dIPisocode String)
ENGINE=ReplicatedMergeTree('/clickhouse/{cluster}/tables/{shard}/badflows', '{replica}')
ORDER BY (sIP,dIP,sPort,dPort)
SAMPLE BY sIP
PARTITION BY toDate(sTime)
TTL FROM_UNIXTIME(toInt64(sTime)) + toIntervalDay(7)
SETTINGS index_granularity = 8192
END
)
echo $CMD8 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client
echo $CMD8 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-1-0 -- clickhouse-client
echo $CMD8 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-0-0 -- clickhouse-client
echo $CMD8 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-1-0 -- clickhouse-client

CMD9=$(cat <<-END
CREATE TABLE IF NOT EXISTS distributed_badflows
(
    sIP String,dIP String,sPort UInt16,dPort UInt16,protocol UInt16,packets UInt32,bytes UInt32,flags String,sTime Float64,duration Float64,eTime Float64,sensor String,sIPisocode String,dIPisocode String
)
ENGINE = Distributed('{cluster}', 'nflows', 'badflows', rand());
END
)
echo $CMD9 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client
echo $CMD9 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-1-0 -- clickhouse-client
echo $CMD9 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-0-0 -- clickhouse-client
echo $CMD9 | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-1-0 -- clickhouse-client