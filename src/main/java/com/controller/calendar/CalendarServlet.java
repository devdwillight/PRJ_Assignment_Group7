/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.calendar;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.BufferedReader;

/**
 *
 * @author DELL
 */
@WebServlet(name = "CalendarServlet", urlPatterns = {"/Calendar"})
public class CalendarServlet extends HttpServlet {

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
        String view = request.getParameter("view");
        String dateStr = request.getParameter("date");
        String action = request.getParameter("action");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        try {
            if ("getEvents".equals(action)) {
                // Lấy events cho một khoảng thời gian
                Map<String, Object> eventsData = getEventsForPeriod(dateStr, view);
                out.print(gson.toJson(eventsData));
            } else if ("week".equals(view) && dateStr != null) {
                // Tạo dữ liệu tuần
                Map<String, Object> weekData = generateWeekData(dateStr);
                out.print(gson.toJson(weekData));
            } else if ("day".equals(view) && dateStr != null) {
                // Tạo dữ liệu ngày
                Map<String, Object> dayData = generateDayData(dateStr);
                out.print(gson.toJson(dayData));
            } else if ("month".equals(view) && dateStr != null) {
                // Tạo dữ liệu tháng
                Map<String, Object> monthData = generateMonthData(dateStr);
                out.print(gson.toJson(monthData));
            } else {
                // Response mặc định
                Map<String, Object> defaultResponse = new HashMap<>();
                defaultResponse.put("status", "success");
                defaultResponse.put("message", "Calendar API is working");
                out.print(gson.toJson(defaultResponse));
            }
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(errorResponse));
        }
        out.flush();
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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        try {
            // Đọc JSON từ request body
            BufferedReader reader = request.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            JsonObject jsonRequest = new JsonParser().parse(sb.toString()).getAsJsonObject();
            String action = jsonRequest.has("action") ? jsonRequest.get("action").getAsString() : "";

            Map<String, Object> result = new HashMap<>();

            switch (action) {
                case "createEvent":
                    result = createEvent(jsonRequest);
                    break;
                case "updateEvent":
                    result = updateEvent(jsonRequest);
                    break;
                case "deleteEvent":
                    result = deleteEvent(jsonRequest);
                    break;
                default:
                    result.put("status", "error");
                    result.put("message", "Unknown action");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }

            out.print(gson.toJson(result));
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(errorResponse));
        }
        out.flush();
    }

//     * Tạo dữ liệu tuần từ ngày được chọn
    private Map<String, Object> generateWeekData(String dateStr) throws Exception {
        SimpleDateFormat isoFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        Date targetDate = isoFormat.parse(dateStr);

        Calendar cal = Calendar.getInstance();
        cal.setTime(targetDate);

        // Tìm ngày đầu tuần (Chủ nhật)
        cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
        Date startOfWeek = cal.getTime();

        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> days = new ArrayList<>();
        List<Integer> hours = new ArrayList<>();

        // Tạo 7 ngày trong tuần
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Calendar today = Calendar.getInstance();

        for (int i = 0; i < 7; i++) {
            Calendar dayCal = Calendar.getInstance();
            dayCal.setTime(startOfWeek);
            dayCal.add(Calendar.DAY_OF_MONTH, i);

            Map<String, Object> day = new HashMap<>();
            day.put("date", dateFormat.format(dayCal.getTime()));
            day.put("label", getDayLabel(i));
            day.put("dayOfMonth", dayCal.get(Calendar.DAY_OF_MONTH));
            day.put("isToday", dayCal.get(Calendar.YEAR) == today.get(Calendar.YEAR)
                    && dayCal.get(Calendar.DAY_OF_YEAR) == today.get(Calendar.DAY_OF_YEAR));

            days.add(day);
        }

        // Tạo 24 giờ
        for (int i = 0; i < 24; i++) {
            hours.add(i);
        }

        result.put("days", days);
        result.put("hours", hours);
        result.put("status", "success");

        return result;
    }

//     * Tạo dữ liệu ngày
    private Map<String, Object> generateDayData(String dateStr) throws Exception {
        SimpleDateFormat isoFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        Date targetDate = isoFormat.parse(dateStr);

        Map<String, Object> result = new HashMap<>();
        List<Integer> hours = new ArrayList<>();

        // Tạo 24 giờ
        for (int i = 0; i < 24; i++) {
            hours.add(i);
        }

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        result.put("date", dateFormat.format(targetDate));
        result.put("hours", hours);
        result.put("status", "success");

        return result;
    }

//     * Tạo dữ liệu tháng
    private Map<String, Object> generateMonthData(String dateStr) throws Exception {
        SimpleDateFormat isoFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        Date targetDate = isoFormat.parse(dateStr);

        Calendar cal = Calendar.getInstance();
        cal.setTime(targetDate);

        // Tìm ngày đầu tháng
        cal.set(Calendar.DAY_OF_MONTH, 1);
        Date startOfMonth = cal.getTime();

        // Tìm ngày cuối tháng
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        Date endOfMonth = cal.getTime();

        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> days = new ArrayList<>();

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Calendar today = Calendar.getInstance();

        // Tạo lịch tháng (6 tuần x 7 ngày = 42 ngày)
        Calendar tempCal = Calendar.getInstance();
        tempCal.setTime(startOfMonth);

        // Điều chỉnh về đầu tuần (Chủ nhật)
        while (tempCal.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY) {
            tempCal.add(Calendar.DAY_OF_MONTH, -1);
        }

        for (int i = 0; i < 42; i++) {
            Map<String, Object> day = new HashMap<>();
            day.put("date", dateFormat.format(tempCal.getTime()));
            day.put("dayOfMonth", tempCal.get(Calendar.DAY_OF_MONTH));
            day.put("isCurrentMonth", tempCal.get(Calendar.MONTH) == cal.get(Calendar.MONTH));
            day.put("isToday", tempCal.get(Calendar.YEAR) == today.get(Calendar.YEAR)
                    && tempCal.get(Calendar.DAY_OF_YEAR) == today.get(Calendar.DAY_OF_YEAR));

            days.add(day);
            tempCal.add(Calendar.DAY_OF_MONTH, 1);
        }

        result.put("days", days);
        result.put("status", "success");

        return result;
    }

//     * Lấy events cho một khoảng thời gian
    private Map<String, Object> getEventsForPeriod(String dateStr, String view) throws Exception {
        // TODO: Implement actual event fetching from database
        // Hiện tại trả về dữ liệu mẫu
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> events = new ArrayList<>();

        // Tạo một số events mẫu
        Map<String, Object> event1 = new HashMap<>();
        event1.put("id", 1);
        event1.put("title", "Họp nhóm dự án");
        event1.put("start", "2025-01-15T09:00:00");
        event1.put("end", "2025-01-15T10:30:00");
        event1.put("color", "#4285f4");
        events.add(event1);

        Map<String, Object> event2 = new HashMap<>();
        event2.put("id", 2);
        event2.put("title", "Lớp học online");
        event2.put("start", "2025-01-15T14:00:00");
        event2.put("end", "2025-01-15T16:00:00");
        event2.put("color", "#34a853");
        events.add(event2);

        result.put("events", events);
        result.put("status", "success");

        return result;
    }

//     * Tạo event mới
    private Map<String, Object> createEvent(JsonObject request) {
        Map<String, Object> result = new HashMap<>();

        try {
            // TODO: Implement actual event creation in database
            String title = request.get("title").getAsString();
            String start = request.get("start").getAsString();
            String end = request.get("end").getAsString();

            // Giả lập tạo event thành công
            result.put("status", "success");
            result.put("message", "Event created successfully");
            result.put("eventId", System.currentTimeMillis()); // Giả lập ID

        } catch (Exception e) {
            result.put("status", "error");
            result.put("message", "Failed to create event: " + e.getMessage());
        }

        return result;
    }

//     * Cập nhật event
    private Map<String, Object> updateEvent(JsonObject request) {
        Map<String, Object> result = new HashMap<>();

        try {
            // TODO: Implement actual event update in database
            int eventId = request.get("id").getAsInt();
            String title = request.get("title").getAsString();

            result.put("status", "success");
            result.put("message", "Event updated successfully");

        } catch (Exception e) {
            result.put("status", "error");
            result.put("message", "Failed to update event: " + e.getMessage());
        }

        return result;
    }

//     * Xóa event
    private Map<String, Object> deleteEvent(JsonObject request) {
        Map<String, Object> result = new HashMap<>();

        try {
            // TODO: Implement actual event deletion from database
            int eventId = request.get("id").getAsInt();

            result.put("status", "success");
            result.put("message", "Event deleted successfully");

        } catch (Exception e) {
            result.put("status", "error");
            result.put("message", "Failed to delete event: " + e.getMessage());
        }

        return result;
    }

//     * Lấy label ngày trong tuần bằng tiếng Việt
    private String getDayLabel(int dayIndex) {
        String[] labels = {"CN", "T2", "T3", "T4", "T5", "T6", "T7"};
        return labels[dayIndex];
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Calendar API Servlet";
    }// </editor-fold>

}
