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

    void updatePassWord(String email, String passWord);

    User checkLogin(String email, String passWord);
    
    int countUsers();

    boolean updateUser(User user);

    boolean removeUser(int id);

    boolean isEmailTaken(String email);

    boolean isUserExists(int id);

    User createUser(User user);

    User getUserById(int id);

    User getUserByEmail(String email);

    List<User> getAllUsers();

    List<User> getUsersByPage(int pageNumber, int pageSize);

}
