from sqlalchemy import create_engine,text
import os
from dotenv import load_dotenv


load_dotenv()
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = "spaceman"  # Nombre de la base de datos que deseas crear

# Crear la URL de conexión sin especificar la base de datos
DATABASE_POSTGRES_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/postgres"

### Crear la base de datos
# Crear el engine para conectarse a PostgreSQL sin especificar una base de datos
engine = create_engine(DATABASE_POSTGRES_URL)

try:
    with engine.connect() as connection:
        connection.execute(text("COMMIT"))  # Necesario antes de crear la base de datos
        connection.execute(text(f"CREATE DATABASE {DB_NAME}"))
        print(f"Base de datos '{DB_NAME}' creada exitosamente.")
except Exception as e:
    print(f"Error al crear la base de datos '{DB_NAME}':", e)
finally:
    engine.dispose()  # Cierra la conexión
### Conectarme a la base de datos spaceman
# Crear la URL de conexión apuntando a la base de datos 'spaceman'
DATABASE_SPACEMAN_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# Crear el engine con la base de datos correcta
engine = create_engine(DATABASE_SPACEMAN_URL)

try:
    with engine.connect() as connection:
        connection.execute(text("COMMIT"))  # Asegura que no haya transacciones pendientes
        connection.execute(text("CREATE SCHEMA IF NOT EXISTS maestros;"))
        print("Esquema 'maestros' creado exitosamente.")
except Exception as e:
    print("Error al crear el esquema 'maestros':", e)
finally:
    engine.dispose()  # Cierra la conexión
### Crear tablas
# Leer el archivo SQL
try:
    with open("creacion_tablas.sql", "r", encoding="utf-8") as file:
        sql_script = file.read()
except Exception as e:
    print("Error al leer el archivo SQL:", e)
    exit()

# Crear las tablas en la base de datos 'spaceman'
engine = create_engine(DATABASE_SPACEMAN_URL)

try:
    with engine.connect() as connection:
        connection.execute(text(sql_script))
        connection.commit()  # Importante para aplicar los cambios
        print("Tablas creadas exitosamente.")
except Exception as e:
    print("Error al ejecutar el script SQL:", e)
finally:
    engine.dispose()  # Cierra la conexión

