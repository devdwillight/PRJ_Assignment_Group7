/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Order;

import com.dao.BaseDAO;
import com.model.Orders;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public class OrderDAO extends BaseDAO<Orders> implements IOrderDAO {

    public OrderDAO() {
        super(Orders.class);
    }

    @Override
    public int countOrder() {
        return (int) count();
    }

    @Override
    public boolean insertOrder(Orders order) {
        return save(order);
    }

    @Override
    public boolean updateOrder(Orders order) {
        return update(order);
    }

    @Override
    public boolean deleteOrder(int id) {
        return delete(id);
    }

    @Override
    public boolean existsById(int id) {
        return find(id) != null;
    }

    @Override
    public Orders selectOrderById(int id) {
        return find(id);
    }

    @Override
    public List<Orders> selectAllOrder() {
        return findAllByEntity("Orders.findAll");
    }

    @Override
    public List<Orders> selectByStatus(String status) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT o FROM Orders o WHERE o.status = :status", Orders.class)
                    .setParameter("status", status)
                    .getResultList();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Orders> selectByDateRange(Date startDate, Date endDate) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT o FROM Orders o WHERE o.paymentTime  BETWEEN :start AND :end", Orders.class)
                    .setParameter("start", startDate)
                    .setParameter("end", endDate)
                    .getResultList();

        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Orders> selectByPaymentMethod(String paymentMethod) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT o FROM Orders o WHERE o.paymentMethod = :paymentMethod", Orders.class)
                    .setParameter("paymentMethod", paymentMethod)
                    .getResultList();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Orders> selectAllByUserId(int id) {
        return findAllById("idUser", id);
    }

    @Override
    public boolean updateOrderStatus(Orders order) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Orders existingOrder = em.find(Orders.class, order.getIdOrder());
            if (existingOrder != null) {
                existingOrder.setStatus(order.getStatus());
                em.merge(existingOrder);
                em.getTransaction().commit();
                return true;
            }
            return false;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.out.println(ex);
            return false;
        } finally {
            em.close();
        }
    }
}
