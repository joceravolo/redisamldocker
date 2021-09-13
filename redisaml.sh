#!/bin/bash
clear
echo ======================================================================================================
echo REDISAML WITH CDC Docker configuration script
echo ======================================================================================================
echo
echo 1. Start Docker process 
systemctl start docker
echo
echo 2. Clean up previous docker containers and docker network
docker rm amlpostgres amlredis amlredisinsight
docker network rm redisamldocker_amlnetwork
echo
echo 3. Start containers with docker-compose
docker-compose up -d
echo
echo 4. Wait for the containers to start
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
echo
echo 5. Create postgres tables
docker exec amlpostgres bash -c 'psql -U postgres -d postgres -b -f "/redisaml/cdc/amlcreatetables.sql"' 
echo
echo 6. Create redis cluster
docker exec -d --privileged amlredis "/opt/redislabs/bin/rladmin" cluster create name cluster.local username admin@email.com password admin
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
sleep 5
echo .
echo
echo 7. Create redis database [amldb] for the AML cases with RediSearch, Timeseries and ReJSON enabled
curl -k -u "admin@email.com:admin" --request POST --url "https://localhost:9443/v1/bdbs" --header 'content-type: application/json' --data '{"name":"amldb","type":"redis","memory_size":502400000,"port":12000, "module_list": [ {"module_args": "PARTITIONS AUTO", "module_name": "search", "semantic_version": "2.0.11"} ,{"module_args": "","module_name":"ReJSON","semantic_version":"1.0.8"},{"module_args":"","module_name":"timeseries","semantic_version":"1.4.10"}]}'
echo
echo 8. Create redis database [cdcdb] for the CDC metrics
curl -k -u "admin@email.com:admin" --request POST --url "https://localhost:9443/v1/bdbs" --header 'content-type: application/json' --data '{"name":"cdcdb","type":"redis","memory_size":102400000,"port":12001, "module_list": [ {"module_args": "PARTITIONS AUTO", "module_name": "search", "semantic_version": "2.0.11"} ,{"module_args": "","module_name":"ReJSON","semantic_version":"1.0.8"},{"module_args":"","module_name":"timeseries","semantic_version":"1.4.10"}]}'

echo
echo
echo 9. Start CDC
cd redis-connect-postgres/bin
source env.sh
chmod +x cleansetup.sh 
chmod +x startup.sh 
./cleansetup.sh
./startup.sh
cd ../..
echo
echo
echo Do you want to create the search schema in redis? [y/n]
echo If you want to use Jupyter Notebook answer 'n'.
read option
case "$option" in
  "y") 
  echo 10. Create Search Schema in amldb
  python3 create_redis_schema.py;;
  "n")
  echo Search Schema will be created using Jupyter Notebook;;
esac
echo
echo
echo Do you want to start the Postgres record generation script? [y/n]
read option
case "$option" in
  "y")
  python3 generate_postgres_cases.py;;
  "n")
  echo Generate records into Postgres using python3 generate_postgres_cases.py;;
esac
echo
echo
echo
echo ------------------------------------------------------------------------------------------------------------------------------
echo POSTGRES IP Address:
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' amlpostgres
echo Use this IP with port 5432 to connect to postgres! 
echo ------------------------------------------------------------------------------------------------------------------------------
echo Redis Enterprise IP Address:
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' amlredis
echo Use this IP with Port 12000 for the AMLDB. This database will contain the cases uploaded from Postgres to Redis by the CDC.
echo Use this IP with Port 12001 for the CDCDB. This database will contain the metrics for the CDC.
echo 
echo Web UI user: admin@email.com 
echo Password: admin 
echo
echo ------------------------------------------------------------------------------------------------------------------------------
echo Use localhost:8443 to access Redis cluster.
echo Use localhost:8001 to use Redis Insight.
echo
echo Do you want to open the browser with Redis Enterprise UI and Redis Insight? [y/n]
read option
case "$option" in 
  "y") 
  open https://localhost:8443
  open http://localhost:8001;;
esac
echo


