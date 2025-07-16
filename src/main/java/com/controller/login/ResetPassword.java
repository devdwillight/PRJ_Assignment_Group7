/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.login;

import com.dao.TokenForget.TokenForgetDao;
import com.dao.User.UserDAO;
import com.entity.TokenForgetPassword;
import com.model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "resetPassword", urlPatterns = {"/resetPassword"})
public class ResetPassword extends HttpServlet {

    TokenForgetDao DAOToken = new TokenForgetDao();
    UserDAO DAOUser = new UserDAO();

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
            out.println("<title>Servlet resetPassword</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet resetPassword at " + request.getContextPath() + "</h1>");
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
        String token = request.getParameter("token");
        TokenForgetDao tokenForgetDao = new TokenForgetDao();
        UserDAO userDao = new UserDAO();
        HttpSession session = request.getSession();
        if (token != null) {
            TokenForgetPassword tokenForgetPassword = tokenForgetDao.getTokenPassword(token);
            ResetService service = new ResetService();
            if (tokenForgetPassword == null) {
                request.setAttribute("mess", "token invalid");
                request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);
                return;
            }
            if (tokenForgetPassword.isIsUsed()) {
                request.setAttribute("mess", "token is used");
                request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);
                return;
            }
            if (service.isExpireTime(tokenForgetPassword.getExpiryTime())) {
                request.setAttribute("mess", "token is expired time");
                request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);
                return;
            }
            User user = userDao.selectUserByID(tokenForgetPassword.getUserId());
            request.setAttribute("email", user.getEmail());
            session.setAttribute("token", tokenForgetPassword.getToken());
            request.getRequestDispatcher("views/login/resetPassword.jsp").forward(request, response);
            return;
        } else {
            request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);

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
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (email == null || password == null || confirmPassword == null) {
            request.setAttribute("mess", "Fill all information");
            request.getRequestDispatcher("views/login/resetPassword.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("mess", "Confirm password must match password");
            request.setAttribute("email", email);
            request.getRequestDispatcher("views/login/resetPassword.jsp").forward(request, response);
            return;
        }

        if (password.length() < 8) {
            request.setAttribute("mess", "Password must be at least 8 characters");
            request.setAttribute("email", email);
            request.getRequestDispatcher("views/login/resetPassword.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        String tokenStr = (String) session.getAttribute("token");

        if (tokenStr == null) {
            request.setAttribute("mess", "Session expired or invalid token");
            request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);
            return;
        }

        TokenForgetPassword tokenForgetPassword = DAOToken.getTokenPassword(tokenStr);
        ResetService service = new ResetService();

        if (tokenForgetPassword == null) {
            request.setAttribute("mess", "Token invalid");
            request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);
            return;
        }

        if (tokenForgetPassword.isIsUsed()) {
            request.setAttribute("mess", "Token already used");
            request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);
            return;
        }

        if (service.isExpireTime(tokenForgetPassword.getExpiryTime())) {
            request.setAttribute("mess", "Token expired");
            request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);
            return;
        }

        // Update token status and user password
        tokenForgetPassword.setIsUsed(true);
        DAOUser.updatePassword(email, password);
        DAOToken.updateStatus(tokenForgetPassword);

        // Gửi thông báo và chuyển hướng
        request.setAttribute("mess", "Password changed successfully");
        request.getRequestDispatcher("home.jsp").forward(request, response);
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
