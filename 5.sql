

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    position VARCHAR(50)
);

CREATE TABLE employee_log (
    log_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(50),
    action_time TIMESTAMP
);

INSERT INTO employees (name, position) VALUES
('Nguyen Van A', 'Nhan vien'),
('Tran Thi B', 'Ke toan'),
('Le Van C', 'Quan ly');

CREATE OR REPLACE FUNCTION log_employee_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employee_log (emp_name, action_time)
    VALUES (NEW.name, NOW());

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_employee_update
AFTER UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION log_employee_update();

UPDATE employees
SET position = 'Truong phong'
WHERE emp_id = 1;

SELECT * FROM employees;
SELECT * FROM employee_log;