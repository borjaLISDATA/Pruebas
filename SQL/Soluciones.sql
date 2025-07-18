
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

select s.first_name, s.last_name, count(p.payment_id) as total_de_ventas , sum(p.amount) as cantidad_total, to_char(p.payment_date,'mon/YYYY') as fecha from staff s 
join payment p on s.staff_id = p.staff_id 
where s.staff_id = 345 and extract(year from p.payment_date) = 2022
group by(s.staff_id, to_char(p.payment_date,'mon/YYYY'));


-- Obtener un listado en el que se muestren el total acumulado de los pagos realizados por cada cliente hasta la fecha de cada uno de los pagos.
-- Es decir, en cada fila de la consulta debes mostrar cada uno de los pagos y una columna adicional con la cantidad total pagada por el cliente
-- (no mezclar pagos de otros clientes), hasta la fecha del pago actual, incluyendo este último.

create or replace function total_cliente_fecha(cliente_id int, fecha timestamp) returns float as
$$select sum(amount) as cantidad from payment where customer_id = cliente_id and payment_date between '2000-01-01 00:00:00' and fecha$$
language sql;


select c.first_name, c.last_name, p.payment_date, p.amount as importe , total_cliente_fecha(c.customer_id, p.payment_date) as total_gastado
from customer c join payment p on c.customer_id =p.customer_id order by(c.first_name, c.last_name, p.payment_date);


-- Usando una consulta SQL, obtén un listado que contenga el número de películas que existen en el sistema para cada pareja de categoría
-- (identificada por su nombre) e idioma (también por su nombre) existentes.

select c.name, l."name", sum(f.film_id) as total_pelis
from language l join film f on l.language_id =f.film_id 
				join film_category fc on f.film_id = fc.film_id 
				join category c on fc.category_id =c.category_id
group by(c.category_id,l.language_id);