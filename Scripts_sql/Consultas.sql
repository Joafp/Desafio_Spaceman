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
