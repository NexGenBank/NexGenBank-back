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