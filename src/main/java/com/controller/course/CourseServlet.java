/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.course;

import com.model.Course;
import com.model.User;
import com.service.Course.CourseService;
import com.service.UserCourse.UserCourseService;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

/**
 *
 * @author DELL
 */
@WebServlet(name = "CourseServlet", urlPatterns = {"/Course"})
public class CourseServlet extends HttpServlet {

    CourseService courseService = new CourseService();

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
            out.println("<title>Servlet CourseServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseServlet at " + request.getContextPath() + "</h1>");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String sort = request.getParameter("sort");
        String[] categories = request.getParameterValues("category");

        List<String> allCategories = courseService.getAllCategoryNames();
        List<Course> allCourses = courseService.filterCourses(search, sort, categories);

        jakarta.servlet.http.HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        List<Course> boughtCourses = null;
        List<Course> notBought = new ArrayList<>();
        List<Course> bought = new ArrayList<>();
        if (user != null) {
            UserCourseService userCourseService = new UserCourseService();
            boughtCourses = userCourseService.getCoursesByUserId(user.getIdUser());
            Set<Integer> boughtIds = boughtCourses.stream().map(Course::getIdCourse).collect(Collectors.toSet());
            for (Course c : allCourses) {
                if (boughtIds.contains(c.getIdCourse())) bought.add(c); else notBought.add(c);
            }
        } else {
            notBought.addAll(allCourses);
        }
        request.setAttribute("allCategories", allCategories);
        request.setAttribute("notBought", notBought);
        request.setAttribute("bought", bought);
        request.getRequestDispatcher("views/vnpay/course_list.jsp").forward(request, response);
    }

//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        // Lấy danh sách sản phẩm từ cơ sở dữ liệu
//        List<Course> courses = courseService.getAllCourses(); // Giả sử phương thức này trả về danh sách sản phẩm
//
//        // Đặt sản phẩm vào attribute của request
//        request.setAttribute("courses", courses);
//
//        // Chuyển tiếp đến JSP
//        RequestDispatcher dispatcher = request.getRequestDispatcher("views/vnpay/course_list.jsp");
//        dispatcher.forward(request, response);
//    }
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
