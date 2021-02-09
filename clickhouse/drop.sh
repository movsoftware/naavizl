CMD=$(cat <<-END
DROP DATABASE IF EXISTS nflows;
END
)
echo $CMD | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-0-0 -- clickhouse-client
echo $CMD | kubectl exec -i chi-naavizl-clickhouse-replcluster-0-1-0 -- clickhouse-client
echo $CMD | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-0-0 -- clickhouse-client
echo $CMD | kubectl exec -i chi-naavizl-clickhouse-replcluster-1-1-0 -- clickhouse-client
