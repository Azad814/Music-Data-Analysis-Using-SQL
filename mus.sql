use data_music;
select * from album2 ;
-- find the employee with highest level
select *  from employee 
order by levels desc
limit 1;

select count(1), billing_ country from invoice
group by billing_country
order by count(1) desc;

select * from invoice
order by total desc
limit 3;	
select billing_city, sum(total) as total 
from invoice 
group by billing_city
order by total desc;
select c.customer_id, c.first_name, c.last_name, sum(i.total) as total from customer c
join invoice i 
on c.customer_id = i.invoice_id
group by c.customer_id, c.first_name, c.last_name
order by total desc;


select * from genre;
select * from customer;

select email, first_name, last_name 
from customer
join invoice on  customer.customer_id= invoice.customer_id
join invoice_line on invoice.invoice_id= invoice_line.invoice_id
where track_id in (
select track_id 
from track
join genre on track.genre_id= genre.genre_id
where genre.name like 'Rock')
order by email;

select * from album2;
select * from artist;
select * from track;
select * from genre;

select artist.name, count(artist.artist_id)
from track  
join album2 on album2.album_id= track.album_id 
join artist on album2.artist_id=artist.artist_id
where track.genre_id=1
group by artist.artist_id, artist.name 
order by count(1) desc;


select name 
from track 
where milliseconds>(select avg(milliseconds) from track)
order by milliseconds desc;
select * from invoice;
select * from invoice_line;
select customer.first_name, artist.name, sum(invoice_line.unit_price*invoice_line.quantity)
from customer 
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id= invoice_line.invoice_id
join track on track.track_id = invoice_line.track_id
join album2  on album2.album_id= track.album_id
join artist on artist.artist_id = album2.album_id
group by customer.first_name, artist.name
order by 3 desc;


-- find out the most most popular music genre from each country 
-- determine the most popular genre based on highest amount of purchases 
with cte as (select invoice.billing_country, genre.name, count(invoice_line.quantity) as purchase, row_number() over(partition by invoice.billing_country, genre.name order by count(invoice_line.quantity) desc) as rankno
from invoice 
join invoice_line on invoice.invoice_id= invoice_line.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on track.genre_id = genre.genre_id
group by invoice.billing_country, genre.name
order by 1 asc, 3 desc)
select * from cte where rankno=1;

select *from  customer;
-- customer that spent the most on music from each country
with cte as (select  customer.customer_id, customer.first_name, customer.country, sum(invoice.total)
,row_number() over(partition by customer.country order by sum(invoice.total)desc) as rankno
from customer 
join invoice on invoice.customer_id = customer.customer_id 
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
group by  customer.country, customer.first_name , customer.customer_id
order by customer.country asc)
select * from cte; #where rankno=1;
