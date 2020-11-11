
    -- Lab | SQL Iterations
    
    use sakila;
    
    -- Write a query to find what is the total business done by each store.
    -- 1
  
    select s.store_id, count(r.rental_id) as num_rentals from store s
    join inventory i
    on s.store_id=i.store_id
    join rental r
    on i.inventory_id=r.inventory_id
    group by s.store_id;
    
    
    
    
    
    
    -- Convert the previous query into a stored procedure.
    
    -- 2- 
    
drop procedure if exists store_rentals;
delimiter //
create procedure store_rentals ()
begin    
select s.store_id, count(r.rental_id) as num_rentals from store s
join inventory i
on s.store_id=i.store_id
join rental r
on i.inventory_id=r.inventory_id

group by s.store_id;
    
end
//
delimiter ;

call store_rentals();


    
    

    
    -- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

drop procedure if exists store_rentals;
delimiter //
create procedure store_rentals (in param1 int)
begin    
select s.store_id, count(r.rental_id) as num_rentals from store s
join inventory i
on s.store_id=i.store_id
join rental r
on i.inventory_id=r.inventory_id
where s.store_id=param1  
group by s.store_id;
    
end
//
delimiter ;

call store_rentals(1);
call store_rentals(2);
    
    
    
    -- Update the previous query. Declare a variable total_sales_value of float type, 
    -- that will store the returned result (of the total sales amount for the store). 
    -- Call the stored procedure and print the results.
    
drop procedure if exists store_sales;

delimiter //

create procedure store_sales (in store_name int)
begin   

declare total_sales_value float default 0.0;
 
select sum(p.amount) into total_sales_value from store s
join inventory i
on s.store_id=i.store_id
join rental r
on i.inventory_id=r.inventory_id
join payment p
on r.rental_id=p.rental_id
where s.store_id=store_name  
group by s.store_id;
select store_name,total_sales_value;
    
end
//
delimiter ;

call store_sales(1);
call store_sales(2);
    
  
    
    
    
    -- In the previous query, add another variable flag. 
    -- If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
    -- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.
    
drop procedure if exists store_sales_flag;

delimiter //

create procedure store_sales_flag (in store_name int, out flag_color varchar(50))
begin   

declare total_sales_value float default 0.0;
declare flag varchar(50) default "";

select sum(p.amount) into total_sales_value from store s
join inventory i
on s.store_id=i.store_id
join rental r
on i.inventory_id=r.inventory_id
join payment p
on r.rental_id=p.rental_id
where s.store_id=store_name  
group by s.store_id;
case
    when total_sales_value > 30000 then
      set flag = 'green_flag';
  else
    set flag = 'red_flag';
  end case;  
  select flag into flag_color;

select store_name,total_sales_value,flag_color;
    
end
//
delimiter ;

call store_sales_flag(1,@x);
call store_sales_flag(2,@x);
    
