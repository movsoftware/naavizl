Building the Client Docker Image
------------------
docker build . -t naavizlclient:v1

Running the Client Docker Image
---------------------
docker run --rm --net=host -e IFACE="eth0" -e SILK_HOST="my.silkhost.com" -e SILK_PORT="18006" --cap-add=NET_ADMIN --privileged naavizlclient:v1