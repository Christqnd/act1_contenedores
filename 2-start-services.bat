@echo off
echo.
echo ===== EJECUTANDO LIMPIEZA PREVIA =====
call clean-all.bat

echo.
echo ===== INICIANDO CONTENEDORES DESDE DOCKER HUB =====

echo.
echo --- PostgreSQL ---
docker pull christqnd2409/my-database:latest
docker run -d --name my-database ^
  -e POSTGRES_DB=postgres ^
  -e POSTGRES_USER=myuser ^
  -e POSTGRES_PASSWORD=mypassword ^
  -v pgdata:/var/lib/postgresql/data ^
  -p 5432:5432 ^
  christqnd2409/my-database:latest

echo.
echo --- Backend (Quarkus) ---
docker pull christqnd2409/my-backend:latest
docker run -d --name my-backend ^
  -p 8080:8080 ^
  -e QUARKUS_DATASOURCE_JDBC_URL=jdbc:postgresql://my-database:5432/postgres ^
  -e QUARKUS_DATASOURCE_USERNAME=myuser ^
  -e QUARKUS_DATASOURCE_PASSWORD=mypassword ^
  christqnd2409/my-backend:latest

echo.
echo --- Frontend (Angular) ---
docker pull christqnd2409/my-frontend:latest
docker run -d --name my-frontend ^
  -p 4200:4200 ^
  christqnd2409/my-frontend:latest

echo.
echo ===== CREANDO Y CONECTANDO RED DOCKER =====
docker network create my-red
docker network connect my-red my-frontend
docker network connect my-red my-backend
docker network connect my-red my-database

echo.
echo ===== CONTENEDORES DESPLEGADOS DESDE DOCKER HUB =====
