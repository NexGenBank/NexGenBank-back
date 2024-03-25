CREATE TABLE IF NOT EXISTS "Loan" (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    loan_date DATE DEFAULT CURRENT_DATE,
    amount DOUBLE PRECISION NOT NULL,
    interest_rate_for_the_first_7_days_of_overdraft INT NOT NULL,
    interest_rate_after_the_first_7_days_of_overdraft INT NOT NULL,
    reason VARCHAR(250),
    loan_status VARCHAR(250) DEFAULT 'Unpaid' CHECK (loan_status IN ('Unpaid','Paid')),
    id_Acount UUID REFERENCES "Account"(id)
);

INSERT INTO "Loan" (amount, interest_rate_for_the_first_7_days_of_overdraft, interest_rate_after_the_first_7_days_of_overdraft,loan_status,reason,id_Acount)
VALUES
    (5000, 5, 10,'Paid', 'Prêt à court terme pour la rénovation de la maison', (SELECT id FROM "Account" LIMIT 1)),
    (6000, 6, 11,'Paid',  'Prêt d''urgence pour les frais médicaux',(SELECT id FROM "Account" LIMIT 1 OFFSET 1)),
    (7000, 7, 12,'Paid', 'Prêt pour l''achat de nouveaux équipements', (SELECT id FROM "Account" LIMIT 1 OFFSET 2)),
    (8000, 8, 13,'Paid','Prêt personnel pour les frais de scolarité', (SELECT id FROM "Account" LIMIT 1 OFFSET 3)),
    (9000, 9, 14,'Unpaid','Prêt professionnel pour l''expansion des opérations', (SELECT id FROM "Account" LIMIT 1 OFFSET 4));