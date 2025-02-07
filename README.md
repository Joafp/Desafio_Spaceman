# Proyecto de Análisis de Datos con PostgreSQL

## Instalación y Configuración

Para poder ejecutar correctamente los códigos, primero debe instalar las dependencias necesarias ejecutando:

```bash
pip install -r requirements.txt
```

Luego, debe crear un archivo `.env` en la ruta principal del proyecto con los datos de conexión a PostgreSQL:

```ini
# Configuración de PostgreSQL
DB_USER=
DB_PASSWORD=
DB_HOST=
DB_PORT=
```

## Estructura del Proyecto

El proyecto sigue el siguiente flujo de trabajo:

1. **Carpeta `Data`**: Se debe crear una carpeta llamada `Data`, donde se podrán almacenar archivos si se desean usar directamente.

2. **Extracción de datos**: Se encuentra en el notebook `Extraccion.ipynb`, en el cual realizamos web scraping de la página donde se encuentran los archivos utilizando Selenium.

3. **Creación de la base de datos**: Se ejecuta el script `creacion_db.ipynb`, que además de crear la base de datos, genera las tablas normalizadas correspondientes.

4. **Proceso ETL**: Se ejecuta el notebook `ETL.ipynb`, donde realizamos la transformación de los datos y los cargamos en la base de datos.

5. **Generación de vistas y consultas**: Finalmente, se ejecutan los notebooks `Vistas.ipynb` y `Consultas.ipynb`, que permiten generar vistas y ejecutar consultas relevantes para el análisis de los datos.

