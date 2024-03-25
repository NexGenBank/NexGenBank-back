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
    private int interestRateForTheFirst7DaysOfOverdraft;
    private int interestRateAfterTheFirst7DaysOfOverdraft;
    private Date interestPayDurationMax;
    private String descriptionLoan;
}
