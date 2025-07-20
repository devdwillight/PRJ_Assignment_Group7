/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.User;

import com.dao.BaseDAO;
import com.model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
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
    public int countUser() {
        return (int) count();
    }

    @Override
    public boolean insertUser(User user) {
        return save(user);
    }

    @Override
    public boolean updateUser(User user) {
        return update(user);
    }

    @Override
    public boolean deleteUser(int id) {
        return delete(id);
    }

    @Override
    public boolean existsByID(int id) {
        return find(id) != null;
    }

    @Override
    public boolean existsByEmail(String email) {
        EntityManager em = getEntityManager();
        Long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class)
                .setParameter("email", email)
                .getSingleResult();
        return count > 0;
    }

    @Override
    public boolean existsByUsername(String username) {
        EntityManager em = getEntityManager();
        Long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.username = :username", Long.class)
                .setParameter("username", username)
                .getSingleResult();
        return count > 0;
    }

    @Override
    public User selectUserByID(int id) {
        return find(id);
    }

    @Override
    public User selectUserByEmail(String email) {
        EntityManager em = getEntityManager();
        try {
            return em.createNamedQuery("User.findByEmail", User.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> selectAllUsers() {
        return findAllByEntity("User.findAll");
    }

    @Override
    public List<User> selectUserByPage(int pageNumber, int pageSize) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u ORDER BY u.idUser", User.class)
                    .setFirstResult((pageNumber - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .getResultList();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public void updatePassword(String email, String newPassword) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            int updated = em.createQuery(
                    "UPDATE User u SET u.password = :password WHERE u.email = :email")
                    .setParameter("password", newPassword)
                    .setParameter("email", email)
                    .executeUpdate();
            tx.commit();
            System.out.println("[updatePassword] ✔ Cập nhật thành công cho email: " + email + " (số dòng ảnh hưởng: " + updated + ")");
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            System.err.println("[updatePassword] ✖ Lỗi khi cập nhật mật khẩu:");
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    @Override
    public User checkLogin(String email, String password) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT u FROM User u WHERE u.email = :email AND u.password = :password", User.class)
                    .setParameter("email", email)
                    .setParameter("password", password)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public int countUsersByMonth(int year, int month) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT COUNT(u) FROM User u WHERE YEAR(u.createdAt) = :year AND MONTH(u.createdAt) = :month";
            jakarta.persistence.Query query = em.createQuery(jpql);
            query.setParameter("year", year);
            query.setParameter("month", month);
            return ((Long) query.getSingleResult()).intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> searchUsers(String name, String email, String status) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT u FROM User u WHERE 1=1");
            
            if (name != null && !name.trim().isEmpty()) {
                jpql.append(" AND (u.firstName LIKE :name OR u.lastName LIKE :name OR u.username LIKE :name OR CONCAT(u.firstName, ' ', u.lastName) LIKE :name OR CONCAT(u.lastName, ' ', u.firstName) LIKE :name)");
            }
            
            if (email != null && !email.trim().isEmpty()) {
                jpql.append(" AND u.email LIKE :email");
            }
            
            if (status != null && !status.trim().isEmpty()) {
                if ("active".equals(status)) {
                    jpql.append(" AND u.active = true");
                } else if ("inactive".equals(status)) {
                    jpql.append(" AND u.active = false");
                }
            }
            
            jpql.append(" ORDER BY u.createdAt DESC");
            
            jakarta.persistence.Query query = em.createQuery(jpql.toString(), User.class);
            
            if (name != null && !name.trim().isEmpty()) {
                query.setParameter("name", "%" + name.trim() + "%");
            }
            
            if (email != null && !email.trim().isEmpty()) {
                query.setParameter("email", "%" + email.trim() + "%");
            }
            
            return query.getResultList();
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> searchUsersWithPagination(String name, String email, String status, int pageNumber, int pageSize) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT u FROM User u WHERE 1=1");
            
            if (name != null && !name.trim().isEmpty()) {
                jpql.append(" AND (u.firstName LIKE :name OR u.lastName LIKE :name OR u.username LIKE :name OR CONCAT(u.firstName, ' ', u.lastName) LIKE :name OR CONCAT(u.lastName, ' ', u.firstName) LIKE :name)");
            }
            
            if (email != null && !email.trim().isEmpty()) {
                jpql.append(" AND u.email LIKE :email");
            }
            
            if (status != null && !status.trim().isEmpty()) {
                if ("active".equals(status)) {
                    jpql.append(" AND u.active = true");
                } else if ("inactive".equals(status)) {
                    jpql.append(" AND u.active = false");
                }
            }
            
            jpql.append(" ORDER BY u.createdAt DESC");
            
            jakarta.persistence.Query query = em.createQuery(jpql.toString(), User.class);
            
            if (name != null && !name.trim().isEmpty()) {
                query.setParameter("name", "%" + name.trim() + "%");
            }
            
            if (email != null && !email.trim().isEmpty()) {
                query.setParameter("email", "%" + email.trim() + "%");
            }
            
            // Set pagination
            query.setFirstResult((pageNumber - 1) * pageSize);
            query.setMaxResults(pageSize);
            
            return query.getResultList();
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public int countSearchResults(String name, String email, String status) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT COUNT(u) FROM User u WHERE 1=1");
            
            if (name != null && !name.trim().isEmpty()) {
                jpql.append(" AND (u.firstName LIKE :name OR u.lastName LIKE :name OR u.username LIKE :name OR CONCAT(u.firstName, ' ', u.lastName) LIKE :name OR CONCAT(u.lastName, ' ', u.firstName) LIKE :name)");
            }
            
            if (email != null && !email.trim().isEmpty()) {
                jpql.append(" AND u.email LIKE :email");
            }
            
            if (status != null && !status.trim().isEmpty()) {
                if ("active".equals(status)) {
                    jpql.append(" AND u.active = true");
                } else if ("inactive".equals(status)) {
                    jpql.append(" AND u.active = false");
                }
            }
            
            jakarta.persistence.Query query = em.createQuery(jpql.toString());
            
            if (name != null && !name.trim().isEmpty()) {
                query.setParameter("name", "%" + name.trim() + "%");
            }
            
            if (email != null && !email.trim().isEmpty()) {
                query.setParameter("email", "%" + email.trim() + "%");
            }
            
            return ((Long) query.getSingleResult()).intValue();
            
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

}
