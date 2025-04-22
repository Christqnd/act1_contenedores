#!/bin/bash

echo Ejecutando clean-all.sh...
./clean-all.sh

docker run --name my-postgres -e POSTGRES_DB=postgres -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -v pgdata:/var/lib/postgresql/data -p 5432:5432 -d postgres:latest
sleep 5
docker cp init.sql my-postgres:/init.sql
docker exec -it my-postgres psql -U myuser -d postgres -f /init.sql

docker build -t my-backend ./backend
docker run -d --name my-backend -p 8080:8080 -e QUARKUS_DATASOURCE_JDBC_URL=jdbc:postgresql://my-postgres:5432/postgres -e QUARKUS_DATASOURCE_USERNAME=myuser -e QUARKUS_DATASOURCE_PASSWORD=mypassword my-backend

docker build -t my-frontend ./frontend
docker run -d --name my-frontend -p 4200:4200 my-frontend

docker network create my-red
docker network connect my-red my-frontend
docker network connect my-red my-backend
docker network connect my-red my-postgres
