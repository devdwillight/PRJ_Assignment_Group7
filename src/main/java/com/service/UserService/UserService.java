/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.UserService;

import com.dao.userDAO.UserDAO;
import com.model.User;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

/**
 *
 * @author DELL
 */
public class UserService implements IUserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    @Override
    public int createUser(User user) throws SQLException {
        System.out.println("Service: createUser called with user = " + user);
        int result = userDAO.insertUser(user);
        System.out.println("Service: createUser result = " + result);
        return result;
    }

    @Override
    public User getUserById(int id) {
        System.out.println("Service: getUserById called with id = " + id);
        User user = userDAO.selectUserByID(id);
        System.out.println("Service: getUserById result = " + user);
        return user;
    }

    @Override
    public User getUserByEmail(String email) {
        System.out.println("Service: getUserByEmail called with email = " + email);
        User user = userDAO.selectUserByEmail(email);
        System.out.println("Service: getUserByEmail result = " + user);
        return user;
    }

    @Override
    public List<User> getAllUsers() {
        System.out.println("Service: getAllUsers called");
        List<User> users = userDAO.selectAllUsers();
        System.out.println("Service: getAllUsers found " + users.size() + " users");
        return users;
    }

    @Override
    public List<User> getUsersByPage(int pageNumber, int pageSize) {
        System.out.println("Service: getUsersByPage called with pageNumber = " + pageNumber + ", pageSize = " + pageSize);
        List<User> users = userDAO.selectUserByPage(pageNumber, pageSize);
        System.out.println("Service: getUsersByPage returned " + users.size() + " users");
        return users;
    }

    @Override
    public boolean updateUser(User user) throws SQLException {
        System.out.println("Service: updateUser called with user = " + user);
        boolean result = userDAO.updateUser(user);
        System.out.println("Service: updateUser result = " + result);
        return result;
    }

    @Override
    public boolean removeUser(int id) throws SQLException {
        System.out.println("Service: removeUser called with id = " + id);
        boolean result = userDAO.deleteUser(id);
        System.out.println("Service: removeUser result = " + result);
        return result;
    }

    @Override
    public boolean isEmailTaken(String email) {
        System.out.println("Service: isEmailTaken called with email = " + email);
        boolean exists = userDAO.existsByEmail(email);
        System.out.println("Service: isEmailTaken result = " + exists);
        return exists;
    }

    @Override
    public boolean isUserExists(int id) {
        System.out.println("Service: isUserExists called with id = " + id);
        boolean exists = userDAO.existsByID(id);
        System.out.println("Service: isUserExists result = " + exists);
        return exists;
    }

    @Override
    public int countUsers() {
        System.out.println("Service: countUsers called");
        int count = userDAO.countUser();
        System.out.println("Service: countUsers result = " + count);
        return count;
    }

    public static void main(String[] args) {
        UserService userService = new UserService();

        try {
            UserService service = new UserService();
            User newUser = new User();
            newUser.setUserName("Nguyen Van B");
            newUser.setPassWord("123456");
            newUser.setFirst_name("Nguyen");
            newUser.setLast_name("B");
            newUser.setBirthday(Date.valueOf("2000-01-01"));
            newUser.setEmail("vana@example.com");
            newUser.setPhone("0123456789");
            newUser.setGender("Nam");
            newUser.setActive(true);
            newUser.setAdmin(false);
            newUser.setCreated_at(Date.valueOf(LocalDate.now()));
            newUser.setUpdate_at(Date.valueOf(LocalDate.now()));
            newUser.setAvatar("avatar.jpg");

            int result = service.createUser(newUser);
            System.out.println("User created with result: " + result);
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi thực sự
        }
    }

}
