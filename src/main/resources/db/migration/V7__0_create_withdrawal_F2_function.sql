CREATE OR REPLACE FUNCTION manage_withdrawal(
    p_amount DOUBLE PRECISION,
    p_account_id UUID,
    p_category_id UUID,
    p_reason VARCHAR(250)
) RETURNS VARCHAR(250) AS $$
DECLARE
    v_balance DOUBLE PRECISION;
    v_overdraft BOOLEAN;
    v_active_loan BOOLEAN;
BEGIN
    -- Calculate the balance including the minimum withdrawal amount
    SELECT a.balance + (u.monthly_net_salary / 3) INTO v_balance
    FROM "Account" a
             JOIN "User" u ON a.id_User = u.id
    WHERE a.id = p_account_id;

    -- Check if the withdrawal amount is within the balance limit
    IF p_amount <= v_balance THEN
        -- Proceed with the withdrawal
        INSERT INTO "Transaction" (amount, status, reason, transaction_type, id_Account, id_Category)
        VALUES (p_amount, 'Success', p_reason, 'Withdrawal', p_account_id, p_category_id);

        -- Update the account balance
        UPDATE "Account" SET balance = balance - p_amount WHERE id = p_account_id;

        RETURN 'Withdrawal successful';
    ELSE
        -- Check if overdraft is enabled
        SELECT overdraft INTO v_overdraft FROM "Account" WHERE id = p_account_id;

        IF NOT v_overdraft THEN
            RETURN 'Insufficient balance';
        ELSE
            -- Check if there is an active loan
            -- Assuming an active loan is one where the due_date is in the future
            SELECT EXISTS(SELECT 1 FROM "Loan" WHERE id_Acount = p_account_id AND loan_status != 'Paid') INTO v_active_loan;

            IF v_active_loan THEN
                RETURN 'You already have an active loan';
            ELSE
                RETURN 'Switch to the loan page';
            END IF;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;