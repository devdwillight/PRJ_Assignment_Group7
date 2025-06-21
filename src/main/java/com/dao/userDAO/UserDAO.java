/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.userDAO;

import dbcontext.DBConnect;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.user.User;

/**
 *
 * @author DELL
 */
public class UserDAO implements IUserDAO {

    private static final String INSERT = "INSERT INTO Users (username, password,frist_name,last_name,birthday,email,phone,gender,active,is_admin,created_at, update_at,avatar) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
    private static final String SELECT = "SELECT * FROM Users";

    @Override
    public int insertUser(User user) throws SQLException {
        try (Connection conn = DBConnect.getConnection()) {
            PreparedStatement ptm = conn.prepareStatement(INSERT);
            ptm.setString(1, user.getUserName());
            ptm.setString(2, user.getPassWord());
            ptm.setString(3, user.getFirst_name());
            ptm.setString(4, user.getLast_name());
            ptm.setDate(5, new Date(user.getBirthday().getTime()));
            ptm.setString(6, user.getEmail());
            ptm.setString(7, user.getPhone());
            ptm.setString(8, user.getGender());
            ptm.setBoolean(9, user.isActive());
            ptm.setBoolean(10, user.isAdmin());
            ptm.setDate(11, new Date(user.getCreated_at().getTime()));
            ptm.setDate(12, new Date(user.getUpdate_at().getTime()));
            ptm.setString(13, user.getAvatar());
            int rowInserted = ptm.executeUpdate();
            if (rowInserted > 0) {
                return rowInserted;
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return 0;
    }

    @Override
    public User selectUserByID(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public User selectUserByEmail(String email) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<User> selectAllUsers() {
        List<User> users = new ArrayList<>();
        try(Connection conn = DBConnect.getConnection()) {
            PreparedStatement ptm = conn.prepareStatement(SELECT);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {                
                int id =rs.getInt("id_user");
                String userName = rs.getString("username");
                String password = rs.getString("password");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                Date DOB = rs.getDate("birthday");
                String email = rs.getString("email");
                String phone = rs.getString("phone");
                String gender = rs.getString("gender");
                boolean active = rs.getBoolean("active");
                boolean admin = rs.getBoolean("is_admin");
                Date createAt = rs.getDate("created_at");
                Date updatedAt = rs.getDate("update_at");
                String avatar = rs.getString("avatar");
                users.add(new User(id, userName, password, first_name, last_name, DOB, email, phone, gender, active, admin, createAt, updatedAt, avatar));
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return users;
    }

    @Override
    public List<User> selectUserByPage(int pageNumber, int pageSize) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean updateUser(User user) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean deleteUser(int id) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean existsByEmail(String email) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean existsByID(int ID) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int countUser() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while (t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }
}
