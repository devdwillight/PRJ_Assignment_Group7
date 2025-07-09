/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Todo;

import com.dao.BaseDAO;
import com.model.ToDo;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public class TodoDAO extends BaseDAO<ToDo> implements ITodoDAO {

    public TodoDAO() {
        super(ToDo.class);
    }

    @Override
    public int coutTodo() {
        return (int) count();
    }

    @Override
    public boolean insertTodo(ToDo todo) {
        return save(todo);
    }

    @Override
    public boolean updateTodo(ToDo todo) {
        return update(todo);
    }

    @Override
    public boolean deleteTodo(int id) {
        return delete(id);
    }

    @Override
    public ToDo selectTodoById(int id) {
        return find(id);
    }

    @Override
    public List<ToDo> selectAllTodo() {
        return findAllByEntity("ToDo.findAll");
    }

    @Override
    public List<ToDo> selectByDateRange(Date startDate, Date endDate) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT t FROM ToDo t WHERE t.dueDate  BETWEEN :start AND :end", ToDo.class)
                    .setParameter("start", startDate)
                    .setParameter("end", endDate)
                    .getResultList();

        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }
}
