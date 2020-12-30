#! /bin/bash
#
# startup script for naavizlserver


# Start rwflowpack
/usr/local/sbin/rwflowpack --compression-method=best --sensor-configuration=/data/sensors.conf --site-config-file=/data/silk.conf --output-mode=incremental-files --incremental-directory=/data/incremental --pidfile=/var/log/rwflowpack.pid --log-level=debug --log-directory=/var/log --log-basename=rwflowpack


shopt -s nullglob
cd /data/incremental
while true
do
    echo "PROCESSING INCREMENTAL FILES"
    for f in `find . -type f -mmin +5`; do 
        if ! fuser "$f" >/dev/null 2>/dev/null; then
            echo "EXPORTING $f"
            rwcut $f --timestamp-format=epoch --delimited=,
            rwcut $f --timestamp-format=epoch --delimited=, | clickhouse-client --host 092.public.zeus.run --query="INSERT INTO nflows.nflows FORMAT CSVWithNames";
            echo "REMOVING $f"
            rm "$f"
        fi
    done
    sleep 60
done
