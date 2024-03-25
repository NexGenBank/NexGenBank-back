package prog4.hei.nexgenbank.nexgenbankback.repository;

import prog4.hei.nexgenbank.nexgenbankback.model.Account;
import prog4.hei.nexgenbank.nexgenbankback.model.Account;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

public class AccountRepository implements BasicRepository<Account> {
    DBConnection dbConnection = new DBConnection();
    Connection conn = dbConnection.getConnection();
    @Override
    public List<Account> findAll() {
        List<Account> accountList = new ArrayList<>();
        try (Statement statement = conn.createStatement()) {
            String query = "SELECT * FROM \"Account\"";
            try (ResultSet result = statement.executeQuery(query)) {
                while (result.next()) {
                    UUID id = result.getObject("id",java.util.UUID.class);
                    String accountNumber = result.getString("account_number");
                    Boolean overdraft = result.getBoolean("overdraft");
                    Double balance = result.getDouble("balance");
                    Date birthDateInDate = result.getDate("creation_date");
                    LocalDateTime birthDate = birthDateInDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
                    UUID idUser = result.getObject("id_User",java.util.UUID.class);
                    Account account = new Account(id, accountNumber, overdraft, balance, birthDate, idUser);
                    accountList.add(account);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching accounts from the database", e);
        }
        return accountList;
    }

    @Override
    public List<Account> saveAll(List<Account> toSave) {
        List<Account> savedAccounts = new ArrayList<>();
        try {
            for (Account account : toSave) {
                String query = "INSERT INTO \"Account\" (account_number, overdraft, balance, creation_date, id_User) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement preparedStatement = conn.prepareStatement(query);
                preparedStatement.setString(1, account.getAccountNumber());
                preparedStatement.setBoolean(2, account.getOverdraft());
                preparedStatement.setDouble(3, account.getBalance());
                preparedStatement.setTimestamp(4, Timestamp.valueOf(account.getCreationDate()));
                preparedStatement.setObject(5, account.getIdUser());
                preparedStatement.executeUpdate();
                savedAccounts.add(account);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return savedAccounts;
    }

    @Override
    public Account save(Account toSave) {
        try {
            String query = "INSERT INTO \"Account\" (account_number, overdraft, balance, creation_date, id_User) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement preparedStatement = conn.prepareStatement(query);
            preparedStatement.setString(1, toSave.getAccountNumber());
            preparedStatement.setBoolean(2, toSave.getOverdraft());
            preparedStatement.setDouble(3, toSave.getBalance());
            preparedStatement.setTimestamp(4, Timestamp.valueOf(toSave.getCreationDate()));
            preparedStatement.setObject(5, toSave.getIdUser());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return toSave;
    }

    @Override
    public Account update(Account toUpdate) {
        try {
            String updateQuery = "UPDATE \"Account\" SET account_number=?, overdraft=?, balance=? ,creation_date=?, id_User=? WHERE id=?";
            PreparedStatement updateStatement = conn.prepareStatement(updateQuery);
            updateStatement.setString(1, toUpdate.getAccountNumber());
            updateStatement.setBoolean(2, toUpdate.getOverdraft());
            updateStatement.setDouble(3, toUpdate.getBalance());
            updateStatement.setTimestamp(4, Timestamp.valueOf(toUpdate.getCreationDate()));
            updateStatement.setObject(5, toUpdate.getIdUser());
            updateStatement.setObject(6, toUpdate.getId());
            updateStatement.executeUpdate();

            String selectQuery = "SELECT * FROM \"Account\" WHERE id=?";
            PreparedStatement selectStatement = conn.prepareStatement(selectQuery);
            selectStatement.setObject(1, toUpdate.getId());

            ResultSet resultSet = selectStatement.executeQuery();

            if (resultSet.next()) {
                Account updatedAccount = new Account();
                updatedAccount.setId(resultSet.getObject("id",java.util.UUID.class));
                updatedAccount.setAccountNumber(resultSet.getString("account_number"));
                updatedAccount.setOverdraft(resultSet.getBoolean("overdraft"));
                updatedAccount.setBalance(resultSet.getDouble("balance"));
                Date birthDateInDate = resultSet.getDate("creation_date");
                LocalDateTime birthDate = birthDateInDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
                updatedAccount.setCreationDate(birthDate);
                updatedAccount.setIdUser(resultSet.getObject("id_User",java.util.UUID.class));

                System.out.println("Account updated");
                return updatedAccount;
            } else {
                throw new RuntimeException("Failed to retrieve updated account information.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
