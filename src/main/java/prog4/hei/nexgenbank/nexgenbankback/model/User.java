package prog4.hei.nexgenbank.nexgenbankback.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private int id;
    private String name;
    private String first_name;
    private String email;
    private String birth_date;
    private String phone_number;
    private String monthly_net_salary;
}
