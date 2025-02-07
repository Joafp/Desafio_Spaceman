-- Creacion de tablas

CREATE TABLE maestros.sectores (
    id_sector INT NOT NULL,
    idcadena INT NOT NULL,
    sector VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_sector, idcadena) -- Clave primaria compuesta
);

CREATE TABLE maestros.secciones (
    id_seccion INT NOT NULL,
    idcadena INT NOT NULL,
    seccion VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_seccion, idcadena) -- Clave primaria compuesta
);

CREATE TABLE maestros.subcategorias (
    id_subcategoria INT NOT NULL,
    idcadena INT NOT NULL,
    subcategoria VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_subcategoria, idcadena) -- Clave primaria compuesta
);
CREATE TABLE maestros.categorias (
    id_categoria INT NOT NULL,
    idcadena INT NOT NULL,
    categoria VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_categoria, idcadena) -- Clave primaria compuesta
);
CREATE TABLE maestros.productos (
    id BIGSERIAL PRIMARY KEY,  
    idcadena BIGINT NOT NULL,   
    eancode BIGINT NOT NULL,    
    descripcion VARCHAR(255),
    id_sector BIGINT NOT NULL,  
    id_seccion BIGINT NOT NULL, 
    id_categoria BIGINT NOT NULL, 
    id_subcategoria BIGINT NOT NULL, 
    fabricante VARCHAR(255),
    marca VARCHAR(255),
    contenido FLOAT,
    pesovolumen FLOAT,
    unidadmedida VARCHAR(50),
    ultmodificacion VARCHAR(50),
    granfamilia VARCHAR(255),
    familia VARCHAR(255),
    -- Relaciones con claves foráneas compuestas
    CONSTRAINT fk_producto_sector FOREIGN KEY (id_sector, idcadena) 
        REFERENCES maestros.sectores (id_sector, idcadena),
    CONSTRAINT fk_producto_seccion FOREIGN KEY (id_seccion, idcadena) 
        REFERENCES maestros.secciones (id_seccion, idcadena),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria, idcadena) 
        REFERENCES maestros.categorias (id_categoria, idcadena),
    CONSTRAINT fk_producto_subcategoria FOREIGN KEY (id_subcategoria, idcadena) 
        REFERENCES maestros.subcategorias (id_subcategoria, idcadena)
);



CREATE TABLE maestros.tickets (
    id SERIAL PRIMARY KEY,
    punto INT NOT NULL,
    ticket VARCHAR(50) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME ,
    eancode BIGINT NOT NULL,
    ean_desc VARCHAR(255) NOT NULL,
    unidades_vendidas FLOAT NOT NULL,
    precio_regular DECIMAL(10,2),
    precio_promocional DECIMAL(10,2),
    tipo_venta VARCHAR(50),
    idcadena INT NOT NULL,
    ultmodificacion VARCHAR(50),
    anulado BOOLEAN DEFAULT FALSE
);

