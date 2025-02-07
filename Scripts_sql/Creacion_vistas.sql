
CREATE or replace  VIEW maestros.ventas_por_categoria AS
SELECT 
    c.categoria,
    SUM(t.unidades_vendidas) AS total_productos_vendidos
FROM maestros.tickets t
JOIN maestros.productos p 
    ON t.eancode = p.eancode 
    AND t.idcadena = p.idcadena  
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
