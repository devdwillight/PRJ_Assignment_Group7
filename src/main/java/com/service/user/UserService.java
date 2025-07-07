/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.user;

import com.dao.GenericDAO;

import com.model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author DELL
 */
public class UserService implements IUserService {

    private GenericDAO<User> userDAO;

    public UserService() {
        this.userDAO = new GenericDAO<>(User.class);
    }

    @Override
    public void createUser(User user) throws SQLException {
        System.out.println("Service: createUser called with user = " + user);
        userDAO.save(user);
    }

    @Override
    public User getUserById(int id) {
        System.out.println("Service: getUserById called with id = " + id);
        User user = userDAO.findById(id);
        System.out.println("Service: getUserById result = " + user);
        return user;
    }

    @Override
    public User getUserByEmail(String email) {
        EntityManager em = userDAO.getEntityManager();
        User user = null;

        try {
            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.email = :email", User.class);
            query.setParameter("email", email);

            user = query.getSingleResult(); // Có thể ném ra NoResultException nếu không có
        } catch (NoResultException e) {
            // Trả về null nếu không tìm thấy
            user = null;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }

        return user;
    }

    @Override
    public List<User> getAllUsers() {
        System.out.println("Service: getAllUsers called");
        List<User> users = userDAO.findAll();
        System.out.println("Service: getAllUsers found " + users.size() + " users");
        return users;
    }

    @Override
    public List<User> getUsersByPage(int pageNumber, int pageSize) {
        EntityManager em = userDAO.getEntityManager();
        List<User> users = new ArrayList<>();

        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u", User.class);
            query.setFirstResult((pageNumber - 1) * pageSize); // bắt đầu từ vị trí này
            query.setMaxResults(pageSize);                     // lấy tối đa pageSize user

            users = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }

        return users;
    }

    @Override
    public boolean updateUser(User user) throws SQLException {
        System.out.println("Service: updateUser called with user = " + user);
        boolean result = userDAO.update(user);
        System.out.println("Service: updateUser result = " + result);
        return result;
    }

    @Override
    public boolean removeUser(int id) throws SQLException {
        System.out.println("Service: removeUser called with id = " + id);
        boolean result = userDAO.delete(id);
        System.out.println("Service: removeUser result = " + result);
        return result;
    }

    @Override
    public boolean isEmailTaken(String email) {
        EntityManager em = userDAO.getEntityManager();

        try {
            Long count = em.createQuery(
                    "SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class)
                    .setParameter("email", email)
                    .getSingleResult();

            return count > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean isUserExists(int id) {
        EntityManager em = userDAO.getEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(u) FROM User u WHERE u.id = :id", Long.class)
                    .setParameter("id", id)
                    .getSingleResult();

            return count > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public int countUsers() {
        EntityManager em = userDAO.getEntityManager();
        try {
            Long count = em.createQuery("SELECT COUNT(u) FROM User u", Long.class)
                    .getSingleResult();
            return count.intValue();
        } finally {
            em.close();
        }
    }

    public static void main(String[] args) {
        UserService userService = new UserService();

        System.out.println("Danh sách người dùng:");
        List<User> userList = userService.getAllUsers();

        for (User user : userList) {
            System.out.println("ID: " + user.getIdUser()
                    + ", Họ tên: " + user.getFirstName() + " " + user.getLastName()
                    + ", Email: " + user.getEmail()
                    + ", Ngày sinh: " + user.getBirthday());
        }

        System.out.println("Tổng số người dùng: " + userService.countUsers());
    }

}
