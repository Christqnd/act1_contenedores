#!/bin/bash
set -e

echo
echo "===== EJECUTANDO LIMPIEZA PREVIA ====="
./clean-all.sh

echo
echo "===== CONSTRUYENDO E INICIANDO CONTENEDOR DE POSTGRES ====="
docker build -t my-database ./database
docker run -d --name my-database \
  -e POSTGRES_DB=postgres \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  -v pgdata:/var/lib/postgresql/data \
  -p 5432:5432 \
  my-database

echo
echo "===== CONSTRUYENDO E INICIANDO BACKEND ====="
docker build -t my-backend ./backend
docker run -d --name my-backend \
  -p 8080:8080 \
  -e QUARKUS_DATASOURCE_JDBC_URL=jdbc:postgresql://my-database:5432/postgres \
  -e QUARKUS_DATASOURCE_USERNAME=myuser \
  -e QUARKUS_DATASOURCE_PASSWORD=mypassword \
  my-backend

echo
echo "===== CONSTRUYENDO E INICIANDO FRONTEND ====="
docker build -t my-frontend ./frontend
docker run -d --name my-frontend \
  -p 4200:4200 \
  my-frontend

echo
echo "===== CREANDO Y CONECTANDO RED DOCKER ====="
docker network create my-red || true
docker network connect my-red my-frontend || true
docker network connect my-red my-backend || true
docker network connect my-red my-database || true

echo
echo "===== SUBIENDO IMAGENES A DOCKER HUB ====="
echo "Logueando en Docker Hub..."
docker login -u christqnd2409 -p CrisQnd1992

docker tag my-database christqnd2409/my-database:latest
docker tag my-backend christqnd2409/my-backend:latest
docker tag my-frontend christqnd2409/my-frontend:latest

docker push christqnd2409/my-database:latest
docker push christqnd2409/my-backend:latest
docker push christqnd2409/my-frontend:latest

echo
echo "===== DESPLIEGUE Y PUBLICACION COMPLETADOS ====="
