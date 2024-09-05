#!/bin/bash
# Generation de conteneur
# @tutopalace - https://github.com/tutopalace/serveurLinux
# 2024/09

# docker pull ubuntu
# docker run -itd --name <name> ubuntu
# docker exec -it <name> bash

# if [ -z "$1" ]
# then
# 	echo "Usage: $0 <container_name>"
# 	exit 1;
# fi

[ -z "$1" ] && { echo "Usage: $0 <container_name>"; exit 1; }

echo "--------"

echo "docker run -itd --name $1 ubuntu"
docker run -itd --name $1 ubuntu

echo "docker exec -it $1 bash"
docker exec -it $1 bash
