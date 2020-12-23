Building the Server Docker Image

docker build . -t naavizlserver:v1

Running the Server Docker Image

docker run -p 18002:18002 -t naavizlserver:v1