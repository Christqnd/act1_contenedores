# Act1 Contenedores

Este proyecto despliega una aplicación compuesta por tres servicios principales utilizando Docker:

- **Base de datos PostgreSQL**
- **Backend desarrollado con Quarkus**
- **Frontend construido con Angular**

Los servicios están interconectados mediante una red Docker personalizada, facilitando la comunicación entre ellos.

## Tecnologías Utilizadas

- [Docker](https://www.docker.com/): Contenerización de servicios.
- [PostgreSQL](https://www.postgresql.org/): Base de datos relacional.
- [Quarkus](https://quarkus.io/): Framework para el backend.
- [Angular](https://angular.io/): Framework para el frontend.

## Requisitos Previos

- Tener instalado [Docker](https://docs.docker.com/get-docker/).
- Opcionalmente, tener instalado [Docker Compose](https://docs.docker.com/compose/install/) si se desea utilizar `docker-compose`.

## Estructura del Proyecto

El repositorio está organizado de la siguiente manera:

```
├── backend/             # Código fuente del backend (Quarkus)
├── frontend/            # Código fuente del frontend (Angular)
├── database/            # Archivos relacionados con la base de datos PostgreSQL
├── 1-start-services.sh  # Script para iniciar los servicios (versión simple)
├── 2-start-services.sh  # Script para iniciar los servicios con opciones adicionales
├── clean-all.sh         # Script para detener y eliminar los contenedores y redes
├── README.md            # Documentación del proyecto
└── ...
```

## Instrucciones de Uso

### Clonar el Repositorio

```bash
git clone https://github.com/Christqnd/act1_contenedores.git
cd act1_contenedores
```

### Iniciar los Servicios

Para iniciar los servicios, puedes utilizar uno de los scripts proporcionados:

```bash
./1-start-services.sh
```

Este script construirá las imágenes necesarias y levantará los contenedores correspondientes.

### Acceder a la Aplicación

- **Frontend (Angular)**: [http://localhost:4200](http://localhost:4200)
- **Backend (Quarkus)**: [http://localhost:8080](http://localhost:8080)
- **Base de Datos (PostgreSQL)**: Accesible en el puerto `5432`

### Detener y Limpiar los Servicios

Para detener y eliminar los contenedores, redes e imágenes creadas, ejecuta:

```bash
./clean-all.sh
```

## Contribuciones

Las contribuciones son bienvenidas. Si deseas mejorar este proyecto, por favor realiza un fork del repositorio y envía un pull request con tus cambios.

## Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más información.