package prog4.hei.nexgenbank.nexgenbankback.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {
    private int id;
    private Double amount;
    private String status;
    private String reason;
    private LocalDateTime transaction_date;
    private String transaction_type;
}
