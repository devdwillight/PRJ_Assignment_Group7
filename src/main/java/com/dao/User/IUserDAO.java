/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.User;

import com.model.User;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface IUserDAO {

    public void updatePassword(String email, String password);

    public User checkLogin(String email, String password);

    public int countUser();

    public boolean insertUser(User user);

    public boolean updateUser(User user);

    public boolean deleteUser(int id);

    public boolean existsByEmail(String email);

    public boolean existsByUsername(String username);

    public boolean existsByID(int id);

    public User selectUserByID(int id);

    public User selectUserByEmail(String email);

    public List<User> selectAllUsers();

    public List<User> selectUserByPage(int pageNumber, int pageSize);

    public int countUsersByMonth(int year, int month);

    public List<User> searchUsers(String name, String email, String status);
    
    public List<User> searchUsersWithPagination(String name, String email, String status, int pageNumber, int pageSize);
    
    public int countSearchResults(String name, String email, String status);

}
