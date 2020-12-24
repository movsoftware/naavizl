Building the Client Docker Image
------------------
docker build . -t naavizlclient:v1

Running the Client Docker Image
---------------------
docker run --rm --net=host -e IFACE="eth0" -e SILK_HOST="my.host.com" -e SILK_PORT="18002" naavizlclient:v1