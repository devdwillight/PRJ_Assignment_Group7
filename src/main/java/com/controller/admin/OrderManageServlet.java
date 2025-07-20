package com.controller.admin;

import com.service.Order.OrderService;
import com.model.Orders;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "OrderManageServlet", urlPatterns = {"/admin/orders"})
public class OrderManageServlet extends HttpServlet {

    private final OrderService orderService;

    public OrderManageServlet() {
        this.orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Kiểm tra nếu có action=getOrder để lấy thông tin order chi tiết
            String action = request.getParameter("action");
            if ("getOrder".equals(action)) {
                handleGetOrder(request, response);
                return;
            }
            
            // Lấy các tham số tìm kiếm
            String searchStatus = request.getParameter("searchStatus");
            String searchPaymentMethod = request.getParameter("searchPaymentMethod");
            String searchDateFrom = request.getParameter("searchDateFrom");
            String searchDateTo = request.getParameter("searchDateTo");
            
            // Lấy tham số pagination
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // Số order mỗi trang
            int pageSize = 15;
            
            List<Orders> orderList;
            int totalOrders;
            int totalPages;
            
            // Xử lý tìm kiếm theo ngày
            Date dateFrom = null;
            Date dateTo = null;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            
            if (searchDateFrom != null && !searchDateFrom.trim().isEmpty()) {
                try {
                    dateFrom = sdf.parse(searchDateFrom);
                } catch (Exception e) {
                    // Ignore parse error
                }
            }
            
            if (searchDateTo != null && !searchDateTo.trim().isEmpty()) {
                try {
                    dateTo = sdf.parse(searchDateTo);
                } catch (Exception e) {
                    // Ignore parse error
                }
            }
            
            // Lấy danh sách đơn hàng
            if (searchStatus != null && !searchStatus.trim().isEmpty()) {
                orderList = orderService.getByStatus(searchStatus);
            } else if (searchPaymentMethod != null && !searchPaymentMethod.trim().isEmpty()) {
                orderList = orderService.getByPaymentMethod(searchPaymentMethod);
            } else if (dateFrom != null && dateTo != null) {
                orderList = orderService.getByDateRange(dateFrom, dateTo);
            } else {
                orderList = orderService.getAllOrder();
            }
            
            // Đảm bảo orderList không null
            if (orderList == null) {
                orderList = List.of();
            }
            
            totalOrders = orderList.size();
            totalPages = (int) Math.ceil((double) totalOrders / pageSize);
            
            // Phân trang
            int startIndex = (currentPage - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalOrders);
            
            if (startIndex < totalOrders) {
                orderList = orderList.subList(startIndex, endIndex);
            } else {
                orderList = List.of();
            }
            
            // Đặt danh sách order vào request attribute
            request.setAttribute("orderList", orderList);
            
            // Đặt thông tin pagination
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("pageSize", pageSize);
            
            // Đặt lại các giá trị tìm kiếm để hiển thị trong form
            request.setAttribute("searchStatus", searchStatus != null ? searchStatus : "");
            request.setAttribute("searchPaymentMethod", searchPaymentMethod != null ? searchPaymentMethod : "");
            request.setAttribute("searchDateFrom", searchDateFrom != null ? searchDateFrom : "");
            request.setAttribute("searchDateTo", searchDateTo != null ? searchDateTo : "");
            
            // Xử lý thông báo từ URL parameter
            String error = request.getParameter("error");
            String message = request.getParameter("message");
            if (error != null && !error.isEmpty()) {
                request.setAttribute("error", error);
            }
            if (message != null && !message.isEmpty()) {
                request.setAttribute("message", message);
            }
            
            // Forward đến trang manageOrder.jsp
            request.getRequestDispatcher("/views/admin/order/manageOrder.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi, vẫn forward nhưng với danh sách rỗng
            request.setAttribute("orderList", null);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalOrders", 0);
            request.setAttribute("pageSize", 15);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách đơn hàng: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/order/manageOrder.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            handleDeleteOrder(request, response);
        } else if ("updateStatus".equals(action)) {
            handleUpdateOrderStatus(request, response);
        } else {
            // Nếu không có action, chuyển về doGet
            doGet(request, response);
        }
    }

    private void handleDeleteOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            boolean success = orderService.removeOrder(orderId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?message=" + java.net.URLEncoder.encode("Xóa đơn hàng thành công!", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=" + java.net.URLEncoder.encode("Không thể xóa đơn hàng!", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=" + java.net.URLEncoder.encode("ID đơn hàng không hợp lệ!", "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=" + java.net.URLEncoder.encode("Có lỗi xảy ra: " + e.getMessage(), "UTF-8"));
        }
    }

    private void handleUpdateOrderStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");
            
            if (newStatus == null || newStatus.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=" + java.net.URLEncoder.encode("Trạng thái không được để trống!", "UTF-8"));
                return;
            }
            
            Orders order = new Orders();
            order.setIdOrder(orderId);
            order.setStatus(newStatus);
            
            boolean success = orderService.updateOrderStatus(order);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?message=" + java.net.URLEncoder.encode("Cập nhật trạng thái đơn hàng thành công!", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=" + java.net.URLEncoder.encode("Không thể cập nhật trạng thái đơn hàng!", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=" + java.net.URLEncoder.encode("ID đơn hàng không hợp lệ!", "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=" + java.net.URLEncoder.encode("Có lỗi xảy ra: " + e.getMessage(), "UTF-8"));
        }
    }
    
    private void handleGetOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            Orders order = orderService.getOrderById(orderId);
            
            if (order != null) {
                // Trả về JSON response
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String jsonResponse = String.format(
                    "{\"id\":%d,\"status\":\"%s\",\"paymentMethod\":\"%s\",\"paymentTime\":\"%s\",\"totalAmount\":\"%s\",\"userId\":%d,\"userName\":\"%s\"}",
                    order.getIdOrder(),
                    order.getStatus() != null ? order.getStatus().replace("\"", "\\\"") : "",
                    order.getPaymentMethod() != null ? order.getPaymentMethod().replace("\"", "\\\"") : "",
                    order.getPaymentTime() != null ? sdf.format(order.getPaymentTime()) : "",
                    String.valueOf(order.getTotalAmount()),
                    order.getIdUser() != null ? order.getIdUser().getIdUser() : 0,
                    order.getIdUser() != null ? (order.getIdUser().getFirstName() + " " + order.getIdUser().getLastName()).replace("\"", "\\\"") : ""
                );
                
                response.getWriter().write(jsonResponse);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }
} 