CREATE TABLE IF NOT EXISTS "Loan" (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    interest_rate_for_the_first_7_days_of_overdraft INT NOT NULL,
    interest_rate_after_the_first_7_days_of_overdraft INT NOT NULL,
    interest_pay_duration_max DATE NOT NULL,
    description_loan TEXT,
    id_Acount UUID REFERENCES "Account"(id)
);

INSERT INTO "Loan" (interest_rate_for_the_first_7_days_of_overdraft, interest_rate_after_the_first_7_days_of_overdraft, interest_pay_duration_max, description_loan, id_Acount)
VALUES
    (5, 8, '2025-03-16', 'Short-term loan for home renovation', (SELECT id FROM "Account" LIMIT 1)),
    (6, 9, '2025-03-17', 'Emergency loan for medical expenses', (SELECT id FROM "Account" LIMIT 1 OFFSET 1)),
    (7, 10, '2025-03-18', 'Loan for purchasing new equipment', (SELECT id FROM "Account" LIMIT 1 OFFSET 2)),
    (8, 11, '2025-03-19', 'Personal loan for education expenses', (SELECT id FROM "Account" LIMIT 1 OFFSET 3)),
    (9, 12, '2025-03-20', 'Business loan for expanding operations', (SELECT id FROM "Account" LIMIT 1 OFFSET 4));
