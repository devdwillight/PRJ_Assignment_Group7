/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.calendar;
 import java.io.IOException;
 import java.io.PrintWriter;

import com.model.Orders;
import com.model.UserCourse;

import jakarta.servlet.ServletException;
 import jakarta.servlet.annotation.WebServlet;
 import jakarta.servlet.http.HttpServlet;
 import jakarta.servlet.http.HttpServletRequest;
 import jakarta.servlet.http.HttpServletResponse;
 import com.service.Order.OrderService;
 import com.service.Course.CourseService;
 import com.model.Course;
 import com.service.UserCourse.UserCourseService;
 import java.util.List;
 
 /**
  *
  * @author DELL
  */
 @WebServlet(urlPatterns = {"/calendar/add"})
 public class AddCalendarServlet extends HttpServlet {
 
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
             out.println("<title>Servlet AddCalendarServlet</title>");
             out.println("</head>");
             out.println("<body>");
             out.println("<h1>Servlet AddCalendarServlet at " + request.getContextPath() + "</h1>");
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
         String orderId = request.getParameter("orderId");
        OrderService orderService = new OrderService();

        Orders order = orderService.getOrderById(Integer.parseInt(orderId));
        
        int userId = order.getIdUser().getIdUser();
        UserCourseService userCourseService = new UserCourseService();
        List<UserCourse> userCourses = userCourseService.getAllUserCoursesByUserId(userId);

        // Sắp xếp theo enrollDate giảm dần, lấy bản ghi đầu tiên
        UserCourse latestUserCourse = userCourses.stream()
            .sorted((a, b) -> b.getEnrollDate().compareTo(a.getEnrollDate()))
            .findFirst()
            .orElse(null);
        int courseId = latestUserCourse.getIdCourse().getIdCourse();
        CourseService courseService = new CourseService();
        Course course = courseService.getCourseById(courseId);
        String courseName = course.getName();
        String frequency = course.getFrequency(); // Lấy frequency
         request.setAttribute("orderId", orderId);
         request.setAttribute("courseName", courseName);
         request.setAttribute("frequency", frequency); // Truyền sang JSP
         request.getRequestDispatcher("/views/calendar/CourseCalendar.jsp").forward(request, response);
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
 