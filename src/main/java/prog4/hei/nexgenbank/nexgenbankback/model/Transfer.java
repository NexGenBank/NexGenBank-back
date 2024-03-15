package prog4.hei.nexgenbank.nexgenbankback.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Transfer {
    private int id;
    private LocalDateTime effect_dateTime;
    private String destination_account;
    private LocalDateTime record_date_value;
}
