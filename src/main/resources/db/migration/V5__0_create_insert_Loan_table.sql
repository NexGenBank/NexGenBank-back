CREATE TABLE IF NOT EXISTS "Loan" (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    loan_date DATE DEFAULT CURRENT_DATE,
    amount DOUBLE PRECISION NOT NULL,
    interest_rate_for_the_first_7_days_of_overdraft INT DEFAULT 1,
    interest_rate_after_the_first_7_days_of_overdraft INT DEFAULT 3,
    reason VARCHAR(250),
    loan_status VARCHAR(250) DEFAULT 'Unpaid' CHECK (loan_status IN ('Unpaid','Paid')),
    id_Account UUID REFERENCES "Account"(id)
);

INSERT INTO "Loan" (amount,loan_status,reason,id_Account)
VALUES
    (5000, 'Paid', 'Prêt à court terme pour la rénovation de la maison', (SELECT id FROM "Account" LIMIT 1)),
    (6000, 'Paid',  'Prêt d''urgence pour les frais médicaux',(SELECT id FROM "Account" LIMIT 1 OFFSET 1)),
    (7000, 'Paid', 'Prêt pour l''achat de nouveaux équipements', (SELECT id FROM "Account" LIMIT 1 OFFSET 2)),
    (8000, 'Paid','Prêt personnel pour les frais de scolarité', (SELECT id FROM "Account" LIMIT 1 OFFSET 3)),
    (9000, 'Unpaid','Prêt professionnel pour l''expansion des opérations', (SELECT id FROM "Account" LIMIT 1 OFFSET 4));