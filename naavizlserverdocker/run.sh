#! /bin/bash
#
# startup script for naavizlserver


# Start rwflowpack


/usr/local/sbin/rwflowpack --compression-method=best --sensor-configuration=/data/sensors.conf --site-config-file=/data/silk.conf --output-mode=incremental-files --incremental-directory=/data/incremental --pid
file=/var/log/rwflowpack.pid --log-level=debug --log-directory=/var/log --log-basename=rwflowpack 


/usr/local/bin/super_mediator -c /data/super_mediator.conf --verbose --daemonize
#clickhouse-client -u clickhouse_operator --password clickhouse_operator_password --host clickhouse-naavizl-clickhouse --query="INSERT INTO nflows.smflows FORMAT CSV";

shopt -s nullglob
while true
do
    cd /data/incremental
    echo "PROCESSING INCREMENTAL FILES"
    for f in `find . -type f -mmin +5`; do 
        if ! fuser "$f" >/dev/null 2>/dev/null; then
            echo "EXPORTING $f"
            rwcut $f --timestamp-format=epoch --delimited=,
            rwcut $f --timestamp-format=epoch --delimited=, | clickhouse-client -u clickhouse_operator --password clickhouse_operator_password --host clickhouse-naavizl-clickhouse --query="INSERT INTO nflows.n
flows FORMAT CSVWithNames";
            echo "REMOVING $f"
            rm "$f"
        fi
    done

    cd /data/smflows
    echo "PROCESSING SUPERMEDIATOR FILES"
    for f in `find . -type f -mmin +5`; do
        if ! fuser "$f" >/dev/null 2>/dev/null; then
            echo "EXPORTING $f"
            cat $f
            cat $f | clickhouse-client -u clickhouse_operator --password clickhouse_operator_password --host clickhouse-naavizl-clickhouse --query="INSERT INTO nflows.smflows FORMAT CSV";
            echo "REMOVING $f"
            rm "$f"
        fi
    done
    sleep 60
done