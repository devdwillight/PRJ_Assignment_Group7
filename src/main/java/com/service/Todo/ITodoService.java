/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Todo;

import com.model.ToDo;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface ITodoService {

    int countTodo();

    boolean updateTodo(ToDo todo);

    boolean removeTodo(int id);

    ToDo createTodo(ToDo todo);

    ToDo getToDoById(int id);

    List<ToDo> getAllToDo();
    
     List<ToDo> getToDoByTaskId(int id);

    List<ToDo> getByDateRange(Date startDate, Date endDate);
    
    List<ToDo> getAllToDoByUserId(int userId);

}
