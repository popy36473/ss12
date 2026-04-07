CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    stock INT
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT
);

create or replace function after_insert ()
returns trigger language plpgsql	
as $$
begin
	update products
	set stock = stock - new.quantity	
	where product_id = new.product_id;

	return new;
end;
$$;		

create trigger TRIGGER_AFTER_INSERT
after insert on sales
for each row
execute function after_insert()

--
select *from products


insert into sales(product_id,quantity) values
(1,5)