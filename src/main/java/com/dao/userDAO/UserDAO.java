/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.userDAO;

import com.database.DBconnection;
import com.model.User;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author DELL
 */
public class UserDAO implements IUserDAO {

    private static final String INSERT = "INSERT INTO Users (username, password,first_name,last_name,birthday,email,phone,gender,active,is_admin,created_at, updated_at,avatar) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
    private static final String UPDATE = "UPDATE Users SET username=?, password=?, first_name=?, last_name=?, birthday=?, email=?, phone=?, gender=?, active=?, is_admin=?, created_at=?, updated_at=?, avatar=? WHERE id_user=?";
    private static final String SELECT_USERS = "SELECT * FROM Users";
    private static final String SELECT_USER_BY_ID = "SELECT * FROM Users WHERE id_user = ?";
    private static final String SELECT_USER_BY_EMAIL = "SELECT * FROM Users WHERE email = ?";
    private static final String SELECT_USER_BY_PAGE = "SELECT * FROM Users ORDER BY id_user OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
    private static final String SELECT_USER_EXIST_EMAIL = "SELECT 1 FROM Users WHERE email = ?";
    private static final String SELECT_USER_EXIST_ID = "SELECT 1 FROM Users WHERE id_user = ?";
    private static final String COUNT = "SELECT COUNT(*) FROM Users";
    private static final String DELETE = "DELETE FROM Users WHERE id_user = ?";

    @Override
    public int insertUser(User user) throws SQLException {
        try (Connection conn = DBconnection.getConnection()) {
            PreparedStatement ptm = conn.prepareStatement(INSERT);
            ptm.setString(1, user.getUserName());
            ptm.setString(2, user.getPassWord());
            ptm.setString(3, user.getFirst_name());
            ptm.setString(4, user.getLast_name());
            ptm.setDate(5, user.getBirthday() != null ? new Date(user.getBirthday().getTime()) : null);
            ptm.setString(6, user.getEmail());
            ptm.setString(7, user.getPhone());
            ptm.setString(8, user.getGender());
            ptm.setBoolean(9, user.isActive());
            ptm.setBoolean(10, user.isAdmin());
            ptm.setDate(11, user.getCreated_at() != null ? new Date(user.getCreated_at().getTime()) : null);
            ptm.setDate(12, user.getUpdate_at() != null ? new Date(user.getUpdate_at().getTime()) : null);
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
        User user = null;
        try (Connection conn = DBconnection.getConnection()) {
            PreparedStatement ptm = conn.prepareStatement(SELECT_USER_BY_ID);
            ptm.setInt(1, id);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {

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
                Date updatedAt = rs.getDate("updated_at");
                String avatar = rs.getString("avatar");

                user = new User(id, userName, password, first_name, last_name, DOB, email, phone, gender, active, admin, createAt, updatedAt, avatar);
            } else {
                return null;
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return user;
    }

    @Override
    public User selectUserByEmail(String email) {
        User user = null;
        try (Connection conn = DBconnection.getConnection()) {
            PreparedStatement ptm = conn.prepareStatement(SELECT_USER_BY_EMAIL);
            ptm.setString(1, email);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("id_user");
                String userName = rs.getString("username");
                String password = rs.getString("password");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                Date DOB = rs.getDate("birthday");
                String phone = rs.getString("phone");
                String gender = rs.getString("gender");
                boolean active = rs.getBoolean("active");
                boolean admin = rs.getBoolean("is_admin");
                Date createAt = rs.getDate("created_at");
                Date updatedAt = rs.getDate("updated_at");
                String avatar = rs.getString("avatar");

                user = new User(id, userName, password, first_name, last_name, DOB, email, phone, gender, active, admin, createAt, updatedAt, avatar);
            } else {
                return null;
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return user;
    }

    @Override
    public List<User> selectAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection conn = DBconnection.getConnection()) {
            PreparedStatement ptm = conn.prepareStatement(SELECT_USERS);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id_user");
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
                Date updatedAt = rs.getDate("updated_at");
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
        List<User> users = new ArrayList<>();
        int setOff = (pageNumber - 1) * pageSize;
        try (Connection conn = DBconnection.getConnection()) {
            PreparedStatement ptm = conn.prepareStatement(SELECT_USER_BY_PAGE);
            ptm.setInt(1, setOff);
            ptm.setInt(2, pageSize);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id_user");
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
                Date updatedAt = rs.getDate("updated_at");
                String avatar = rs.getString("avatar");
                users.add(new User(id, userName, password, first_name, last_name, DOB, email, phone, gender, active, admin, createAt, updatedAt, avatar));
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return users;
    }

    @Override
    public boolean updateUser(User user) throws SQLException {
        try (Connection conn = DBconnection.getConnection()) {
            PreparedStatement ptm = conn.prepareStatement(UPDATE);
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
            ptm.setInt(14, user.getId());
            if (ptm.executeUpdate() > 0) {
                return true;
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return false;
    }

    @Override
    public boolean deleteUser(int id) throws SQLException {
        try (Connection con = DBconnection.getConnection()) {
            PreparedStatement ptm = con.prepareStatement(DELETE);
            ptm.setInt(1, id);
            if (ptm.executeUpdate() > 0) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean existsByEmail(String email) {
        try (Connection con = DBconnection.getConnection()) {
            PreparedStatement ptm = con.prepareStatement(SELECT_USER_EXIST_EMAIL);
            ptm.setString(1, email);
            ResultSet rs = ptm.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean existsByID(int ID) {
        try (Connection con = DBconnection.getConnection()) {
            PreparedStatement ptm = con.prepareStatement(SELECT_USER_EXIST_ID);
            ptm.setInt(1, ID);
            ResultSet rs = ptm.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public int countUser() {
        try (Connection conn = DBconnection.getConnection()) {
            PreparedStatement ptm = conn.prepareStatement(COUNT);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return 0;
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
