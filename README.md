
# Act1 Contenedores

Este proyecto utiliza Docker para desplegar una aplicación que consta de tres contenedores: un contenedor para la base de datos PostgreSQL, un contenedor para el backend con Quarkus, y un contenedor para el frontend con Angular. Además, el proyecto incluye una red Docker para interconectar estos contenedores.

## Tecnologías Utilizadas

- **Docker**: Contenerización de servicios.
- **PostgreSQL**: Base de datos relacional.
- **Quarkus**: Framework para el backend.
- **Angular**: Framework para el frontend.

## Requisitos Previos

- **Docker**: Asegúrate de tener Docker instalado en tu máquina. Si no lo tienes, puedes seguir la guía oficial de instalación desde [aquí](https://docs.docker.com/get-docker/).

## Estructura del Proyecto

- **backend**: Contenedor para el backend utilizando Quarkus.
- **frontend**: Contenedor para el frontend utilizando Angular.
- **postgres**: Contenedor para la base de datos PostgreSQL.

## Instalación y Ejecución

1. **Ejecutar el script de limpieza** (opcional):

   Si deseas limpiar los contenedores anteriores, ejecuta el siguiente comando para eliminar contenedores previos:

   ```bash
   ./clean-all.sh
   ```

2. **Construir y ejecutar PostgreSQL**:

   Crea y ejecuta el contenedor de PostgreSQL:

   ```bash
   docker run --name my-postgres -e POSTGRES_DB=postgres -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -v pgdata:/var/lib/postgresql/data -p 5432:5432 -d postgres:latest
   ```

   Luego, copia el archivo `init.sql` al contenedor y ejecuta las instrucciones de la base de datos:

   ```bash
   docker cp init.sql my-postgres:/init.sql
   docker exec -it my-postgres psql -U myuser -d postgres -f /init.sql
   ```

3. **Construir y ejecutar el Backend**:

   Construye la imagen de Docker para el backend utilizando Quarkus:

   ```bash
   docker build -t my-backend ./backend
   ```

   Luego, ejecuta el contenedor:

   ```bash
   docker run -d --name my-backend -p 8080:8080 -e QUARKUS_DATASOURCE_JDBC_URL=jdbc:postgresql://my-postgres:5432/postgres -e QUARKUS_DATASOURCE_USERNAME=myuser -e QUARKUS_DATASOURCE_PASSWORD=mypassword my-backend
   ```

4. **Construir y ejecutar el Frontend**:

   Construye la imagen de Docker para el frontend utilizando Angular:

   ```bash
   docker build -t my-frontend ./frontend
   ```

   Luego, ejecuta el contenedor:

   ```bash
   docker run -d --name my-frontend -p 4200:4200 my-frontend
   ```

5. **Crear y conectar redes**:

   Crea una red Docker y conecta todos los contenedores a ella:

   ```bash
   docker network create my-red
   docker network connect my-red my-frontend
   docker network connect my-red my-backend
   docker network connect my-red my-postgres
   ```

## Problemas Comunes

- **Conexión entre contenedores**: Asegúrate de que los contenedores estén conectados a la misma red Docker.
- **Permisos de base de datos**: Si encuentras errores al acceder a la base de datos, revisa las credenciales y asegúrate de que los servicios estén correctamente configurados.

## Licencia

Este proyecto está bajo la Licencia MIT - consulta el archivo [LICENSE](LICENSE) para más detalles.
