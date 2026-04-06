CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE customer_log (
    log_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    action_time TIMESTAMP
);

create or replace function log_customer_insert()
returns trigger
language plpgsql
as $$
begin 
	insert into customer_log (customer_name,action_time) values
		(new.name,current_timestamp);

		return new;
end;
$$;

create trigger trg_log_customer_insert
after insert on customers
for each row
execute function log_customer_insert()

--
insert into customers(name,email) values
('Dao Quang Minh','daominh110905@gml.com')

select * from customers
select * from customer_log