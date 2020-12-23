#! /bin/sh
#
# startup script for naavizlclient

# Start yaf

while true
    do
        yaf --out $SILK_HOST --ipfix-port $SILK_PORT --ipfix tcp --live pcap --in $IFACE --verbose --silk
        sleep 1
    done
done
