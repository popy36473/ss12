

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    total_amount NUMERIC(10,2)
);

CREATE TABLE order_log (
    log_id SERIAL PRIMARY KEY,
    order_id INT,
    action_time TIMESTAMP
);

INSERT INTO products (name, price, stock) VALUES
('Laptop', 15000000, 10),
('Chuot', 300000, 50),
('Ban phim', 800000, 20);

BEGIN;

DO $$
DECLARE
    v_product_id INT := 1;
    v_quantity INT := 2;
    v_price NUMERIC(10,2);
    v_stock INT;
    v_order_id INT;
BEGIN
    SELECT price, stock
    INTO v_price, v_stock
    FROM products
    WHERE product_id = v_product_id;

    IF v_stock >= v_quantity THEN
        INSERT INTO orders (product_id, quantity, total_amount)
        VALUES (v_product_id, v_quantity, v_quantity * v_price)
        RETURNING order_id INTO v_order_id;

        UPDATE products
        SET stock = stock - v_quantity
        WHERE product_id = v_product_id;

        INSERT INTO order_log (order_id, action_time)
        VALUES (v_order_id, NOW());

        RAISE NOTICE 'Them don hang thanh cong';
    ELSE
        RAISE EXCEPTION 'Khong du hang trong kho';
    END IF;
END $$;

COMMIT;

SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_log;