--PRE-ENTREGA MODULO 4: 
--Archivo: pre-entrega-modulo4.sql

--Se crea tabla categorías debido a que no existía y se agregan las 4 categorías existentes.


create table if not exists categorias(id_categoria serial primary key,
nombre VARCHAR (50) not null unique);

insert INTO categorias (nombre) values
   ('Electrodomésticos'), ('Bazar'), ('Hogar'), ('Accesorios') 
   on conflict (nombre) do nothing; 

select *from categorias; 


--1) Rentabilidad por categoría: Se obtiene el monto total vendido de las categorías --cuyas ventas hayan superado los 50000 que representa el piso de facturación esperado a fin de mantener stock de los productos más vendidos.

SELECT
cat.nombre as categoria,
SUM(V.cantidad) as cantidad_vendida,
SUM(V.monto) as monto_total
from ventas as V
left join productos as P on V.id_producto=P.id_producto
left join categorias as cat on p.categoria=cat.nombre
group by cat.nombre;


--2) Clientes sin compras: Identificar clientes registrados que no realizaron ninguna compra en los últimos 6 meses para dirigir campañas de marketing para atraerlos (por ejemplo, con cupones con descuentos importantes en la próxima compra).

SELECT 
c.id_cliente,
c.nombre AS cliente, 
COALESCE(c.email, 'Sin contacto') AS email, 
COALESCE(SUM(v. monto), 0) AS total_comprado
From clientes AS c
LEFT JOIN ventas as v ON v. id_cliente=c.id_cliente
WHERE v.id_venta is NULL
Group By c.id_cliente, c.nombre, c.email
Order by c.nombre ASC; 


 --3) "Top de compras por cliente":  identificar el producto más comprado de cada cliente y su ultima compra para ver estrategias de fidelización

SELECT 
    c.nombre AS cliente,
    (
        SELECT p2.nombre
        FROM ventas AS v2
        JOIN productos AS p2 ON v2.id_producto = p2.id_producto
        WHERE v2.id_cliente = c.id_cliente
        GROUP BY p2.id_producto, p2.nombre
        ORDER BY COUNT(*) DESC, SUM(v2.cantidad) DESC
        LIMIT 1
    ) AS producto_mas_comprado,
    MAX(v.fecha) AS ultima_transaccion
FROM clientes AS c
JOIN ventas AS v ON c.id_cliente = v.id_cliente
JOIN productos AS p ON v.id_producto = p.id_producto
GROUP BY c.id_cliente, c.nombre
ORDER BY ultima_transaccion DESC;

