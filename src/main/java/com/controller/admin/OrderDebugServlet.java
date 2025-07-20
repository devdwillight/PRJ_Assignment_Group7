package com.controller.admin;

import com.service.Order.OrderService;
import com.model.Orders;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderDebugServlet", urlPatterns = {"/admin/orders/debug"})
public class OrderDebugServlet extends HttpServlet {

    private final OrderService orderService;

    public OrderDebugServlet() {
        this.orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lấy tất cả đơn hàng
            List<Orders> orderList = orderService.getAllOrder();
            
            // Tạo HTML response
            StringBuilder html = new StringBuilder();
            html.append("<!DOCTYPE html>");
            html.append("<html><head><title>Debug Orders</title></head><body>");
            html.append("<h1>Debug Orders</h1>");
            html.append("<p>Tổng số đơn hàng: ").append(orderList.size()).append("</p>");
            
            if (orderList.isEmpty()) {
                html.append("<p style='color: red;'>⚠️ Không có đơn hàng nào trong database!</p>");
                html.append("<p>Hãy chạy script SQL để thêm dữ liệu test:</p>");
                html.append("<pre>");
                html.append("INSERT INTO Orders (id_user, status, payment_method, payment_time, TotalAmount) VALUES ");
                html.append("(1, 'Processing', 'Credit Card', GETDATE(), 1500000), ");
                html.append("(2, 'Completed', 'PayPal', GETDATE(), 2500000), ");
                html.append("(3, 'Failed', 'Bank Transfer', GETDATE(), 1800000);");
                html.append("</pre>");
            } else {
                html.append("<table border='1' style='border-collapse: collapse; width: 100%;'>");
                html.append("<tr><th>ID</th><th>User</th><th>Status</th><th>Payment Method</th><th>Amount</th><th>Payment Time</th></tr>");
                
                for (Orders order : orderList) {
                    html.append("<tr>");
                    html.append("<td>").append(order.getIdOrder()).append("</td>");
                    html.append("<td>");
                    if (order.getIdUser() != null) {
                        html.append(order.getIdUser().getFirstName()).append(" ").append(order.getIdUser().getLastName());
                    } else {
                        html.append("N/A");
                    }
                    html.append("</td>");
                    html.append("<td>").append(order.getStatus() != null ? order.getStatus() : "N/A").append("</td>");
                    html.append("<td>").append(order.getPaymentMethod() != null ? order.getPaymentMethod() : "N/A").append("</td>");
                    html.append("<td>").append(order.getTotalAmount()).append("</td>");
                    html.append("<td>").append(order.getPaymentTime() != null ? order.getPaymentTime() : "N/A").append("</td>");
                    html.append("</tr>");
                }
                html.append("</table>");
            }
            
            html.append("<br><a href='").append(request.getContextPath()).append("/admin/orders'>Quay lại trang quản lý</a>");
            html.append("</body></html>");
            
            response.getWriter().write(html.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<h1>Lỗi</h1><p>" + e.getMessage() + "</p>");
        }
    }
} 