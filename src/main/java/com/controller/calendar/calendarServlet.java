/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.calendar;

import com.model.Calendar;
import com.model.Task;
import com.model.UserEvents;
import com.service.Calendar.CalendarService;
import com.service.Task.TaskService;
import com.service.Event.EventService;
import java.io.IOException;
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
    private TaskService taskService;
    private EventService eventService;

    @Override
    public void init() throws ServletException {
        calendarService = new CalendarService();
        taskService = new TaskService();
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
        } else if ("create".equals(action)) {
            // Hiển thị form thêm mới calendar
            request.getRequestDispatcher("views/calendar/addCalendar.jsp").forward(request, response);
            return;
        } else if ("edit".equals(action)) {
            // Hiển thị form chỉnh sửa calendar
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int calendarIdEdit = Integer.parseInt(idParam);
                    Calendar calendar = calendarService.getCalendarById(calendarIdEdit);
                    request.setAttribute("calendar", calendar);
                } catch (Exception e) {
                    // Có thể log lỗi hoặc xử lý thông báo
                }
            }
            request.getRequestDispatcher("views/calendar/addCalendar.jsp").forward(request, response);
            return;
        }

        // Load dữ liệu cho sidebar và calendar (thay thế HomeServlet)
        loadUserData(request, userId);
        
        // Forward đến home.jsp thay vì calendar.jsp
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

    /**
     * Load dữ liệu user cho sidebar và calendar
     */
    private void loadUserData(HttpServletRequest request, Integer userId) {
        try {
            // Lấy calendars và tasks cho sidebar
            List<Calendar> calendars = calendarService.getAllCalendarByUserId(userId);
            List<Task> todos = taskService.getAllTasksByUserId(userId);
            
            // Set attributes cho JSP
            request.setAttribute("calendars", calendars);
            request.setAttribute("todos", todos);
            request.setAttribute("userId", userId);
            
        } catch (Exception e) {
            System.err.println("Error loading user data: " + e.getMessage());
            e.printStackTrace();
            
            // Set dữ liệu rỗng nếu có lỗi
            request.setAttribute("calendars", new ArrayList<>());
            request.setAttribute("todos", new ArrayList<>());
            request.setAttribute("userId", userId);
            request.setAttribute("error", "Không thể tải dữ liệu từ database");
        }
    }

    private void handleGetEvents(HttpServletRequest request, HttpServletResponse response, Integer userId) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            String calendarIdParam = request.getParameter("calendarId");
            Integer calendarId = null;
            
            System.out.println("[CalendarServlet] Loading events for user ID: " + userId);
            System.out.println("[CalendarServlet] Calendar ID parameter: " + calendarIdParam);
            
            if (calendarIdParam != null && !calendarIdParam.isEmpty()) {
                calendarId = Integer.parseInt(calendarIdParam);
            } else {
                // Lấy calendar đầu tiên của user
                List<Calendar> calendars = calendarService.getAllCalendarByUserId(userId);
                if (!calendars.isEmpty()) {
                    calendarId = calendars.get(0).getIdCalendar();
                }
            }
            
            System.out.println("[CalendarServlet] Final calendar ID: " + calendarId);
            
            List<UserEvents> events = (calendarId != null)
                ? eventService.getAllEventsByCalendarId(calendarId)
                : new ArrayList<>();

            System.out.println("[CalendarServlet] Found " + events.size() + " events");
            for (UserEvents e : events) {
                System.out.println("  - Event ID: " + e.getIdEvent() + ", Name: " + e.getName() + ", Calendar: " + (e.getIdCalendar() != null ? e.getIdCalendar().getIdCalendar() : "null"));
            }

            // Tạo JSON response
            StringBuilder jsonResponse = new StringBuilder("[");
            for (int i = 0; i < events.size(); i++) {
                UserEvents e = events.get(i);
                jsonResponse.append("{")
                    .append("\"id\":").append(e.getIdEvent()).append(",")
                    .append("\"title\":\"").append(e.getName()).append("\",")
                    .append("\"start\":\"").append(e.getStartDate() != null ? e.getStartDate().toInstant().toString() : "").append("\",")
                    .append("\"end\":\"").append(e.getDueDate() != null ? e.getDueDate().toInstant().toString() : "").append("\",")
                    .append("\"color\":\"").append(e.getColor() != null ? e.getColor() : "#3b82f6").append("\",")
                    .append("\"calendarId\":").append(e.getIdCalendar() != null ? e.getIdCalendar().getIdCalendar() : "null").append(",")
                    .append("\"calendarName\":\"").append(e.getIdCalendar() != null ? e.getIdCalendar().getName() : "").append("\",")
                    .append("\"allDay\":").append(e.getIsAllDay() != null && e.getIsAllDay() ? "true" : "false").append(",")
                    .append("\"isRecurring\":").append(e.getIsRecurring() != null && e.getIsRecurring() ? "true" : "false").append(",")
                    .append("\"rrule\":").append(e.getRecurrenceRule() != null ? "\"" + e.getRecurrenceRule() + "\"" : "null").append(",")
                    .append("\"remindMethod\":").append(e.getRemindMethod() != null ? e.getRemindMethod() : 0).append(",")
                    .append("\"remindBefore\":").append(e.getRemindBefore() != null ? e.getRemindBefore() : 0).append(",")
                    .append("\"remindUnit\":").append(e.getRemindUnit() != null ? "\"" + e.getRemindUnit() + "\"" : "null").append(",")
                    .append("\"description\":\"").append(e.getDescription() != null ? e.getDescription().replace("\"", "\\\"") : "").append("\",")
                    .append("\"location\":\"").append(e.getLocation() != null ? e.getLocation().replace("\"", "\\\"") : "").append("\"")
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
                    .append("\"start\":\"").append(e.getStartDate() != null ? e.getStartDate().toInstant().toString() : "").append("\",")
                    .append("\"end\":\"").append(e.getDueDate() != null ? e.getDueDate().toInstant().toString() : "").append("\",")
                    .append("\"color\":\"").append(e.getColor() != null ? e.getColor() : "#3b82f6").append("\",")
                    .append("\"calendarId\":").append(e.getIdCalendar() != null ? e.getIdCalendar().getIdCalendar() : "null").append(",")
                    .append("\"calendarName\":\"").append(e.getIdCalendar() != null ? e.getIdCalendar().getName() : "").append("\",")
                    .append("\"allDay\":").append(e.getIsAllDay() != null && e.getIsAllDay() ? "true" : "false").append(",")
                    .append("\"isRecurring\":").append(e.getIsRecurring() != null && e.getIsRecurring() ? "true" : "false").append(",")
                    .append("\"rrule\":").append(e.getRecurrenceRule() != null ? "\"" + e.getRecurrenceRule() + "\"" : "null").append(",")
                    .append("\"remindMethod\":").append(e.getRemindMethod() != null ? e.getRemindMethod() : 0).append(",")
                    .append("\"remindBefore\":").append(e.getRemindBefore() != null ? e.getRemindBefore() : 0).append(",")
                    .append("\"remindUnit\":").append(e.getRemindUnit() != null ? "\"" + e.getRemindUnit() + "\"" : "null").append(",")
                    .append("\"description\":\"").append(e.getDescription() != null ? e.getDescription().replace("\"", "\\\"") : "").append("\",")
                    .append("\"location\":\"").append(e.getLocation() != null ? e.getLocation().replace("\"", "\\\"") : "").append("\"")
                    .append("}");
                if (i < events.size() - 1) jsonResponse.append(",");
            }
            jsonResponse.append("]");
            
            System.out.println("[CalendarServlet] JSON response: " + jsonResponse.toString());
            response.getWriter().write(jsonResponse.toString());
            
        } catch (Exception e) {
            System.err.println("[CalendarServlet] Error loading events: " + e.getMessage());
            e.printStackTrace();
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
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("views/login/login.jsp");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) action = "";
        switch (action) {
            case "create": {
                handleCreateCalendar(request, response, userId); // redirect như cũ
                return;
            }
            case "createAjax": {
                handleCreateCalendarAjax(request, response, userId); // trả về JSON
                return;
            }
            case "edit": {
                handleEditCalendar(request, response, userId);
                return;
            }
            case "delete": {
                handleDeleteCalendar(request, response, userId);
                return;
            }
        }
    }

    private void handleCreateCalendar(HttpServletRequest request, HttpServletResponse response, Integer userId) throws IOException {
        String name = request.getParameter("name");
        String color = request.getParameter("color");
        com.model.Calendar calendar = new com.model.Calendar();
        calendar.setName(name);
        calendar.setColor(color);
        com.model.User user = new com.model.User(userId);
        calendar.setIdUser(user);
        calendarService.createCalendar(calendar);
        response.sendRedirect(request.getContextPath() + "/calendar");
    }

    private void handleCreateCalendarAjax(HttpServletRequest request, HttpServletResponse response, Integer userId) throws IOException {
        String name = request.getParameter("name");
        String color = request.getParameter("color");
        com.model.Calendar calendar = new com.model.Calendar();
        calendar.setName(name);
        calendar.setColor(color);
        com.model.User user = new com.model.User(userId);
        calendar.setIdUser(user);
        calendarService.createCalendar(calendar);

        // Trả về JSON chứa id của calendar vừa tạo
        response.setContentType("application/json");
        response.getWriter().write("{\"calendarId\":" + calendar.getIdCalendar() + "}");
    }

    private void handleEditCalendar(HttpServletRequest request, HttpServletResponse response, Integer userId) throws IOException {
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String color = request.getParameter("color");
        if (idParam != null) {
            try {
                int calendarId = Integer.parseInt(idParam);
                com.model.Calendar calendar = calendarService.getCalendarById(calendarId);
                if (calendar != null && calendar.getIdUser() != null && calendar.getIdUser().getIdUser().equals(userId)) {
                    calendar.setName(name);
                    calendar.setColor(color);
                    calendarService.updateCalendar(calendar);
                }
            } catch (Exception e) {
                // Có thể log lỗi hoặc xử lý thông báo
            }
        }
        response.sendRedirect(request.getContextPath() + "/calendar");
    }

    private void handleDeleteCalendar(HttpServletRequest request, HttpServletResponse response, Integer userId) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int calendarId = Integer.parseInt(idParam);
                com.model.Calendar calendar = calendarService.getCalendarById(calendarId);
                if (calendar != null && calendar.getIdUser() != null && calendar.getIdUser().getIdUser().equals(userId)) {
                    System.out.println("Bắt đầu gọi removeCalendar...");
                    boolean result = calendarService.removeCalendar(calendarId);
                    System.out.println("Kết quả xóa: " + result);
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("Lỗi khi xóa calendar: " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/calendar");
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
