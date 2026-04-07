
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    account_name VARCHAR(50),
    balance NUMERIC
);

INSERT INTO accounts (account_name, balance) VALUES
('Tai khoan A', 1000000),
('Tai khoan B', 500000);

BEGIN;

DO $$
DECLARE
    v_sender_balance NUMERIC;
    v_amount NUMERIC := 300000;
    v_sender_id INT := 1;
    v_receiver_id INT := 2;
BEGIN
    SELECT balance
    INTO v_sender_balance
    FROM accounts
    WHERE account_id = v_sender_id;

    IF v_sender_balance >= v_amount THEN
        UPDATE accounts
        SET balance = balance - v_amount
        WHERE account_id = v_sender_id;

        UPDATE accounts
        SET balance = balance + v_amount
        WHERE account_id = v_receiver_id;

        RAISE NOTICE 'Chuyen tien thanh cong';
    ELSE
        RAISE EXCEPTION 'So du khong du de chuyen';
    END IF;
END $$;

COMMIT;

SELECT * FROM accounts;