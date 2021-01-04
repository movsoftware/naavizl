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
