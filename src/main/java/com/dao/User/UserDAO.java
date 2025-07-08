/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.User;

import com.dao.BaseDAO;
import com.model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.util.List;

/**
 *
 * @author DELL
 */
public class UserDAO extends BaseDAO<User> implements IUserDAO {

    public UserDAO() {
        super(User.class);
    }

    @Override
    public int insertUser(User user) {
        save(user); // kế thừa từ BaseDAO
        return 1;
    }

    @Override
    public boolean updateUser(User user) {
        update(user);
        return true;
    }

    @Override
    public boolean deleteUser(int id) {
        delete(id);
        return true;
    }

    @Override
    public User selectUserByID(int id) {
        return find(id);
    }

    @Override
    public List<User> selectAllUsers() {
        return findAll();
    }

    @Override
    public int countUser() {
        return (int) count();
    }

    @Override
    public boolean existsByID(int ID) {
        return find(ID) != null;
    }

    @Override
    public User selectUserByEmail(String email) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> selectUserByPage(int pageNumber, int pageSize) {
        EntityManager em = getEntityManager();
        return em.createQuery("SELECT u FROM User u ORDER BY u.idUser", User.class)
                .setFirstResult((pageNumber - 1) * pageSize)
                .setMaxResults(pageSize)
                .getResultList();
    }

    @Override
    public boolean existsByEmail(String email) {
        EntityManager em = getEntityManager();
        Long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class)
                .setParameter("email", email)
                .getSingleResult();
        return count > 0;
    }

}
