package prog4.hei.nexgenbank.nexgenbankback.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Loan {
    private int id;
    private int interest_rate_for_the_first_7_days_of_overdraft;
    private int interest_rate_after_the_first_7_days_of_overdraft;
    private Date interest_pay_duration_max;
    private String description_loan;
}
