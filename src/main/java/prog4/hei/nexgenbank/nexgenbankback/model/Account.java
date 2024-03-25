package prog4.hei.nexgenbank.nexgenbankback.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Account {
    private UUID id;
    private String  accountNumber;
    private Boolean overdraft;
    private Double balance;
    private LocalDateTime creationDate;
    private UUID idUser;
}
