CREATE TABLE IF NOT EXISTS "Loan" (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    loan_date DATE DEFAULT CURRENT_DATE,
    amount DOUBLE PRECISION NOT NULL,
    interest_rate_for_the_first_7_days_of_overdraft INT NOT NULL,
    interest_rate_after_the_first_7_days_of_overdraft INT NOT NULL,
    interest_pay_duration_max DATE NOT NULL,
    loan_status VARCHAR(250) DEFAULT 'Unpaid' CHECK (loan_status IN ('Unpaid','Paid')),
    id_Acount UUID REFERENCES "Account"(id)
);

INSERT INTO "Loan" (amount, interest_rate_for_the_first_7_days_of_overdraft, interest_rate_after_the_first_7_days_of_overdraft, interest_pay_duration_max,  id_Acount)
VALUES
    (5000, 5, 10, '2025-03-16', 'Paid', (SELECT id FROM "Account" LIMIT 1)),
    (6000, 6, 11, '2025-03-17','Paid', (SELECT id FROM "Account" LIMIT 1 OFFSET 1)),
    (7000, 7, 12, '2025-03-18','Paid', (SELECT id FROM "Account" LIMIT 1 OFFSET 2)),
    (8000, 8, 13, '2025-03-19','Paid', (SELECT id FROM "Account" LIMIT 1 OFFSET 3)),
    (9000, 9, 14, '2025-03-20', 'Unpaid', (SELECT id FROM "Account" LIMIT 1 OFFSET 4));