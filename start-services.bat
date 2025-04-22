@echo off
setlocal enabledelayedexpansion
cd /d %~dp0

echo.
echo ===== LIMPIANDO RECURSOS PREVIOS =====
call clean-all.bat

echo.
echo ===== INICIANDO CONTENEDOR DE POSTGRES =====
docker run --name my-postgres -e POSTGRES_DB=postgres -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -v pgdata:/var/lib/postgresql/data -p 5432:5432 -d postgres:latest
IF ERRORLEVEL 1 (
    echo Error al iniciar contenedor de PostgreSQL.
    exit /b 1
)

echo Esperando a que PostgreSQL esté listo...
:wait_pg
docker exec my-postgres pg_isready -U myuser >nul 2>&1
IF ERRORLEVEL 1 (
    timeout /t 1 >nul
    goto wait_pg
)

echo.
echo ===== INYECTANDO SCRIPT INIT.SQL =====
docker cp init.sql my-postgres:/init.sql
docker exec -it my-postgres psql -U myuser -d postgres -f /init.sql

echo.
echo ===== CONSTRUYENDO E INICIANDO BACKEND =====
docker build -t my-backend ./backend
docker run -d --name my-backend -p 8080:8080 ^
    -e QUARKUS_DATASOURCE_JDBC_URL=jdbc:postgresql://my-postgres:5432/postgres ^
    -e QUARKUS_DATASOURCE_USERNAME=myuser ^
    -e QUARKUS_DATASOURCE_PASSWORD=mypassword ^
    my-backend

IF ERRORLEVEL 1 (
    echo Error al construir o iniciar el backend.
    exit /b 1
)

echo.
echo ===== CONSTRUYENDO E INICIANDO FRONTEND =====
docker build -t my-frontend ./frontend
docker run -d --name my-frontend -p 4200:4200 my-frontend

IF ERRORLEVEL 1 (
    echo Error al construir o iniciar el frontend.
    exit /b 1
)

echo.
echo ===== CREANDO Y CONECTANDO RED DOCKER =====
docker network create my-red
docker network connect my-red my-frontend
docker network connect my-red my-backend
docker network connect my-red my-postgres

echo.
echo ===== DESPLIEGUE COMPLETO =====
endlocal
