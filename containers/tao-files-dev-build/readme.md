sudo docker build -t tao/tao-files-dev /etc/docker/infra-master/infra/containers/tao-files-dev-build
sudo docker run -d -p 8001:80 --hostname=tao-files-dev --restart=always --name tao-files-dev tao/tao-files-dev
