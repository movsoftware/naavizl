Building the Server Docker Image
-----------------------
docker build . -t naavizlserver:v1

Running the Server Docker Image
------------
docker run -p 18002:18002 -p 18003:18003/udp -t naavizlserver:v1

Running the Server Docker Image in Kubernetes
------------
kubectl apply -f deployment.yaml