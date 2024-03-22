\c postgres

DROP DATABASE IF EXISTS nexgenbank;
CREATE DATABASE nexgenbank;

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
    account_number VARCHAR(100) UNIQUE NOT NULL,
    overdraft BOOLEAN DEFAULT false,
    balance DOUBLE PRECISION NOT NULL,
    creation_date TIMESTAMP DEFAULT CURRENT_DATE,
    id_User UUID REFERENCES "User"(id)
    );

INSERT INTO "Account" (account_number, overdraft, balance, creation_date, id_User)
VALUES
    ('ACC987654', FALSE, 1500.00, '2024-03-16 10:25:00', (SELECT id FROM "User" LIMIT 1)),
    ('ACC234567', TRUE, 200.00, '2024-03-16 11:30:00', (SELECT id FROM "User" LIMIT 1 OFFSET 1)),
    ('ACC345678', FALSE, 8000.00, '2024-03-16 12:45:00', (SELECT id FROM "User" LIMIT 1 OFFSET 2)),
    ('ACC456789', FALSE, 400.00, '2024-03-16 14:00:00', (SELECT id FROM "User" LIMIT 1 OFFSET 3)),
    ('ACC567890', TRUE, 1200.00, '2024-03-16 15:15:00', (SELECT id FROM "User" LIMIT 1 OFFSET 4));


        --Loan table
CREATE TABLE IF NOT EXISTS "Loan" (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    interest_rate_for_first_7_of_overdraft INT NOT NULL,
    interest_rate_after_first_7_of_overdraft INT NOT NULL,
    interest_pay_duration_max DATE NOT NULL,
    description_loan TEXT
);


        --Transaction table
CREATE TABLE IF NOT EXISTS "Transaction" (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    amount DOUBLE PRECISION NOT NULL,
    status VARCHAR(50) CHECK (status IN ('En cours', 'Echec', 'Annulée', 'Réussite')) NOT NULL,
    reason VARCHAR(250),
    transaction_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_type VARCHAR(25) CHECK (transaction_type IN ('Retrait', 'Virement', 'Crédit')),
    id_Transfer UUID,
    id_Account UUID REFERENCES "Account"(id),
    id_Category UUID REFERENCES "Category",
    CONSTRAINT valid_id_transfer CHECK (
        (transaction_type = 'Virement' AND id_Transfer IS NOT NULL) OR
        (transaction_type != 'Virement' AND id_Transfer IS NULL)
    )
);


INSERT INTO "Transaction" (amount, status, reason, transaction_datetime, transaction_type, id_Transfer, id_Account, id_Category)
VALUES
    (500.00, 'Réussite', 'Paiement des courses', '2024-03-16 10:25:00', 'Virement', (SELECT id FROM "Transfer" LIMIT 1), (SELECT id FROM "Account" LIMIT 1), (SELECT id FROM "Category" LIMIT 1)),
    (200.00, 'Echec', 'Retrait au guichet automatique échoué', '2024-03-16 11:30:00', 'Retrait', NULL, (SELECT id FROM "Account" LIMIT 1 OFFSET 1), (SELECT id FROM "Category" LIMIT 1)),
    (1000.00, 'Réussite', 'Dépôt de salaire', '2024-03-16 12:45:00', 'Crédit', NULL, (SELECT id FROM "Account" LIMIT 1 OFFSET 2), (SELECT id FROM "Category" LIMIT 1)),
    (300.00, 'En cours', 'Virement en attente vers un ami', '2024-03-16 14:00:00', 'Virement', (SELECT id FROM "Transfer" LIMIT 1 OFFSET 1), (SELECT id FROM "Account" LIMIT 1 OFFSET 3), (SELECT id FROM "Category" LIMIT 1)),
    (150.00, 'Réussite', 'Paiement des factures de services publics', '2024-03-16 15:15:00', 'Virement', (SELECT id FROM "Transfer" LIMIT 1 OFFSET 2), (SELECT id FROM "Account" LIMIT 1 OFFSET 4), (SELECT id FROM "Category" LIMIT 1));



