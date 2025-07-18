
-- Consigue un listado de clientes han gastado más 110€ en total de entre todos los alquileres que han realizado.
-- Es decir, un cliente puede haber realizado 20 compras de 10€ a lo largo del tiempo, y por lo tanto debe aparecer en el listado. 
-- El listado debe contener el nombre y apellido del cliente y la cantidad total gastada por cada uno de ellos.

select c.first_name, c.last_name, sum(p.amount) as cantidad_total from payment p
join customer c on p.customer_id = c.customer_id
group by(c.customer_id, p.customer_id) having sum(p.amount)> 110;


-- ¿Podrías sacar un listado de todos los clientes que están dados de alta en el comercio, pero nunca hicieron ninguna compra?

select c.first_name, c.last_name from customer c  where c.customer_id not in (select c.customer_id from customer c inner join payment p on c.customer_id = p.customer_id );


-- Para pagar las comisiones por el empleado 345, necesitamos las ventas del año 2022 realizadas por dicho empleado desglosadas por meses.
-- ¿Podrías obtener dicha información?

select staff_id, count(payment_id) as total_de_ventas , sum(amount) as cantidad_total, to_char(payment_date,'mon') as fecha 
FROM payment
where staff_id = 345 and extract(year from payment_date) = 2022
group by(staff_id, to_char(payment_date,'mon'));


-- Obtener un listado en el que se muestren el total acumulado de los pagos realizados por cada cliente hasta la fecha de cada uno de los pagos.
-- Es decir, en cada fila de la consulta debes mostrar cada uno de los pagos y una columna adicional con la cantidad total pagada por el cliente
-- (no mezclar pagos de otros clientes), hasta la fecha del pago actual, incluyendo este último.

select c.first_name, c.last_name, p.payment_date, p.amount as importe, sum(amount) OVER(partition by c.customer_id order by p.payment_date asc) as total_gastado
from customer c join payment p on c.customer_id =p.customer_id order by(c.first_name, c.last_name, p.payment_date);


-- Usando una consulta SQL, obtén un listado que contenga el número de películas que existen en el sistema para cada pareja de categoría
-- (identificada por su nombre) e idioma (también por su nombre) existentes.

select c.name as Categoria, l.name as Idioma, count(f.film_id) as Numpelis
from language l join film f on l.language_id =f.language_id 
				join film_category fc on f.film_id = fc.film_id 
				join category c on fc.category_id =c.category_id
group by(c.category_id,l.language_id);

-- Para ver si la suma de los valores NumPelis da el total de peliculas hay que ver si existe alguna pelicula que no tenga asignada una categoria o idioma
select * from film f where f.film_id 
not in(select film_id from film_category) or
f.language_id is null;
-- La lista es vacia por lo que todas las pelis tienen un idioma asignado y una categoria, lo que demuestra que la suma de los valores NumPelis es el total de peliculas

