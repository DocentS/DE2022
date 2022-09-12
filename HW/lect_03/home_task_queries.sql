/*
 Завдання на SQL до лекції 02.
 */


/*
1.
Вивести кількість фільмів в кожній категорії.
Результат відсортувати за спаданням.
*/
select c."name" as category_name, count(*) as count_films
from film_category as fc
left outer join category as c 
	on c.category_id = fc.category_id 
group by c."name" 
order by count(*) desc  

/*
2.
Вивести 10 акторів, чиї фільми брали на прокат найбільше.
Результат відсортувати за спаданням.
*/
select a.first_name, a.last_name, count(p.payment_id) as rent_count 
from payment as p
join rental as r 
	on p.rental_id = r.rental_id
join inventory as i 
	on r.inventory_id = i.inventory_id 
join film as f 
	on i.film_id = f.film_id
join film_actor as fa
	on f.film_id = fa.film_id 
join actor as a 
	on fa.actor_id = a.actor_id 
group by a.first_name, a.last_name
order by count(p.payment_id) desc 
limit 10

/*
3.
Вивести категорія фільмів, на яку було витрачено найбільше грошей
в прокаті
*/
select c."name" as category_name, sum(p.amount) as total_sales
from payment as p
join rental as r 
	on p.rental_id = r.rental_id
join inventory as i 
	on r.inventory_id = i.inventory_id 
join film as f 
	on i.film_id = f.film_id
join film_category as fc 
	on f.film_id = fc.film_id
join category as c 
	on fc.category_id = c.category_id 
group by c."name" 
order by sum(p.amount) desc 
limit 1


/*
4.
Вивести назви фільмів, яких не має в inventory.
Запит має бути без оператора IN
*/
select f.title 
from film as f 
left outer join inventory as i
	on f.film_id = i.film_id
where i.inventory_id is null 


/*
5.
Вивести топ 3 актори, які найбільше зʼявлялись в категорії фільмів “Children”.
*/

/*
 TOP 3 мало би бути по кількості фільмів з заданою категорією, 
 а акторів вибирати вже тих хто потрапляє в тей TOP.
 Інакше - як вибрати одного серед акторів, у яких кількість фільмів з заданої категорії однакова?
*/
with cte as (
	select a.first_name, a.last_name
		, c."name" as film_category
		, count(f.film_id) as films_count
		, dense_rank () over (order by count(f.film_id) desc) as rn
	from film_category as fc
	join category as c 
		on fc.category_id = c.category_id
	join film as f 
		on fc.film_id = f.film_id 	
	join film_actor as fa
		on f.film_id = fa.film_id
	join actor as a 
		on fa.actor_id = a.actor_id
	where c."name" = 'Children' 
	group by a.first_name, a.last_name, c."name"
)
select c.first_name, c.last_name, c.film_category, c.films_count
from cte as c
where c.rn <= 3
order by c.films_count desc, c.first_name, c.last_name

	
/*
6.
Вивести міста з кількістю активних та неактивних клієнтів
(в активних customer.active = 1).
Результат відсортувати за кількістю неактивних клієнтів за спаданням.
*/
select c.city, cu.active, count(*) as active_count
from customer as cu
join address as a 
	on cu.address_id = a.address_id
join city as c 
	on a.city_id = c.city_id 
group by c.city, cu.active 
order by cu.active asc, count(*) desc

