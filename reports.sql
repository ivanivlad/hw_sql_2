--1. Посчитать количество заказов за все время
select count(*)
from public.orders

--2. Посчитать сумму по всем заказам за все время (учитывая скидки)
select sum(cast(unit_price as numeric(15,2)) * quantity - cast(discount as numeric(15,2)))
from public.order_details

-- 3. Показать сколько сотрудников работает в каждом городе.
select city, count(*)
from public.employees
group by city

--4. Выявить самый продаваемый товар в штуках. Вывести имя продукта и его количество.
select pro.product_name, sales.total_quantity
from 
(select product_id as product_id, sum(quantity) as total_quantity
	from public.order_details
	group by product_id
	order by total_quantity desc
	Limit 1) as sales
left join public.products as pro on pro.product_id = sales.product_id

-- 5. Выявить фио сотрудника, у которого сумма всех заказов самая маленькая
select empl.first_name ||''|| empl.last_name as empl_fio,
	COALESCE(sales_by_empl.total_amount, 0) as amount
from 
public.employees as empl 
left join (
	select ord.employee_id, sales.total_amount
	from(
		select order_id, sum(cast(unit_price as numeric(15,2)) * quantity - cast(discount as numeric(15,2))) as total_amount
		from public.order_details
		group by order_id) as sales
	inner join public.orders as ord on ord.order_id = sales.order_id
	 ) as sales_by_empl
on empl.employee_id = sales_by_empl.employee_id
order by amount asc
limit 1
