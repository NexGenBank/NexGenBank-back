package prog4.hei.nexgenbank.nexgenbankback.repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private Connection connection;
    public DBConnection(){
        try{
            String Url = System.getenv("DB_URL");
            String User = System.getenv("DB_USER");
            String Password = System.getenv("DB_PASSWORD");

            this.connection = DriverManager.getConnection(Url, User, Password);
        } catch (SQLException e){
            e.printStackTrace();
        }
    }

    public Connection getConnection() {
        return this.connection;
    }
}
