/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Task;

import com.dao.BaseDAO;
import com.model.Task;
import java.util.List;
import jakarta.persistence.EntityManager;
import java.util.ArrayList;

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
    
    @Override
    public List<Task> selectAllByUserIdOrderByPosition(int userId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT t FROM Task t WHERE t.idUser.idUser = :userId ORDER BY t.position ASC", Task.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean updateTaskPosition(int taskId, int newPosition) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            int updatedRows = em.createQuery("UPDATE Task t SET t.position = :position WHERE t.idTask = :taskId")
                    .setParameter("position", newPosition)
                    .setParameter("taskId", taskId)
                    .executeUpdate();
            em.getTransaction().commit();
            return updatedRows > 0;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
    
    @Override
    public int getMaxPositionByUserId(int userId) {
        EntityManager em = getEntityManager();
        try {
            Object result = em.createQuery("SELECT MAX(t.position) FROM Task t WHERE t.idUser.idUser = :userId")
                    .setParameter("userId", userId)
                    .getSingleResult();
            return result != null ? (Integer) result : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean reorderTasks(int userId, int oldPosition, int newPosition) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            
            if (oldPosition < newPosition) {
                // Di chuyển xuống: giảm position của các task từ oldPosition+1 đến newPosition
                em.createQuery("UPDATE Task t SET t.position = t.position - 1 WHERE t.idUser.idUser = :userId AND t.position > :oldPosition AND t.position <= :newPosition")
                        .setParameter("userId", userId)
                        .setParameter("oldPosition", oldPosition)
                        .setParameter("newPosition", newPosition)
                        .executeUpdate();
            } else {
                // Di chuyển lên: tăng position của các task từ newPosition đến oldPosition-1
                em.createQuery("UPDATE Task t SET t.position = t.position + 1 WHERE t.idUser.idUser = :userId AND t.position >= :newPosition AND t.position < :oldPosition")
                        .setParameter("userId", userId)
                        .setParameter("oldPosition", oldPosition)
                        .setParameter("newPosition", newPosition)
                        .executeUpdate();
            }
            
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
}
