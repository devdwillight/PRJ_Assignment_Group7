/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.calendar;

import com.model.Calendar;
import com.model.UserEvents;
import com.service.Calendar.CalendarService;
import com.service.Event.EventService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;

/**
 *
 * @author DELL
 */
@WebServlet(name = "calendarServlet", urlPatterns = {"/calendar"})
public class calendarServlet extends HttpServlet {

    private CalendarService calendarService;
    private EventService eventService;

    @Override
    public void init() throws ServletException {
        calendarService = new CalendarService();
        eventService = new EventService();
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
            out.println("<title>Servlet calendarServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet calendarServlet at " + request.getContextPath() + "</h1>");
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
            response.sendRedirect("views/login/login.jsp");
            return;
        }

        // Kiểm tra nếu là API call để lấy events
        String action = request.getParameter("action");
        if ("getEvents".equals(action)) {
            handleGetEvents(request, response, userId);
            return;
        } else if ("getAllEvents".equals(action)) {
            handleGetAllEvents(request, response, userId);
            return;
        }

        // Lấy danh sách calendar của user
        List<Calendar> calendars = calendarService.getAllCalendarByUserId(userId);

        // Lấy calendarId từ request (nếu có), mặc định lấy calendar đầu tiên
        String calendarIdParam = request.getParameter("calendarId");
        Integer calendarId = null;
        if (calendarIdParam != null && !calendarIdParam.isEmpty()) {
            calendarId = Integer.parseInt(calendarIdParam);
        } else if (!calendars.isEmpty()) {
            calendarId = calendars.get(0).getIdCalendar();
        }

        // Lấy events theo calendarId
        List<UserEvents> events = (calendarId != null)
            ? eventService.getAllEventsByCalendarId(calendarId)
            : new ArrayList<>();

        // Chuyển events sang JSON cho FullCalendar
        StringBuilder eventsJson = new StringBuilder("[");
        for (int i = 0; i < events.size(); i++) {
            UserEvents e = events.get(i);
            eventsJson.append("{")
                .append("\"id\":").append(e.getIdEvent()).append(",")
                .append("\"title\":\"").append(e.getName()).append("\",")
                .append("\"start\":\"").append(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(e.getStartDate())).append("\",")
                .append("\"end\":\"").append(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(e.getDueDate())).append("\",")
                .append("\"color\":\"").append(e.getColor() != null ? e.getColor() : "#3b82f6").append("\"")
                .append("}");
            if (i < events.size() - 1) eventsJson.append(",");
        }
        eventsJson.append("]");

        // Truyền dữ liệu sang JSP
        request.setAttribute("calendars", calendars);
        request.setAttribute("calendarId", calendarId);
        request.setAttribute("eventsJson", eventsJson.toString());
        request.getRequestDispatcher("views/calendar/calendar.jsp").forward(request, response);
    }

    private void handleGetEvents(HttpServletRequest request, HttpServletResponse response, Integer userId) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            String calendarIdParam = request.getParameter("calendarId");
            Integer calendarId = null;
            
            if (calendarIdParam != null && !calendarIdParam.isEmpty()) {
                calendarId = Integer.parseInt(calendarIdParam);
            } else {
                // Lấy calendar đầu tiên của user
                List<Calendar> calendars = calendarService.getAllCalendarByUserId(userId);
                if (!calendars.isEmpty()) {
                    calendarId = calendars.get(0).getIdCalendar();
                }
            }
            
            List<UserEvents> events = (calendarId != null)
                ? eventService.getAllEventsByCalendarId(calendarId)
                : new ArrayList<>();

            // Tạo JSON response
            StringBuilder jsonResponse = new StringBuilder("[");
            for (int i = 0; i < events.size(); i++) {
                UserEvents e = events.get(i);
                jsonResponse.append("{")
                    .append("\"id\":").append(e.getIdEvent()).append(",")
                    .append("\"title\":\"").append(e.getName()).append("\",")
                    .append("\"start\":\"").append(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(e.getStartDate())).append("\",")
                    .append("\"end\":\"").append(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(e.getDueDate())).append("\",")
                    .append("\"color\":\"").append(e.getColor() != null ? e.getColor() : "#3b82f6").append("\"")
                    .append("}");
                if (i < events.size() - 1) jsonResponse.append(",");
            }
            jsonResponse.append("]");
            
            response.getWriter().write(jsonResponse.toString());
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Không thể tải dữ liệu events\"}");
        }
    }

    private void handleGetAllEvents(HttpServletRequest request, HttpServletResponse response, Integer userId) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            // Lấy tất cả events của user
            List<UserEvents> events = eventService.getAllEventsByUserId(userId);

            // Tạo JSON response với thông tin calendar
            StringBuilder jsonResponse = new StringBuilder("[");
            for (int i = 0; i < events.size(); i++) {
                UserEvents e = events.get(i);
                jsonResponse.append("{")
                    .append("\"id\":").append(e.getIdEvent()).append(",")
                    .append("\"title\":\"").append(e.getName()).append("\",")
                    .append("\"start\":\"").append(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(e.getStartDate())).append("\",")
                    .append("\"end\":\"").append(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(e.getDueDate())).append("\",")
                    .append("\"color\":\"").append(e.getColor() != null ? e.getColor() : "#3b82f6").append("\",")
                    .append("\"calendarId\":").append(e.getIdCalendar() != null ? e.getIdCalendar().getIdCalendar() : "null").append(",")
                    .append("\"calendarName\":\"").append(e.getIdCalendar() != null ? e.getIdCalendar().getName() : "").append("\"")
                    .append("}");
                if (i < events.size() - 1) jsonResponse.append(",");
            }
            jsonResponse.append("]");
            
            response.getWriter().write(jsonResponse.toString());
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Không thể tải dữ liệu events\"}");
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
        return "Calendar Servlet - Loads calendar and events data";
    }// </editor-fold>

}
