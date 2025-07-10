/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.login;

import com.dao.TokenForget.TokenForgetDao;
import com.dao.User.UserDAO;
import com.entity.TokenForgetPassword;
import com.model.User;
import com.service.User.UserService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "requestPassword", urlPatterns = {"/requestPassword"})
public class RequestPassword extends HttpServlet {

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
            out.println("<title>Servlet requestPassword</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet requestPassword at " + request.getContextPath() + "</h1>");
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
        UserService userService = new UserService();
        String email = request.getParameter("email");
        User user = userService.getUserByEmail(email);
        if (user == null) {
            request.setAttribute("mess", "email khong ton tai");
            request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);
            return;
        }

        ResetService service = new ResetService();
        String token = service.generateToken();
        String linkReset = "http://localhost:9999/PRJ_Assignment_toidaiii/resetPassword?token=" + token;
        TokenForgetPassword tokenForgetPassword = new TokenForgetPassword(
                user.getIdUser(), false, token, service.expireDateTime());

        //send link to this email
        TokenForgetDao daoToken = new TokenForgetDao();
        boolean isInser = daoToken.insertTokenForget(tokenForgetPassword);
        if (!isInser) {
            request.setAttribute("mess", "have error in server");
            request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);
            return;
        }
        boolean isSend = service.sendEmail(email, linkReset, user.getUsername());
        if (!isSend) {
            request.setAttribute("mess", "cannot send request");
            request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);
            return;
        }
        request.setAttribute("mess", "send request success");
        request.getRequestDispatcher("views/login/requestPassword.jsp").forward(request, response);
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
