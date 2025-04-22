#!/bin/bash
set -e

echo
echo "===== LIMPIANDO RECURSOS PREVIOS ====="
./clean-all.sh

echo
echo "===== INICIANDO CONTENEDOR DE POSTGRES ====="
docker run --name my-postgres -e POSTGRES_DB=postgres -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -v pgdata:/var/lib/postgresql/data -p 5432:5432 -d postgres:latest

echo "Esperando a que PostgreSQL esté listo..."
until docker exec my-postgres pg_isready -U myuser > /dev/null 2>&1; do
  sleep 1
done

echo
echo "===== INYECTANDO SCRIPT INIT.SQL ====="
docker cp init.sql my-postgres:/init.sql
docker exec -it my-postgres psql -U myuser -d postgres -f /init.sql

echo
echo "===== CONSTRUYENDO E INICIANDO BACKEND ====="
docker build -t my-backend ./backend
docker run -d --name my-backend -p 8080:8080 \
  -e QUARKUS_DATASOURCE_JDBC_URL=jdbc:postgresql://my-postgres:5432/postgres \
  -e QUARKUS_DATASOURCE_USERNAME=myuser \
  -e QUARKUS_DATASOURCE_PASSWORD=mypassword \
  my-backend

echo
echo "===== CONSTRUYENDO E INICIANDO FRONTEND ====="
docker build -t my-frontend ./frontend
docker run -d --name my-frontend -p 4200:4200 my-frontend

echo
echo "===== CREANDO Y CONECTANDO RED DOCKER ====="
docker network create my-red || true
docker network connect my-red my-frontend || true
docker network connect my-red my-backend || true
docker network connect my-red my-postgres || true

echo
echo "===== DESPLIEGUE COMPLETO ====="
