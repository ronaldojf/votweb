cd $HOME/votweb
docker pull votweb/votweb:latest

WEB=$(docker-compose ps -q web)
WORKDIR=$(docker exec $WEB pwd)

docker cp $WEB:$WORKDIR/docker-compose.yml docker-compose.yml
docker cp $WEB:$WORKDIR/atualizar-votweb.sh atualizar-votweb.sh
chmod +x atualizar-votweb.sh

docker-compose up -d
docker-compose run --rm web rake db:create
docker-compose run --rm web rake db:migrate

echo "ATUALIZAÇÃO CONCLUÍDA!"
