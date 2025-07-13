/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Order;

import com.dao.Order.OrderDAO;
import com.model.Orders;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public class OrderService implements IOrderService {

    private final OrderDAO orderDAO;

    public OrderService() {
        this.orderDAO = new OrderDAO();
    }

    @Override
    public int countOrder() {
        int count = orderDAO.countOrder();
        System.out.println("[countOrder] Tổng số đơn hàng: " + count);
        return count;
    }

    @Override
    public boolean updateOrder(Orders order) {
        System.out.println("[updateOrder] Cập nhật đơn hàng ID = " + order.getIdOrder());
        boolean success = orderDAO.updateOrder(order);
        System.out.println("[updateOrder] " + (success ? "✔ Thành công" : "✖ Thất bại"));
        return success;
    }

    @Override
    public boolean removeOrder(int id) {
        System.out.println("[removeOrder] Xoá đơn hàng ID = " + id);
        boolean success = orderDAO.deleteOrder(id);
        System.out.println("[removeOrder] " + (success ? "✔ Đã xoá" : "✖ Không tìm thấy"));
        return success;
    }

    @Override
    public boolean isOrderExists(int id) {
        boolean exists = orderDAO.existsById(id);
        System.out.println("[isOrderExists] Kiểm tra tồn tại đơn hàng ID = " + id + ": " + exists);
        return exists;
    }

    @Override
    public Orders createOrder(Orders order) {
        System.out.println("[createOrder] Tạo đơn hàng mới");
        if (orderDAO.insertOrder(order)) {
            System.out.println("[createOrder] ✔ Đã tạo đơn hàng với ID = " + order.getIdOrder());
            return order;
        } else {
            System.out.println("[createOrder] ✖ Không thể tạo đơn hàng");
            return null;
        }
    }

    @Override
    public Orders getOrderById(int id) {
        System.out.println("[getOrderById] Truy xuất đơn hàng theo ID = " + id);
        Orders order = orderDAO.selectOrderById(id);
        if (order != null) {
            System.out.println("[getOrderById] ✔ Tìm thấy đơn hàng.");
        } else {
            System.out.println("[getOrderById] ✖ Không tìm thấy đơn hàng.");
        }
        return order;
    }

    @Override
    public List<Orders> getAllOrder() {
        System.out.println("[getAllOrder] Lấy danh sách toàn bộ đơn hàng");
        List<Orders> list = orderDAO.selectAllOrder();
        System.out.println("[getAllOrder] ✔ Số lượng đơn hàng: " + list.size());
        return list;
    }

    @Override
    public List<Orders> getByStatus(String status) {
        System.out.println("[getByStatus] Lọc đơn hàng theo trạng thái: " + status);
        List<Orders> list = orderDAO.selectByStatus(status);
        System.out.println("[getByStatus] ✔ Tìm thấy " + list.size() + " đơn hàng");
        return list;
    }

    @Override
    public List<Orders> getByDateRange(Date startDate, Date endDate) {
        System.out.println("[getByDateRange] Lọc đơn hàng từ " + startDate + " đến " + endDate);
        List<Orders> list = orderDAO.selectByDateRange(startDate, endDate);
        System.out.println("[getByDateRange] ✔ Tìm thấy " + list.size() + " đơn hàng");
        return list;
    }

    @Override
    public List<Orders> getAllOrderByUserId(int id) {
        System.out.println("[getAllOrderByUserId] Lấy danh sách toàn bộ đơn hàng");
        List<Orders> list = orderDAO.selectAllByUserId(id);
        System.out.println("[getAllOrderByUserId] ✔ Số lượng đơn hàng: " + list.size());
        return list;
    }

    @Override
    public boolean updateOrderStatus(Orders order) {
        System.out.println("[updateOrderStatus] Cập nhật trạng thái đơn hàng ID = " + order.getIdOrder() + " thành: "
                + order.getStatus());
        boolean success = orderDAO.updateOrderStatus(order);
        System.out.println("[updateOrderStatus] " + (success ? "✔ Thành công" : "✖ Thất bại"));
        return success;
    }

    // 🧪 Test nhanh
    public static void main(String[] args) {
        OrderService service = new OrderService();

        System.out.println("=== 🧪 TEST UPDATE ORDER STATUS ===");

        // Test 1: Lấy danh sách đơn hàng hiện tại
        List<Orders> orders = service.getAllOrderByUserId(1);
        System.out.println("\n📋 Danh sách đơn hàng hiện tại:");
        for (Orders o : orders) {
            System.out.println("ID: " + o.getIdOrder() + ", Trạng thái: " + o.getStatus());
        }

        // Test 2: Cập nhật trạng thái đơn hàng đầu tiên
        if (!orders.isEmpty()) {
            Orders firstOrder = orders.get(0);
            System.out.println("\n🔄 Test cập nhật trạng thái đơn hàng ID: " + firstOrder.getIdOrder());
            System.out.println("Trạng thái cũ: " + firstOrder.getStatus());

            // Tạo order mới với status mới
            Orders updateOrder = new Orders();
            updateOrder.setIdOrder(firstOrder.getIdOrder());
            updateOrder.setStatus("Đã giao hàng");

            // Thực hiện cập nhật
            boolean success = service.updateOrderStatus(updateOrder);

            if (success) {
                System.out.println("✅ Cập nhật thành công!");

                // Kiểm tra lại trạng thái sau khi cập nhật
                Orders updatedOrder = service.getOrderById(firstOrder.getIdOrder());
                System.out.println("Trạng thái mới: " + updatedOrder.getStatus());
            } else {
                System.out.println("❌ Cập nhật thất bại!");
            }
        } else {
            System.out.println("⚠️ Không có đơn hàng nào để test!");
        }

        // Test 3: Thống kê tổng quan
        System.out.println("\n📊 Thống kê:");
        System.out.println("Tổng đơn hàng: " + service.countOrder());

        // Test 4: Lọc theo trạng thái
        System.out.println("\n🔍 Test lọc theo trạng thái 'Đã giao hàng':");
        List<Orders> deliveredOrders = service.getByStatus("Đã giao hàng");
        System.out.println("Số đơn hàng đã giao: " + deliveredOrders.size());

        System.out.println("\n=== 🎯 TEST HOÀN THÀNH ===");
    }
}
