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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Collections;

/**
 * Servlet xử lý trang chủ - tải dữ liệu calendar và task của user
 * @author DELL
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    private static final String LOGIN_PAGE = "views/login/login.jsp";
    private static final String HOME_PAGE = "home.jsp";
    
    private CalendarService calendarService;
    private TaskService taskService;

    @Override
    public void init() throws ServletException {
        calendarService = new CalendarService();
        taskService = new TaskService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isUserLoggedIn(request)) {
            response.sendRedirect(LOGIN_PAGE);
            return;
        }

        try {
            Integer userId = getUserIdFromSession(request);
            loadUserData(request, userId);
            request.getRequestDispatcher(HOME_PAGE).forward(request, response);
            
        } catch (Exception e) {
            handleError(request, response, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST method không được sử dụng trong trang chủ
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    /**
     * Kiểm tra user đã đăng nhập chưa
     */
    private boolean isUserLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession();
        return session.getAttribute("user_id") != null;
    }

    /**
     * Lấy user ID từ session
     */
    private Integer getUserIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession();
        return (Integer) session.getAttribute("user_id");
    }

    /**
     * Tải dữ liệu user từ database
     */
    private void loadUserData(HttpServletRequest request, Integer userId) {
        // Lấy calendars và tasks cho sidebar
        List<Calendar> calendars = calendarService.getAllCalendarByUserId(userId);
        List<Task> todos = taskService.getAllTasksByUserId(userId);
        
        // Set attributes cho JSP
        setRequestAttributes(request, calendars, todos, userId);
    }

    /**
     * Set attributes cho request
     */
    private void setRequestAttributes(HttpServletRequest request, 
                                    List<Calendar> calendars, 
                                    List<Task> todos, 
                                    Integer userId) {
        request.setAttribute("calendars", calendars);
        request.setAttribute("todos", todos);
        request.setAttribute("userId", userId);
    }

    /**
     * Xử lý lỗi
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, Exception e) 
            throws ServletException, IOException {
        
        System.err.println("Error in HomeServlet: " + e.getMessage());
        e.printStackTrace();
        
        // Set dữ liệu rỗng và thông báo lỗi
        Integer userId = getUserIdFromSession(request);
        
        setRequestAttributes(request, 
                           Collections.emptyList(), 
                           Collections.emptyList(), 
                           userId);
        request.setAttribute("error", "Không thể tải dữ liệu từ database");
        
        request.getRequestDispatcher(HOME_PAGE).forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Home Servlet - Loads user calendar and task data";
    }
}
