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
