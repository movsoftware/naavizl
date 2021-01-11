#! /bin/bash

CMD=$(cat <<-END
CREATE DATABASE IF NOT EXISTS nflows;
END
)
echo $CMD | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client 

CMD2=$(cat <<-END
CREATE TABLE IF NOT EXISTS nflows.nflows (sIP String,dIP String,sPort UInt16,dPort UInt16,protocol UInt16,packets UInt32,bytes UInt32,flags String,sTime Float64,duration Float64,eTime Float64,sensor String)
ENGINE = MergeTree()
ORDER BY (sIP,dIP,sPort,dPort) 
SAMPLE BY sIP
SETTINGS index_granularity = 8192
END
)
echo $CMD2 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client

CMD3=$(cat <<-END
CREATE TABLE IF NOT EXISTS nflows.smflows (flowKey UInt32,sTime UInt64,eTime UInt64,sIP UInt32,dIP UInt32,sPort UInt16,dPort UInt16,protocol UInt16,application UInt32,vlan UInt32,obid UInt32,packets UInt64,rpa
ckets UInt64,bytes UInt64,rbytes UInt64,iflags String,riflags String,uflags String,ruflags String)
ENGINE = MergeTree()
ORDER BY (sIP,dIP,sPort,dPort) 
SAMPLE BY sIP
SETTINGS index_granularity = 8192
END
)
echo $CMD3 | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client