#!/bin/bash -e

cd $HOME/votweb
docker pull votweb/votweb:latest

WEB=$(docker-compose ps -q web)
WORKDIR=$(docker exec $WEB pwd)

docker cp $WEB:$WORKDIR/docker-compose.yml docker-compose.yml
docker cp $WEB:$WORKDIR/atualizar-votweb.sh atualizar-votweb.sh
chmod +x atualizar-votweb.sh

docker-compose up -d
docker-compose run --rm web rake db:create db:migrate

echo "Removendo container não usados..."
docker ps -a -q | xargs docker rm &> /dev/null
echo "Removendo imagens não usadas..."
docker images -q | xargs docker rmi &> /dev/null

echo "ATUALIZAÇÃO CONCLUÍDA!"
