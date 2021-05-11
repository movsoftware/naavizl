Building the Server Docker Image
-----------------------
docker build . -t movsoftware/naavizlserver:latest

Running the Server Docker Image
------------
docker run -p 18003:18003/udp -t movsoftware/naavizlserver:latest

Running the Server Docker Image in Kubernetes
------------
kubectl apply -f deployment.yaml