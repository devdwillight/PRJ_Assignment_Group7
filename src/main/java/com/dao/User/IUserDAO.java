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

    public void updatePassWord(String email, String passWord);

    public int countUser();

    public boolean insertUser(User user);

    public boolean updateUser(User user);

    public boolean deleteUser(int id);

    public boolean existsByEmail(String email);

    public boolean existsByID(int id);

    public User selectUserByID(int id);

    public User selectUserByEmail(String email);

    public List<User> selectAllUsers();

    public List<User> selectUserByPage(int pageNumber, int pageSize);

}
