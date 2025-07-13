/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Order;

import com.model.Orders;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface IOrderDAO {

    public int countOrder();

    public boolean insertOrder(Orders order);

    public boolean updateOrder(Orders order);

    public boolean deleteOrder(int id);

    public boolean existsById(int id);

    public Orders selectOrderById(int id);

    public List<Orders> selectAllOrder();

    public List<Orders> selectByStatus(String status);

    public List<Orders> selectByDateRange(Date startDate, Date endDate);

    public List<Orders> selectAllByUserId(int id);

    public boolean updateOrderStatus(Orders order);

}
