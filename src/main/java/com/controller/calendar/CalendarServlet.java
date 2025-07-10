/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.calendar;

import com.model.Calendar;
import com.service.Calendar.CalendarService;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author DELL
 */
@WebServlet(name = "CalendarServlet", urlPatterns = {"/Calendar"})
public class CalendarServlet extends HttpServlet {

    private final CalendarService calendarService;

    public CalendarServlet() {
        this.calendarService = new CalendarService();
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
            out.println("<title>Servlet CalendarServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CalendarServlet at " + request.getContextPath() + "</h1>");
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
        try {
            // Lấy danh sách lịch từ service
            List<Calendar> calendars = calendarService.getAllCalendar();

            // Lấy user ID từ session (nếu có)
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            // Nếu có user ID, lấy lịch theo user
            if (userId != null) {
                calendars = calendarService.getCalendarByUserId(userId);
            }

            // Đặt danh sách lịch vào request attribute
            request.setAttribute("calendars", calendars);

            // Chuyển hướng đến JSP
            request.getRequestDispatcher("/views/calendar/Calendar.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Lỗi trong CalendarServlet doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi server");
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
        try {
            String action = request.getParameter("action");

            if (action == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số action");
                return;
            }

            switch (action) {
                case "create":
                    createCalendar(request, response);
                    break;
                case "update":
                    updateCalendar(request, response);
                    break;
                case "delete":
                    deleteCalendar(request, response);
                    break;
                case "getById":
                    getCalendarById(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action không hợp lệ");
                    break;
            }

        } catch (Exception e) {
            System.err.println("Lỗi trong CalendarServlet doPost: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi server");
        }
    }

    private void createCalendar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin từ request
            String name = request.getParameter("name");
            String color = request.getParameter("color");

            // Lấy user ID từ session
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Chưa đăng nhập");
                return;
            }

            // Tạo đối tượng Calendar
            Calendar calendar = new Calendar();
            calendar.setName(name);
            calendar.setColor(color);

            // Lưu vào database
            Calendar savedCalendar = calendarService.createCalendar(calendar);

            if (savedCalendar != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"message\": \"Tạo lịch thành công\", \"calendarId\": " + savedCalendar.getIdCalendar() + "}");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tạo lịch");
            }

        } catch (Exception e) {
            System.err.println("Lỗi tạo lịch: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tạo lịch");
        }
    }

    private void updateCalendar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin từ request
            int calendarId = Integer.parseInt(request.getParameter("calendarId"));
            String name = request.getParameter("name");
            String color = request.getParameter("color");

            // Lấy lịch hiện tại
            Calendar calendar = calendarService.getCalendarById(calendarId);
            if (calendar == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy lịch");
                return;
            }

            // Cập nhật thông tin
            calendar.setName(name);
            calendar.setColor(color);

            // Lưu vào database
            boolean success = calendarService.updateCalendar(calendar);

            if (success) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"message\": \"Cập nhật lịch thành công\"}");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể cập nhật lịch");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID lịch không hợp lệ");
        } catch (Exception e) {
            System.err.println("Lỗi cập nhật lịch: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cập nhật lịch");
        }
    }

    private void deleteCalendar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy ID lịch từ request
            int calendarId = Integer.parseInt(request.getParameter("calendarId"));

            // Xóa lịch
            boolean success = calendarService.removeCalendar(calendarId);

            if (success) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"message\": \"Xóa lịch thành công\"}");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy lịch để xóa");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID lịch không hợp lệ");
        } catch (Exception e) {
            System.err.println("Lỗi xóa lịch: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xóa lịch");
        }
    }

    private void getCalendarById(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy ID lịch từ request
            int calendarId = Integer.parseInt(request.getParameter("calendarId"));

            // Lấy thông tin lịch
            Calendar calendar = calendarService.getCalendarById(calendarId);

            if (calendar != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"calendar\": {\"id\": " + calendar.getIdCalendar()
                        + ", \"name\": \"" + calendar.getName() + "\", \"color\": \"" + calendar.getColor() + "\"}}");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy lịch");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID lịch không hợp lệ");
        } catch (Exception e) {
            System.err.println("Lỗi lấy thông tin lịch: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi lấy thông tin lịch");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Calendar Servlet - Quản lý lịch trình";
    }// </editor-fold>

}
