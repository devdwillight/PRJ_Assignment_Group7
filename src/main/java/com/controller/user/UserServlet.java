/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.user;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author DELL
 */
@WebServlet(name = "UserServelet", urlPatterns = {"/user"})
@MultipartConfig
public class UserServlet extends HttpServlet {

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
            out.println("<title>Servlet UserServelet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserServelet at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");
        if ("editProfile".equals(action)) {
            // Lấy user từ session, sau đó lấy lại user mới nhất từ DB
            com.model.User sessionUser = (com.model.User) request.getSession().getAttribute("user");
            if (sessionUser != null) {
                com.service.User.UserService userService = new com.service.User.UserService();
                com.model.User user = userService.getUserById(sessionUser.getIdUser());
                request.setAttribute("userProfile", user);
            }
            request.getRequestDispatcher("/views/user/profile.jsp").forward(request, response);
            return;
        }
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
        String action = request.getParameter("action");
        if ("updateProfile".equals(action)) {
            // Lấy user từ session
            com.model.User user = (com.model.User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            // Lấy dữ liệu từ form
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String birthday = request.getParameter("birthday");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            System.out.println("[DEBUG] firstName=" + firstName);
            System.out.println("[DEBUG] lastName=" + lastName);
            System.out.println("[DEBUG] birthday=" + birthday);
            System.out.println("[DEBUG] email=" + email);
            System.out.println("[DEBUG] phone=" + phone);
            System.out.println("[DEBUG] gender=" + gender);
            // Kiểm tra email trùng
            com.service.User.UserService userService = new com.service.User.UserService();
            if (!user.getEmail().equals(email) && userService.isEmailTaken(email)) {
                request.setAttribute("error", "Email này đã được sử dụng bởi người dùng khác!");
                request.setAttribute("userProfile", user); // Đảm bảo luôn có userProfile cho JSP
                request.getRequestDispatcher("/views/user/profile.jsp").forward(request, response);
                return;
            }
            // Xử lý avatar (nếu có upload mới)
            String avatar = user.getAvatar();
            if (request.getPart("avatar") != null && request.getPart("avatar").getSize() > 0) {
                java.io.InputStream is = request.getPart("avatar").getInputStream();
                String fileName = java.util.UUID.randomUUID() + "_" + request.getPart("avatar").getSubmittedFileName();
                String uploadPath = request.getServletContext().getRealPath("/uploads/avatar/") + fileName;
                java.nio.file.Files.createDirectories(java.nio.file.Paths.get(request.getServletContext().getRealPath("/uploads/avatar/")));
                java.nio.file.Files.copy(is, java.nio.file.Paths.get(uploadPath), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                avatar = request.getContextPath() + "/uploads/avatar/" + fileName;
            }
            // Cập nhật user object
            user.setFirstName(firstName);
            user.setLastName(lastName);
            try {
                if (birthday != null && !birthday.isEmpty()) {
                    user.setBirthday(new java.text.SimpleDateFormat("yyyy-MM-dd").parse(birthday));
                }
            } catch (Exception e) {
                System.err.println("Lỗi parse ngày sinh: " + birthday);
                e.printStackTrace();
                // Có thể set thông báo lỗi cho user nếu muốn
            }
            user.setEmail(email);
            user.setPhone(phone);
            user.setGender(gender);
            user.setAvatar(avatar);
            user.setUpdatedAt(new java.util.Date());
            // Cập nhật DB
            userService.updateUser(user);
            // Lấy lại user từ DB để đảm bảo data mới nhất
            com.model.User updatedUser = userService.getUserById(user.getIdUser());
            // Cập nhật lại session
            request.getSession().setAttribute("user", updatedUser);
            request.setAttribute("userProfile", updatedUser); // Đảm bảo luôn có userProfile cho JSP
            request.setAttribute("success", "Cập nhật thông tin thành công!");
            request.getRequestDispatcher("/views/user/profile.jsp").forward(request, response);
            return;
        }
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
