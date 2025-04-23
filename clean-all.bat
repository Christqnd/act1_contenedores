@echo off
setlocal enabledelayedexpansion

echo Desconectando contenedores de la red...
docker network disconnect my-red my-frontend
docker network disconnect my-red my-backend
docker network disconnect my-red my-database

timeout /t 5 /nobreak > nul

echo Eliminando red my-red...
docker network rm my-red

timeout /t 5 /nobreak > nul

echo Eliminando contenedor my-database...
docker stop my-database
docker rm my-database
docker rmi -f my-database

echo Eliminando contenedor christqnd2409/my-database...
docker stop christqnd2409/my-database
docker rm christqnd2409/my-database
docker rmi -f christqnd2409/my-database

docker volume rm pgdata

timeout /t 5 /nobreak > nul

echo Eliminando contenedor my-backend...
docker stop my-backend
docker rm my-backend
docker rmi -f my-backend

echo Eliminando contenedor christqnd2409/my-backend...
docker stop christqnd2409/my-backend
docker rm christqnd2409/my-backend
docker rmi -f christqnd2409/my-backend

timeout /t 5 /nobreak > nul

echo Eliminando contenedor my-frontend...
docker stop my-frontend
docker rm my-frontend
docker rmi -f my-frontend

echo Eliminando contenedor christqnd2409/my-frontend...
docker stop christqnd2409/my-frontend
docker rm christqnd2409/my-frontend
docker rmi -f christqnd2409/my-frontend

echo Finalizado.
