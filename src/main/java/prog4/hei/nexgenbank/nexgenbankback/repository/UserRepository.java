package prog4.hei.nexgenbank.nexgenbankback.repository;

import prog4.hei.nexgenbank.nexgenbankback.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

public class UserRepository implements BasicRepository<User>{
    DBConnection dbConnection = new DBConnection();
    Connection conn = dbConnection.getConnection();
    @Override
    public List<User> findAll() {
        List<User> userList = new ArrayList<>();
        try (Statement statement = conn.createStatement()) {
            String query = "SELECT * FROM \"User\"";
            try (ResultSet result = statement.executeQuery(query)) {
                while (result.next()) {
                    UUID id = result.getObject("id",java.util.UUID.class);
                    String name = result.getString("name");
                    String first_name = result.getString("first_name");
                    String email = result.getString("email");
                    Date birth_date = result.getDate("birth_date");
                    String phone_number = result.getString("phone_number");
                    Double monthly_net_salary = result.getDouble("monthly_net_salary");
                    User user = new User(id, name, first_name, email, birth_date, phone_number, monthly_net_salary);
                    userList.add(user);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching users from the database", e);
        }
        return userList;
    }

    @Override
    public List<User> saveAll(List<User> toSave) {
        List<User> savedUsers = new ArrayList<>();
        try {
            for (User user : toSave) {
                String query = "INSERT INTO \"User\" (name, first_name, email, birth_date, phone_number, monthly_net_salary) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement preparedStatement = conn.prepareStatement(query);
                preparedStatement.setString(1, user.getName());
                preparedStatement.setString(2, user.getFirst_name());
                preparedStatement.setString(3, user.getEmail());
                preparedStatement.setDate(4, new java.sql.Date(user.getBirth_date().getTime()));
                preparedStatement.setString(5, user.getPhone_number());
                preparedStatement.setDouble(6, user.getMonthly_net_salary());
                preparedStatement.executeUpdate();
                savedUsers.add(user);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return savedUsers;
    }

    @Override
    public User save(User toSave) {
        try {
            String query = "INSERT INTO \"User\" (name, first_name, email, birth_date, phone_number, monthly_net_salary) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement preparedStatement = conn.prepareStatement(query);
            preparedStatement.setString(1, toSave.getName());
            preparedStatement.setString(2, toSave.getFirst_name());
            preparedStatement.setString(3, toSave.getEmail());
            preparedStatement.setDate(4, new java.sql.Date(toSave.getBirth_date().getTime()));
            preparedStatement.setString(5, toSave.getPhone_number());
            preparedStatement.setDouble(6, toSave.getMonthly_net_salary());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return toSave;
    }

    @Override
    public User update(User toUpdate) {
        try {
            String updateQuery = "UPDATE \"User\" SET name=?, first_name=?, email=? ,birth_date=?, phone_number=?, monthly_net_salary=? WHERE id=?";
            PreparedStatement updateStatement = conn.prepareStatement(updateQuery);
            updateStatement.setString(1, toUpdate.getName());
            updateStatement.setString(2, toUpdate.getFirst_name());
            updateStatement.setString(3, toUpdate.getEmail());
            updateStatement.setDate(4, new java.sql.Date(toUpdate.getBirth_date().getTime()));
            updateStatement.setString(5, toUpdate.getPhone_number());
            updateStatement.setDouble(6, toUpdate.getMonthly_net_salary());
            updateStatement.setObject(7, toUpdate.getId());
            updateStatement.executeUpdate();

            String selectQuery = "SELECT * FROM \"User\" WHERE id=?";
            PreparedStatement selectStatement = conn.prepareStatement(selectQuery);
            selectStatement.setObject(1, toUpdate.getId());

            ResultSet resultSet = selectStatement.executeQuery();

            if (resultSet.next()) {
                User updatedAccount = new User();
                updatedAccount.setId(resultSet.getObject("id",java.util.UUID.class));
                updatedAccount.setName(resultSet.getString("name"));
                updatedAccount.setFirst_name(resultSet.getString("first_name"));
                updatedAccount.setEmail(resultSet.getString("email"));
                updatedAccount.setBirth_date(resultSet.getDate("birth_date"));
                updatedAccount.setPhone_number(resultSet.getString("phone_number"));
                updatedAccount.setMonthly_net_salary(resultSet.getDouble("monthly_net_salary"));

                System.out.println("User updated");
                return updatedAccount;
            } else {
                throw new RuntimeException("Failed to retrieve updated user information.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
