package prog4.hei.nexgenbank.nexgenbankback;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = "prog4.hei.nexgenbank.nexgenbankback")
public class NexgenbankBackApplication {

    public static void main(String[] args) {
        SpringApplication.run(NexgenbankBackApplication.class, args);
    }

}
