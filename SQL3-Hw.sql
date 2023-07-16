--Question 1 Find all customers from Texas
--explore customer data
select * from customer;
--explore address data (to see what the address_id gives)
select * from address; -- district is state
--connect customer to address (reference district for state)
select customer_id, first_name, last_name, district
from customer
inner join address 
on customer.address_id = address.address_id
where district = 'Texas';

--Question 2 All payments above $6.99 with customer full name
--explore customer data
select * from customer;
--explore payment data (to see how to connect customer to payment(likely some purchase id))
select * from payment; --connects directly to customer
--Create joined table with customer and payment
select first_name, last_name, amount, payment_id
from customer
inner join payment 
on customer.customer_id = payment.customer_id; 
--Add a filter to only include payments over $6.99 
select first_name, last_name, amount, payment_id --included payment_id to i could confirm amounts were actually from differnt payments
from customer
inner join payment 
on customer.customer_id = payment.customer_id
where amount > 6.99;  

--Question 3 All customers who have at least one payment above $175 with customer full name
--create sub query that finds all people who have individual payments over $175 (from prev query know its 2 people across 3 payments)
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
select customer_id
from payment
where amount > 175);  

--add a join so I can see the max payment of each of the customers that spent over $175
SELECT customer.first_name, customer.last_name, max(payment.amount)
FROM customer
inner join payment 
on customer.customer_id = payment.customer_id
WHERE customer.customer_id IN (
select customer_id
from payment
where amount > 175)
group by customer.first_name, customer.last_name;

--Question 4 list all customers from Nepal
--explore address data
select * from address;  --has a city_id and an address_id
--explore city data 
select * from city
--we need to connect customer's address to city_id in address, to country_id in city, to country
select first_name, last_name, address, country
from customer
inner join address
on customer.address_id = address.address_id
inner join city 
on address.city_id = city.city_id
inner join country 
on city.country_id = country.country_id
where country = 'Nepal' ;

--Question 5 which staff member has the most transaction (staff or salesperson)
--exploration of tables
select * from staff;
select * from salesperson;
select * from purchase;  --has salesperson id (but only 3 transactions)
select * from payment; -- has staff_id
--join staff and payment tables 
select first_name, last_name, amount
from staff 
inner join payment 
on staff.staff_id = payment.staff_id;
-- group staff members with count of transactions
select first_name, last_name, count(amount)
from staff
inner join payment 
on staff.staff_id = payment.staff_id
group by first_name, last_name;

--Question 6 Count of each movie rating
--explore tables
select * from movies;
select * from movie;
select * from film; -- has a rating
-- count ratings
select rating, count(rating)
from film
group by rating;

--Question 7 list each customer with a payment over 6.99 (that means group customers to not show all payments)
--join the tables, filter by cost, group by names
select first_name, last_name 
from customer
inner join payment 
on customer.customer_id = payment.customer_id
where amount > 6.99
group by first_name, last_name; 

--Question 8 how many rentals did the stores give away
--explore tables
select * from rental;
select * from payment;
--build joint table with amount and rental_id
select rental.rental_id, amount
from rental
left join payment 
on rental.rental_id = payment.rental_id
order by amount desc;
-- count only null amounts
select amount, count(*) as null_count --need to do this instead of counting specifically amounts
from rental
full join payment 
on rental.rental_id = payment.rental_id
where amount is null --this is what limits the count* to just null values 
group by amount
;