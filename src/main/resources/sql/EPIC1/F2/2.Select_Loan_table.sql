SELECT  FROM "Loan"

CREATE TABLE IF NOT EXISTS "Loan" (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    loan_date DATE DEFAULT CURRENT_DATE,
    amount DOUBLE PRECISION NOT NULL,
    interest_rate_for_the_first_7_days_of_overdraft INT NOT NULL,
    interest_rate_after_the_first_7_days_of_overdraft INT NOT NULL,
    interest_pay_duration_max DATE NOT NULL,
    loan_paid DOUBLE PRECISION,
    description_loan TEXT,
    id_Acount UUID REFERENCES "Account"(id)
);