#! /bin/bash

mkdir -p $HOME/naavizl_clickhouse_database
docker run -d --name naavizl-clickhouse-server --ulimit nofile=262144:262144 -p 9000:9000 -p 8123:8123 --volume=$HOME/naavizl_clickhouse_database:/var/lib/clickhouse yandex/clickhouse-server
docker run -it --rm --link naavizl-clickhouse-server:clickhouse-server yandex/clickhouse-client --host clickhouse-server -m --query "CREATE DATABASE IF NOT EXISTS nflows"

CMD=$(cat <<-END
    CREATE TABLE nflows.nflows (sIP String,dIP String,sPort UInt16,dPort UInt16,protocol UInt16,packets UInt32,bytes UInt32,flags String,sTime Float64,duration Float64,eTime Float64,sensor String)
    ENGINE = MergeTree()
    ORDER BY (sIP,dIP,sPort,dPort) 
    SAMPLE BY sIP
    SETTINGS index_granularity = 8192
END
)
docker run -it --rm --link naavizl-clickhouse-server:clickhouse-server yandex/clickhouse-client --host clickhouse-server -m --query "$CMD"