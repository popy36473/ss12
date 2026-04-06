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

CREATE OR REPLACE FUNCTION check_stock_before_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INT;
BEGIN
    SELECT stock
    INTO v_stock
    FROM products
    WHERE product_id = NEW.product_id;

    IF v_stock IS NULL THEN
        RAISE EXCEPTION 'Sản phẩm có product_id = % không tồn tại', NEW.product_id;
    END IF;

    IF NEW.quantity > v_stock THEN
        RAISE EXCEPTION 'Không đủ tồn kho. Tồn hiện tại: %, số lượng yêu cầu: %', v_stock, NEW.quantity;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_stock
BEFORE INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION check_stock_before_insert();

INSERT INTO products (name, stock) VALUES
('Bút', 10),
('Vở', 20);

INSERT INTO sales (product_id, quantity)
VALUES (1, 5);

INSERT INTO sales (product_id, quantity)
VALUES (1, 15);