/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Order;

import com.model.Orders;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface IOrderService {

    int countOrder();

    boolean updateOrder(Orders order);

    boolean removeOrder(int id);

    boolean isOrderExists(int id);

    Orders createOrder(Orders order);

    Orders getOrderById(int id);

    List<Orders> getAllOrder();

    List<Orders> getByStatus(String status);

    List<Orders> getByDateRange(Date startDate, Date endDate);

    List<Orders> getAllOrderByUserId(int id);
    
    boolean updateOrderStatus(Orders order);
}
