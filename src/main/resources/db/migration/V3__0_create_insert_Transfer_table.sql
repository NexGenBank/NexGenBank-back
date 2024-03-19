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
