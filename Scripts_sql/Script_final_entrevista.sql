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
    id BIGSERIAL PRIMARY KEY,  -- Usamos BIGSERIAL para manejar valores más grandes
    idcadena BIGINT NOT NULL,   -- Cambiamos idcadena a BIGINT
    eancode BIGINT NOT NULL,    -- Cambiamos eancode a BIGINT
    descripcion VARCHAR(255),
    id_sector BIGINT NOT NULL,  -- Cambiamos id_sector a BIGINT
    id_seccion BIGINT NOT NULL, -- Cambiamos id_seccion a BIGINT
    id_categoria BIGINT NOT NULL, -- Cambiamos id_categoria a BIGINT
    id_subcategoria BIGINT NOT NULL, -- Cambiamos id_subcategoria a BIGINT
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



-- Vistas


CREATE or replace  VIEW maestros.ventas_por_categoria AS
SELECT 
    c.categoria,
    SUM(t.unidades_vendidas) AS total_productos_vendidos
FROM maestros.tickets t
JOIN maestros.productos p 
    ON t.eancode = p.eancode 
    AND t.idcadena = p.idcadena  -- Se asegura que sean de la misma cadena
JOIN maestros.categorias c 
    ON p.id_categoria = c.id_categoria 
    AND p.idcadena = c.idcadena
WHERE t.anulado = FALSE  -- Se excluyen los tickets anulados
GROUP BY c.categoria;




create or replace VIEW maestros.ventas_dias AS
SELECT 
    t.fecha,
    SUM(t.unidades_vendidas * COALESCE(t.precio_promocional, t.precio_regular)) AS facturacion_total,
    SUM(t.unidades_vendidas) AS total_productos_vendidos,
    COUNT(DISTINCT t.ticket) AS total_tickets
FROM maestros.tickets t
WHERE t.anulado = FALSE  -- Se excluyen los tickets anulados
GROUP BY t.fecha
ORDER BY t.fecha;



--Consultas
--Pregunta 1
WITH max_fecha AS (
    SELECT MAX(fecha) AS fecha_max FROM maestros.tickets
)
SELECT 
    p.descripcion, 
    SUM(t.unidades_vendidas) AS total_vendido
FROM maestros.tickets t
JOIN maestros.productos p 
    ON t.eancode = p.eancode 
    AND t.idcadena = p.idcadena
JOIN max_fecha mf 
    ON t.fecha >= mf.fecha_max - INTERVAL '1 month'  -- Último mes basado en la fecha máxima
WHERE t.anulado = FALSE 
GROUP BY p.descripcion
ORDER BY total_vendido DESC
LIMIT 5;


--Pregunta 2
WITH max_fecha AS (
    SELECT MAX(fecha) AS fecha_max FROM maestros.tickets
)
SELECT 
    c.categoria, 
    SUM(t.unidades_vendidas * COALESCE(t.precio_promocional, t.precio_regular)) AS total_ingresos
FROM maestros.tickets t
JOIN maestros.productos p 
    ON t.eancode = p.eancode 
    AND t.idcadena = p.idcadena
JOIN maestros.categorias c 
    ON p.id_categoria = c.id_categoria 
    AND p.idcadena = c.idcadena
JOIN max_fecha mf 
    ON t.fecha >= mf.fecha_max - INTERVAL '3 weeks'  -- Últimas 3 semanas desde la fecha máxima
WHERE t.anulado = FALSE 
GROUP BY c.categoria
ORDER BY total_ingresos DESC;

--Pregunta 3

SELECT 
    t.fecha, 
    SUM(t.unidades_vendidas * COALESCE(t.precio_promocional, t.precio_regular)) AS total_facturado,
    COUNT(DISTINCT t.ticket) AS total_tickets
FROM maestros.tickets t
WHERE t.anulado = FALSE
GROUP BY t.fecha
ORDER BY total_facturado DESC, total_tickets DESC
LIMIT 10;  -- Muestra los 10 días con mayores ventas

--Pregunta 4


SELECT DISTINCT ON (t.punto) 
    t.punto AS sucursal,
    c.categoria, 
    SUM(t.unidades_vendidas) AS total_vendido
FROM maestros.tickets t
JOIN maestros.productos p 
    ON t.eancode = p.eancode 
    AND t.idcadena = p.idcadena
JOIN maestros.categorias c 
    ON p.id_categoria = c.id_categoria 
    AND p.idcadena = c.idcadena
WHERE t.anulado = FALSE
GROUP BY t.punto, c.categoria
ORDER BY t.punto, total_vendido DESC;





