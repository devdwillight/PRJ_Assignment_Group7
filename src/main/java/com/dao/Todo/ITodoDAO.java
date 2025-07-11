/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Todo;

import com.model.ToDo;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface ITodoDAO {

    public int countTodo();

    public boolean insertTodo(ToDo todo);

    public boolean updateTodo(ToDo todo);

    public boolean deleteTodo(int id);

    public ToDo selectTodoById(int id);

    public List<ToDo> selectAllTodo();

    public List<ToDo> selectByDateRange(Date startDate, Date endDate);

    public List<ToDo> selectAllToDoByTaskId(int id);

}
