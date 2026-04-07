DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price NUMERIC(12,2) NOT NULL CHECK (price >= 0)
);

INSERT INTO products (product_name, price) VALUES
('Laptop Dell', 15000000),
('Chuột Logitech', 350000),
('Bàn phím cơ', 1200000);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    total_amount NUMERIC(14,2)
);

CREATE OR REPLACE FUNCTION calculate_total_amount()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_price NUMERIC(12,2);
BEGIN
    SELECT price
    INTO v_price
    FROM products
    WHERE product_id = NEW.product_id;

    IF v_price IS NULL THEN
        RAISE EXCEPTION 'Không tìm thấy sản phẩm có product_id = %', NEW.product_id;
    END IF;

    NEW.total_amount := NEW.quantity * v_price;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_calculate_total_amount
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION calculate_total_amount();

INSERT INTO orders (product_id, quantity) VALUES
(1, 2),
(2, 5),
(3, 3);

SELECT * FROM orders;