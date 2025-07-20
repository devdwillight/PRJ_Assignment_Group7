/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Task;

import com.model.Task;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface ITaskDAO {

    public int countTask();

    public boolean insertTask(Task task);

    public boolean updateTask(Task task);

    public boolean deleteTask(int id);

    public Task selectTaskById(int id);

    public List<Task> selectAllTasks();

    public List<Task> selectAllByUserId(int id);
    
    public List<Task> selectAllByUserIdOrderByPosition(int userId);
    
    public boolean updateTaskPosition(int taskId, int newPosition);
    
    public int getMaxPositionByUserId(int userId);
    
    public boolean reorderTasks(int userId, int oldPosition, int newPosition);
}
