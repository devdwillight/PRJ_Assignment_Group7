/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.User;

import com.model.User;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface IUserService {

    void updatePassword(String email, String password);

    User checkLogin(String email, String password);

    int countUsers();

    boolean updateUser(User user);

    boolean removeUser(int id);

    boolean isEmailTaken(String email);

    boolean isUsernameTaken(String username);

    boolean isUserExists(int id);

    User createUser(User user);

    User getUserById(int id);

    User getUserByEmail(String email);

    List<User> getAllUsers();

    List<User> getUsersByPage(int pageNumber, int pageSize);

    int countUsersByMonth(int year, int month);

    List<User> searchUsers(String name, String email, String status);
    
    List<User> searchUsersWithPagination(String name, String email, String status, int pageNumber, int pageSize);
    
    int countSearchResults(String name, String email, String status);

}
