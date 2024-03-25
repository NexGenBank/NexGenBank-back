CREATE TABLE IF NOT EXISTS "Account" (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    account_name VARCHAR(250) NOT NULL,
    account_number VARCHAR(100) UNIQUE NOT NULL,
    overdraft BOOLEAN DEFAULT false,
    balance DOUBLE PRECISION NOT NULL,
    creation_date TIMESTAMP DEFAULT CURRENT_DATE,
    id_User UUID REFERENCES "User"(id)
);

INSERT INTO "Account" (account_name, account_number, overdraft, balance, creation_date, id_User)
VALUES
    ('Checking Account', 'ACC987654', FALSE, 1500.00, '2024-03-16 10:25:00', (SELECT id FROM "User" LIMIT 1)),
    ('Savings', 'ACC234567', TRUE, 200.00, '2024-03-16 11:30:00', (SELECT id FROM "User" LIMIT 1 OFFSET 1)),
    ('Business', 'ACC345678', FALSE, 8000.00, '2024-03-16 12:45:00', (SELECT id FROM "User" LIMIT 1 OFFSET 2)),
    ('Checking Account', 'ACC456789', FALSE, 400.00, '2024-03-16 14:00:00', (SELECT id FROM "User" LIMIT 1 OFFSET 3)),
    ('Student', 'ACC567890', TRUE, 1200.00, '2024-03-16 15:15:00', (SELECT id FROM "User" LIMIT 1 OFFSET 4));
