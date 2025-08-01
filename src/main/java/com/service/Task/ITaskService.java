/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Task;

import com.model.Task;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface ITaskService {

    int countTask();

    boolean updateTask(Task task);

    boolean removeTask(int id);

    Task createTask(Task task);

    Task getTaskById(int id);

    List<Task> getAllTasks();

    List<Task> getAllTasksByUserId(int id);
    
    List<Task> getAllTasksByUserIdOrderByPosition(int userId);
    
    boolean updateTaskPosition(int taskId, int newPosition);
    
    int getMaxPositionByUserId(int userId);
    
    boolean reorderTasks(int userId, int oldPosition, int newPosition);
}
