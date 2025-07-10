/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.login;

import com.constant.GoogleLogin;
import com.entity.GoogleAccount;
import com.model.User;
import com.service.User.UserService;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */

@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    UserService userService = new UserService();
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
        String code = request.getParameter("code");
        GoogleLogin gl = new GoogleLogin();
        String accessToken = gl.getToken(code);
        System.out.println(accessToken);
        GoogleAccount googleAccount = gl.getUserInfo(accessToken);
        System.out.println(googleAccount);
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
        response.setContentType("text/html;charset=UTF-8");
        String code = request.getParameter("code");
        GoogleLogin gl = new GoogleLogin();
        String accessToken = gl.getToken(code);
        System.out.println(accessToken);
        GoogleAccount googleAccount = gl.getUserInfo(accessToken);
        System.out.println(googleAccount);
        getLogin(request, response);
        request.setAttribute("googleName", googleAccount);
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
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            case "login":
                checkLogin(request, response);
                break;
            case "logout":
                logout(request, response);
                break;
        }
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

    private void getLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            return;
        }

        String rememberedUser = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    rememberedUser = cookie.getValue();
                }
            }
        }
        request.setAttribute("rememberedUser", rememberedUser);

        RequestDispatcher dispatcher = request.getRequestDispatcher("home.jsp");
        dispatcher.forward(request, response);
    }

    private void checkLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
    String username = request.getParameter("email");
    String password = request.getParameter("password");
    String remember = request.getParameter("remember_me");
    
    // DEBUG: In ra giá trị để kiểm tra
    System.out.println("Username: " + username);
    System.out.println("Password: " + password);
    System.out.println("Remember: '" + remember + "'"); // Để thấy giá trị chính xác
    
    User user = userService.checkLogin(username, password);
    
    if (user.getEmail().equals(username) && user.getPassword().equals(password)) {
        // Lưu thông tin người dùng vào session
        HttpSession session = request.getSession(true);
        session.setAttribute("user_email", username);
        
        int maxAge = 7 * 24 * 60 * 60; // 7 ngày
        
        // Kiểm tra nhiều trường hợp có thể của checkbox
        if ("true".equals(remember) || "true".equals(remember) || remember != null) {
            System.out.println("SAVING COOKIES - Remember me is checked");
            Cookie userCookie = new Cookie("user_email", username);
            Cookie passCookie = new Cookie("user_password", password);
            userCookie.setMaxAge(maxAge);
            passCookie.setMaxAge(maxAge);
            response.addCookie(userCookie);
            response.addCookie(passCookie);
        } else {
            System.out.println("NOT SAVING PASSWORD - Remember me is NOT checked");
            // Không tick "Remember me": lưu email, xóa password
            Cookie userCookie = new Cookie("user_email", username);
            Cookie passCookie = new Cookie("user_password", "");
            userCookie.setMaxAge(maxAge); // Lưu email 7 ngày
            passCookie.setMaxAge(0);      // Xóa password
            response.addCookie(userCookie);
            response.addCookie(passCookie);
        }
        
        // Chuyển hướng về trang home.jsp sau khi đăng nhập thành công
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    } else {
        // Nếu đăng nhập không hợp lệ, hiển thị lỗi
        request.setAttribute("error", "1");
        request.getRequestDispatcher("views/login/login.jsp").forward(request, response);
    }
}
   

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Xóa session người dùng
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Hủy session
        }

        // Xóa cookie nếu có
//        Cookie userCookie = new Cookie("username", "");
//        Cookie passCookie = new Cookie("password", "");
//        userCookie.setMaxAge(0);  // Đặt thời gian sống cookie về 0 để xóa cookie
//        passCookie.setMaxAge(0);
//        response.addCookie(userCookie);
//        response.addCookie(passCookie);

        response.sendRedirect("views/login/login.jsp");
    }
}
