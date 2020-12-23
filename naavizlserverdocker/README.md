Building the Server Docker Image

docker build . -t ncollectorserverdocker:v1

Running the Server Docker Image

docker run -p 18002:18002 -t naavizlserverdocker:v1