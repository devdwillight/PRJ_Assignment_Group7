/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Task;

import com.dao.BaseDAO;
import com.model.Task;
import java.util.List;

/**
 *
 * @author DELL
 */
public class TaskDAO extends BaseDAO<Task> implements ITaskDAO {

    public TaskDAO() {
        super(Task.class);
    }

    @Override
    public int countTask() {
        return (int) count();
    }

    @Override
    public boolean insertTask(Task task) {
        return save(task);
    }

    @Override
    public boolean updateTask(Task task) {
        return update(task);
    }

    @Override
    public boolean deleteTask(int id) {
        return delete(id);
    }

    @Override
    public Task selectTaskById(int id) {
        return find(id);
    }

    @Override
    public List<Task> selectAllTasks() {
        return findAllByEntity("Task.findAll");
    }

    @Override
    public List<Task> selectAllByUserId(int id) {
        return findAllById("idUser", id);
    }

}
