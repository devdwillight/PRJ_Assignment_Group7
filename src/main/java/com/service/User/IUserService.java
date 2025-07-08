/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.User;

import com.model.User;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface IUserService {

    int createUser(User user) throws SQLException;

    User getUserById(int id);

    User getUserByEmail(String email);

    List<User> getAllUsers();

    List<User> getUsersByPage(int pageNumber, int pageSize);

    boolean updateUser(User user) throws SQLException;

    boolean removeUser(int id) throws SQLException;

    boolean isEmailTaken(String email);

    boolean isUserExists(int id);

    int countUsers();

}
