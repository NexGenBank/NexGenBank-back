package prog4.hei.nexgenbank.nexgenbankback.repository.configurations;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@Getter
@Setter
@AllArgsConstructor
@ConfigurationProperties("spring.flyway")
@NoArgsConstructor
public class ConnectionProperties {
    private  String url;
    private  String username;
    private  String password;
}
