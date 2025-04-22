@echo off
setlocal enabledelayedexpansion

echo Desconectando contenedores de la red...
docker network disconnect my-red my-frontend
docker network disconnect my-red my-backend
docker network disconnect my-red my-postgres

timeout /t 5 /nobreak > nul

echo Eliminando red my-red...
docker network rm my-red

timeout /t 5 /nobreak > nul

echo Eliminando contenedor my-postgres...
docker stop my-postgres
docker rm my-postgres
docker rmi -f my-postgres
docker volume rm pgdata

timeout /t 5 /nobreak > nul

echo Eliminando contenedor my-backend...
docker stop my-backend
docker rm my-backend
docker rmi -f my-backend

timeout /t 5 /nobreak > nul

echo Eliminando contenedor my-frontend...
docker stop my-frontend
docker rm my-frontend
docker rmi -f my-frontend

echo Finalizado.
