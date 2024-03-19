CREATE TABLE IF NOT EXISTS "User" (
    id UUID DEFAULT  uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(250) NOT NULL,
    first_name VARCHAR(250) NOT NULL,
    email VARCHAR(250) UNIQUE NOT NULL,
    birth_date DATE NOT NULL,
    phone_number VARCHAR(50),
    monthly_net_salary DOUBLE PRECISION NOT NULL
);

INSERT INTO "User" (name, first_name, email, birth_date, phone_number, monthly_net_salary)
VALUES
    ('Smith', 'John', 'john.smith@example.com', '1990-05-15', '+123456789', 5000.00),
    ('Johnson', 'Emma', 'emma.johnson@example.com', '1985-10-20', '+198765432', 6000.00),
    ('Garcia', 'Michael', 'michael.garcia@example.com', '1978-03-08', '+176543289', 7000.00),
    ('Brown', 'Emily', 'emily.brown@example.com', '1995-12-28', '+187654321', 5500.00),
    ('Davis', 'William', 'william.davis@example.com', '1980-09-10', '+165432187', 6500.00);
