/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.vnpay.common;

import com.dao.Order.OrderDAO;
import com.model.Course;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import com.model.Orders;
import com.model.User;
import com.model.UserCourse;
import com.service.Course.CourseService;
import com.service.UserCourse.UserCourseService;
import jakarta.servlet.http.HttpSession;
import static java.lang.System.out;

/**
 *
 * @author HP
 */
@WebServlet(name = "VnpayReturn", urlPatterns = {"/vnpayReturn"})
public class VnpayReturn extends HttpServlet {

    OrderDAO orderDao = new OrderDAO();
    UserCourseService userCourseService = new UserCourseService();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try {
                Map fields = new HashMap();
                for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                    String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII.toString());
                    String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                    if ((fieldValue != null) && (fieldValue.length() > 0)) {
                        fields.put(fieldName, fieldValue);
                    }
                }

                String vnp_SecureHash = request.getParameter("vnp_SecureHash");
                if (fields.containsKey("vnp_SecureHashType")) {
                    fields.remove("vnp_SecureHashType");
                }
                if (fields.containsKey("vnp_SecureHash")) {
                    fields.remove("vnp_SecureHash");
                }
                String signValue = Config.hashAllFields(fields);
                if (signValue.equals(vnp_SecureHash)) {
                    String paymentCode = request.getParameter("vnp_TransactionNo");

                    String vnp_TxnRef = request.getParameter("vnp_TxnRef");
                    String[] parts = vnp_TxnRef.split("_");
                    int orderId = Integer.parseInt(parts[0]);
                    int courseId = Integer.parseInt(parts[1]);

                    Orders order = orderDao.selectOrderById(orderId);

                    User user = order.getIdUser();

                    CourseService courseService = new CourseService();
                    Course course = courseService.getCourseById(courseId);

                    boolean transSuccess = false;
                    if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                        //update banking system
                        order.setStatus("Completed");
                        transSuccess = true;

                        UserCourse userCourse = new UserCourse();
                        userCourse.setIdUser(user);
                        userCourse.setIdCourse(course);
                        userCourse.setEnrollDate(new java.util.Date());
                        userCourseService.createUserCourse(userCourse);

                        // đoạn này thì sẽ gọi hàm add user và course ở orderDao vào bảng user_course để map xem user nào có khóa nào
                    } else {
                        order.setStatus("Failed");
                    }
                    orderDao.updateOrderStatus(order);
                    request.setAttribute("transResult", transSuccess);
                    request.getRequestDispatcher("views/vnpay/paymentResult.jsp").forward(request, response);
                } else {
                    //RETURN PAGE ERROR
                    System.out.println("GD KO HOP LE (invalid signature)");
                }
            } catch (Exception e) {
                out.println("<pre>");
                e.printStackTrace(out);   
                out.println("</pre>");
            }
        }
    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</cod  e> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
