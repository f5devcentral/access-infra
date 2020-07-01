sudo docker build -t tao/tao-files-master /etc/docker/infra-master/infra/containers/tao-files-master-build
sudo docker run -d -p 8000:80 --hostname=tao-files-master --restart=always --name tao-files-master tao/tao-files-master
