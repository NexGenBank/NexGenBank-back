\c postgres

DROP DATABASE  nexgenbank;

CREATE DATABASE  nexgenbank;

\c nexgenbank

       -- uuid extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

       -- User table
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


        --Category table
CREATE TABLE IF NOT EXISTS "Category" (
    id UUID DEFAULT  uuid_generate_v4() PRIMARY KEY,
    category_name VARCHAR(250) NOT NULL
);

INSERT INTO "Category" (category_name) VALUES ('Salaire'),('Ecollage'),('Nourriture'),('Habit');

        --Transfer table
CREATE TABLE IF NOT EXISTS "Transfer" (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    effect_datetime TIMESTAMP NOT NULL,
    destination_account VARCHAR(250) NOT NULL,
    record_date_value TIMESTAMP,
    label VARCHAR(250)
    );

INSERT INTO "Transfer" (effect_datetime, destination_account, record_date_value, label)
VALUES
    ('2024-03-16 10:30:00', '0146464qsfq', CURRENT_TIMESTAMP, 'Salaire'),
    ('2024-03-16 11:45:00', 'ACC987654', CURRENT_TIMESTAMP, 'Paiement de loyer'),
    ('2024-03-16 14:20:00', 'ACC456789', CURRENT_TIMESTAMP, 'Achat en ligne');

        --Account table
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


        --Loan table
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

-- transaction table
CREATE TABLE IF NOT EXISTS "Transaction" (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    amount DOUBLE PRECISION NOT NULL,
    status VARCHAR(50) CHECK (status IN ('In progress', 'Failed', 'Cancelled', 'Success')) NOT NULL,
    reason VARCHAR(250),
    transaction_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_type VARCHAR(25) CHECK (transaction_type IN ('Withdrawal', 'Transfer', 'Credit')),
    id_Transfer UUID,
    id_Account UUID REFERENCES "Account"(id),
    id_Category UUID REFERENCES "Category",
    CONSTRAINT valid_id_transfer CHECK (
(transaction_type = 'Transfer' AND id_Transfer IS NOT NULL) OR
(transaction_type != 'Transfer' AND id_Transfer IS NULL)
    )
    );

INSERT INTO "Transaction" (amount, status, reason, transaction_datetime, transaction_type, id_Transfer, id_Account, id_Category)
VALUES
    (500.00, 'Success', 'Paiement des courses', '2024-03-16 10:25:00', 'Transfer', (SELECT id FROM "Transfer" LIMIT 1), (SELECT id FROM "Account" LIMIT 1), (SELECT id FROM "Category" LIMIT 1)),
    (200.00, 'Failed', 'Retrait au guichet automatique échoué', '2024-03-16 11:30:00', 'Withdrawal', NULL, (SELECT id FROM "Account" LIMIT 1 OFFSET 1), (SELECT id FROM "Category" LIMIT 1)),
    (1000.00, 'Success', 'Dépôt de salaire', '2024-03-16 12:45:00', 'Credit', NULL, (SELECT id FROM "Account" LIMIT 1 OFFSET 2), (SELECT id FROM "Category" LIMIT 1)),
    (300.00, 'In progress', 'Virement en attente vers un ami', '2024-03-16 14:00:00', 'Transfer', (SELECT id FROM "Transfer" OFFSET 1 LIMIT 1), (SELECT id FROM "Account" LIMIT 1 OFFSET 3), (SELECT id FROM "Category" LIMIT 1)),
    (150.00, 'Success', 'Paiement des factures de services publics', '2024-03-16 15:15:00', 'Transfer', (SELECT id FROM "Transfer" OFFSET 2 LIMIT 1), (SELECT id FROM "Account" LIMIT 1 OFFSET 4), (SELECT id FROM "Category" LIMIT 1));


-- Withdrawal function
CREATE OR REPLACE FUNCTION do_withdrawal(
    p_amount DOUBLE PRECISION,
    p_account_id UUID,
    p_reason VARCHAR(250),
    p_category UUID
) RETURNS VARCHAR(250) AS
$$
DECLARE
v_balance        DOUBLE PRECISION;
    v_overdraft      BOOLEAN;
    v_balance_limit  DOUBLE PRECISION;
    v_amount_to_loan DOUBLE PRECISION;
    v_active_loan    BOOLEAN;
BEGIN
    -- Comparison of balance and w_amount ( amount to withdrawal )
SELECT a.balance INTO v_balance FROM "Account" a WHERE a.id = p_account_id;

IF p_amount <= v_balance THEN
        -- Proceed with the withdrawal
        INSERT INTO "Transaction" (amount, status, reason, transaction_type, id_Account, id_Category)
        VALUES (p_amount, 'Success', p_reason, 'Withdrawal', p_account_id, p_category);
        -- Update the account balance
UPDATE "Account" SET balance = balance - p_amount WHERE id = p_account_id;
RETURN 'Withdrawal successful: ' || p_amount::VARCHAR(250);
ELSE
        --Check if overdraft is enabled
SELECT overdraft INTO v_overdraft FROM "Account" WHERE id = p_account_id;

IF NOT v_overdraft THEN
            RETURN 'Insufficient balance';
ELSE
            -- Check if the withdrawal amount is within the balance limit
SELECT a.balance + (u.monthly_net_salary / 3)
INTO v_balance_limit
FROM "Account" a
         JOIN "User" u ON a.id_User = u.id
WHERE a.id = p_account_id;

IF v_balance_limit < p_amount THEN
                RETURN 'Insufficient balance';
ELSE
                -- Check if there is an active loan
SELECT EXISTS(SELECT 1 FROM "Loan" l WHERE l.id_Account = p_account_id AND l.loan_status != 'Paid')
INTO v_active_loan;

IF v_active_loan THEN
                    RETURN 'You already have an active loan';
ELSE
                    -- Calculation amount to loan
SELECT (p_amount - a.balance) INTO v_amount_to_loan FROM "Account" a WHERE a.id = p_account_id;
--New loan insertion
INSERT INTO "Loan" (amount, reason, id_Account)
VALUES (v_amount_to_loan, p_reason, p_account_id);
-- Update the account balance
UPDATE "Account" SET balance = v_amount_to_loan * -1 WHERE id = p_account_id;
RETURN 'You lent ' || v_amount_to_loan::DOUBLE PRECISION || ' to the bank.';
END IF;
END IF;
END IF;
END IF;
END;
$$ LANGUAGE plpgsql;