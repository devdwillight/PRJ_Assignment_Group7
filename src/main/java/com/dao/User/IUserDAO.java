/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.User;

import com.model.User;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface IUserDAO {

    public int insertUser(User user) throws SQLException;

    public User selectUserByID(int id);

    public List<User> selectAllUsers();

    public boolean updateUser(User user) throws SQLException;

    public boolean deleteUser(int id) throws SQLException;

    public boolean existsByEmail(String email);

    public boolean existsByID(int ID);

    public int countUser();

    public User selectUserByEmail(String email);

    public List<User> selectUserByPage(int pageNumber, int pageSize);

}
