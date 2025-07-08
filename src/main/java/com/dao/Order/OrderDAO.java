/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Order;

import com.dao.BaseDAO;
import com.model.Orders;
import jakarta.persistence.EntityManager;
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
    public int insertOrder(Orders order) {
        save(order);
        return 1;
    }

    @Override
    public boolean updateOrder(Orders order) {
        update(order);
        return true;
    }

    @Override
    public boolean deleteOrder(int id) {
        delete(id);
        return true;
    }

    @Override
    public Orders selectOrderById(int id) {
        return find(id);
    }

    @Override
    public List<Orders> selectAllOrder() {
        return findAll();
    }

    @Override
    public List<Orders> selectByUserId(int userId) {
        EntityManager em = getEntityManager();
        return em.createQuery("SELECT o FROM Orders o WHERE o.idUser.idUser = :userId", Orders.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    @Override
    public List<Orders> selectByStatus(String status) {
        EntityManager em = getEntityManager();
        return em.createQuery("SELECT o FROM Orders o WHERE o.status = :status", Orders.class)
                .setParameter("status", status)
                .getResultList();
    }

    @Override
    public List<Orders> selectByDateRange(Date startDate, Date endDate) {
        EntityManager em = getEntityManager();
        return em.createQuery("SELECT o FROM Orders o WHERE o.orderDate BETWEEN :start AND :end", Orders.class)
                .setParameter("start", startDate)
                .setParameter("end", endDate)
                .getResultList();
    }

    @Override
    public int countOrder() {
        return (int) count();
    }

}
