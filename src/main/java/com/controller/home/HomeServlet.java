/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.home;

import com.model.Calendar;
import com.model.Task;
import com.service.Calendar.CalendarService;
import com.service.Task.TaskService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Date;
import java.text.SimpleDateFormat;

/**
 *
 * @author DELL
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    private CalendarService calendarService;
    private TaskService taskService;

    @Override
    public void init() throws ServletException {
        calendarService = new CalendarService();
        taskService = new TaskService();
    }

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
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet HomeServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomeServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            // Nếu chưa đăng nhập, chuyển hướng về trang login
            response.sendRedirect("views/login/login.jsp");
            return;
        }
        
        try {
            // Lấy dữ liệu từ database
            List<Calendar> calendars = calendarService.getAllCalendarByUserId(userId);
            List<Task> todos = taskService.getAllTasksByUserId(userId);
            
            // Tạo dữ liệu calendar cơ bản cho tuần hiện tại
            Date currentDate = new Date();
            SimpleDateFormat isoFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
            String currentDateStr = isoFormat.format(currentDate);
            
            // Tạo dữ liệu tuần mặc định
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(currentDate);
            
            // Tìm ngày đầu tuần (Chủ nhật)
            cal.set(java.util.Calendar.DAY_OF_WEEK, java.util.Calendar.SUNDAY);
            Date startOfWeek = cal.getTime();
            
            // Set attributes cho JSP
            request.setAttribute("calendars", calendars);
            request.setAttribute("todos", todos);
            request.setAttribute("currentDate", currentDateStr);
            request.setAttribute("startOfWeek", startOfWeek);
            request.setAttribute("userId", userId);
            
            // Forward đến home.jsp
            request.getRequestDispatcher("home.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log lỗi
            System.err.println("Error in HomeServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Vẫn forward đến home.jsp với dữ liệu rỗng
            Date currentDate = new Date();
            SimpleDateFormat isoFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
            String currentDateStr = isoFormat.format(currentDate);
            
            request.setAttribute("calendars", java.util.Collections.emptyList());
            request.setAttribute("todos", java.util.Collections.emptyList());
            request.setAttribute("currentDate", currentDateStr);
            request.setAttribute("startOfWeek", new Date());
            request.setAttribute("userId", userId);
            request.setAttribute("error", "Không thể tải dữ liệu từ database");
            
            request.getRequestDispatcher("home.jsp").forward(request, response);
        }
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
        return "Home Servlet - Loads user calendar and task data";
    }// </editor-fold>

}
