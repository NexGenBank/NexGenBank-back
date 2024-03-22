package prog4.hei.nexgenbank.nexgenbankback.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Account {
    private int id;
    private String  accountNumber;
    private Boolean overdraft;
    private Double balance;
    private LocalDateTime creationDate;
}
