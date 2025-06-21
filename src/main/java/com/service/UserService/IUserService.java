/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.UserService;

import java.sql.SQLException;
import model.user.User;

/**
 *
 * @author DELL
 */
public interface IUserService {
    
    public void addUser(User user) throws SQLException;
    
    
}
