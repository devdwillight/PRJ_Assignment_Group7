/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.event;

import com.model.UserEvents;
import com.model.Calendar;
import com.service.Event.EventService;
import com.service.Calendar.CalendarService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.time.OffsetDateTime;
import java.time.format.DateTimeParseException;

/**
 *
 * @author DELL
 */
@WebServlet(name = "EventServlet", urlPatterns = {"/event"})
public class EventServlet extends HttpServlet {

    private EventService eventService;
    private CalendarService calendarService;

    @Override
    public void init() throws ServletException {
        eventService = new EventService();
        calendarService = new CalendarService();
        calendarService = new CalendarService();
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
            out.println("<title>Servlet EventServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EventServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if ("addForm".equals(action)) {
            // Lấy danh sách calendar của user
            List<Calendar> calendars = calendarService.getAllCalendarByUserId(userId);
            request.setAttribute("calendars", calendars);
            // Phân biệt tạo mới hay sửa
            String eventIdStr = request.getParameter("id");
            boolean isEdit = false;
            if (eventIdStr != null && !eventIdStr.isEmpty()) {
                try {
                    int eventId = Integer.parseInt(eventIdStr);
                    UserEvents event = eventService.getEventById(eventId);
                    if (event != null && event.getIdCalendar().getIdUser().getIdUser().equals(userId)) {
                        request.setAttribute("event", event);
                        isEdit = true;
                    }
                } catch (Exception e) {
                    // ignore, chỉ tạo mới nếu lỗi
                }
            }
            request.setAttribute("isEdit", isEdit);
            if (isEdit) {
                request.getRequestDispatcher("/views/calendar/editEvent.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/views/calendar/addEvent.jsp").forward(request, response);
            }
            return;
        }
        if ("editEvent".equals(action)) {
            // Lấy danh sách calendar của user
            List<Calendar> calendars = calendarService.getAllCalendarByUserId(userId);
            request.setAttribute("calendars", calendars);
            // Lấy eventId
            String eventIdStr = request.getParameter("id");
            boolean isEdit = false;
            if (eventIdStr != null && !eventIdStr.isEmpty()) {
                try {
                    int eventId = Integer.parseInt(eventIdStr);
                    UserEvents event = eventService.getEventById(eventId);
                    if (event != null && event.getIdCalendar().getIdUser().getIdUser().equals(userId)) {
                        request.setAttribute("event", event);
                        isEdit = true;
                    }
                } catch (Exception e) {
                    // ignore, chỉ tạo mới nếu lỗi
                }
            }
            request.setAttribute("isEdit", isEdit);
            if (isEdit) {
                request.getRequestDispatcher("/views/calendar/editEvent.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/calendar");
            }
            return;
        }
        // Mặc định
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
        response.setContentType("application/json;charset=UTF-8");

        try {
            String action = request.getParameter("action");

            // Debug logging
            System.out.println("[EventServlet] Received POST request");
            System.out.println("[EventServlet] Action parameter: " + action);
            System.out.println("[EventServlet] All parameters:");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                System.out.println("  " + paramName + " = " + paramValue);
            }

            if ("create".equals(action)) {
                System.out.println("[EventServlet] Handling create action");
                handleCreateEvent(request, response);
            } else if ("delete".equals(action)) {
                System.out.println("[EventServlet] Handling delete action");
                handleDeleteEvent(request, response);
            } else if ("update".equals(action)) {
                System.out.println("[EventServlet] Handling update action");
                handleUpdateEvent(request, response);
            } else if ("updateTime".equals(action)) {
                System.out.println("[EventServlet] Handling updateTime action");
                handleUpdateEventTime(request, response);
            } else {
                System.out.println("[EventServlet] Invalid action: " + action);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid action\"}");
            }

        } catch (Exception e) {
            System.err.println("Error in EventServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Internal server error\"}");
        }
    }

    private void handleCreateEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get user session
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("user_id");
            if (userId == null) {
                // Nếu là AJAX thì trả về JSON lỗi
                String accept = request.getHeader("Accept");
                String requestedWith = request.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equals(requestedWith) || (accept != null && accept.contains("application/json"))) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.getWriter().write("{\"error\":\"User not logged in\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/login");
                }
                return;
            }
            System.out.println("[EventServlet] User ID from session: " + userId);
            // Get form data
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            String startDate = request.getParameter("startDate");
            String startTime = request.getParameter("startTime");
            String endDate = request.getParameter("endDate");
            String endTime = request.getParameter("endTime");
            String allDay = request.getParameter("allDay");
            String color = request.getParameter("color");
            String calendarId = request.getParameter("calendarId");
            String remindMethod = request.getParameter("remindMethod");
            String remindBefore = request.getParameter("remindBefore");
            String remindUnit = request.getParameter("remindUnit");

            // Debug logging
            System.out.println("[EventServlet] Creating event with data:");
            System.out.println("  Title: " + title);
            System.out.println("  Description: " + description);
            System.out.println("  Location: " + location);
            System.out.println("  StartDate: " + startDate);
            System.out.println("  StartTime: " + startTime);
            System.out.println("  EndDate: " + endDate);
            System.out.println("  EndTime: " + endTime);
            System.out.println("  AllDay: " + allDay);
            System.out.println("  Color: " + color);
            System.out.println("  CalendarId: " + calendarId);
            System.out.println("  RemindMethod: " + remindMethod);
            System.out.println("  RemindBefore: " + remindBefore);
            System.out.println("  RemindUnit: " + remindUnit);

            // Validate required fields
            if (title == null || title.trim().isEmpty()
                    || startDate == null || startDate.trim().isEmpty()
                    || calendarId == null || calendarId.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Missing required fields\"}");
                return;
            }

            // Create UserEvents object
            UserEvents event = new UserEvents();
            event.setName(title);
            event.setDescription(description != null ? description : "");
            event.setLocation(location != null ? location : "");
            event.setColor(color != null ? color : "#3b82f6");
            event.setIsAllDay("on".equals(allDay));
            event.setIsRecurring(false);

            // Xử lý remindMethod từ form
            if (remindMethod != null && !remindMethod.trim().isEmpty()) {
                event.setRemindMethod("1".equals(remindMethod) || "true".equals(remindMethod));
            } else {
                event.setRemindMethod(false);
            }

            // Xử lý remindBefore từ form
            if (remindBefore != null && !remindBefore.trim().isEmpty()) {
                try {
                    int remindValue = Integer.parseInt(remindBefore);
                    if (remindValue < 0) {
                        event.setRemindBefore(30); // Giá trị mặc định nếu âm
                    } else {
                        event.setRemindBefore(remindValue);
                    }
                } catch (NumberFormatException e) {
                    event.setRemindBefore(30); // Giá trị mặc định nếu parse lỗi
                }
            } else {
                event.setRemindBefore(30); // Giá trị mặc định
            }

            // Xử lý remindUnit từ form
            if (remindUnit != null && !remindUnit.trim().isEmpty()) {
                // Validate remindUnit chỉ nhận các giá trị hợp lệ
                String validUnits[] = {"minutes", "hours", "days", "weeks"};
                boolean isValidUnit = false;
                for (String unit : validUnits) {
                    if (unit.equals(remindUnit)) {
                        isValidUnit = true;
                        break;
                    }
                }
                if (isValidUnit) {
                    event.setRemindUnit(remindUnit);
                } else {
                    event.setRemindUnit("minutes"); // Giá trị mặc định nếu không hợp lệ
                }
            } else {
                event.setRemindUnit("minutes"); // Giá trị mặc định
            }

            event.setCreatedAt(new Date());
            event.setUpdatedAt(new Date());

            // Nhận recurrenceRule từ request và lưu vào event
            String recurrenceRule = request.getParameter("recurrenceRule");
            System.out.println("[EventServlet] recurrenceRule from request: '" + recurrenceRule + "'");
            if (recurrenceRule == null || recurrenceRule.trim().isEmpty()) {
                // Không lặp lại
                event.setRecurrenceRule(null); // hoặc không set gì cả
                event.setIsRecurring(false);
            } else {
                event.setRecurrenceRule(recurrenceRule);
                event.setIsRecurring(true);
            }

            // Parse dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            try {
                Date startDateTime = null;
                Date endDateTime = null;

                if ("on".equals(allDay)) {
                    startDateTime = dateFormat.parse(startDate);
                    if (endDate != null && !endDate.trim().isEmpty()) {
                        endDateTime = dateFormat.parse(endDate);
                    } else {
                        endDateTime = startDateTime;
                    }
                } else {
                    boolean hasStartTime = startTime != null && !startTime.trim().isEmpty();
                    boolean hasEndTime = endTime != null && !endTime.trim().isEmpty();

                    if (hasStartTime) {
                        String timeStr = startTime;
                        if (timeStr.length() == 5) {
                            timeStr = timeStr + ":00";
                        }
                        startDateTime = dateTimeFormat.parse(startDate + " " + timeStr);
                    } else {
                        startDateTime = dateFormat.parse(startDate);
                    }

                    if (endDate != null && !endDate.trim().isEmpty()) {
                        if (hasEndTime) {
                            String timeStr = endTime;
                            if (timeStr.length() == 5) {
                                timeStr = timeStr + ":00";
                            }
                            endDateTime = dateTimeFormat.parse(endDate + " " + timeStr);
                        } else {
                            if (hasStartTime) {
                                String timeStr = startTime;
                                if (timeStr.length() == 5) {
                                    timeStr = timeStr + ":00";
                                }
                                endDateTime = dateTimeFormat.parse(endDate + " " + timeStr);
                            } else {
                                endDateTime = dateFormat.parse(endDate);
                            }
                        }
                    } else {
                        endDateTime = startDateTime;
                    }
                }

                event.setStartDate(startDateTime);
                event.setDueDate(endDateTime);

            } catch (Exception e) {
                System.err.println("[EventServlet] Date parsing error: " + e.getMessage());
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid date format: " + e.getMessage() + "\"}");
                return;
            }

            // Step 1: Get user's calendars
            System.out.println("[EventServlet] Step 1: Getting calendars for user ID: " + userId);
            List<Calendar> userCalendars = calendarService.getAllCalendarByUserId(userId);
            System.out.println("[EventServlet] Found " + userCalendars.size() + " calendars for user");

            // Step 2: Validate calendar ID belongs to user
            System.out.println("[EventServlet] Step 2: Validating calendar ID: " + calendarId);
            Calendar selectedCalendar = null;
            try {
                int calendarIdInt = Integer.parseInt(calendarId);
                for (Calendar cal : userCalendars) {
                    if (cal.getIdCalendar().equals(calendarIdInt)) {
                        selectedCalendar = cal;
                        break;
                    }
                }

                if (selectedCalendar == null) {
                    System.out.println("[EventServlet] Calendar ID " + calendarId + " not found in user's calendars");
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write("{\"error\":\"Calendar does not belong to current user\"}");
                    return;
                }

            } catch (NumberFormatException e) {
                System.out.println("[EventServlet] Invalid calendar ID format: " + calendarId);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid calendar ID\"}");
                return;
            }

            // Step 3: Set calendar for event
            System.out.println("[EventServlet] Step 3: Setting calendar for event");
            System.out.println("[EventServlet] Selected calendar details:");
            System.out.println("  - ID: " + selectedCalendar.getIdCalendar());
            System.out.println("  - Name: " + selectedCalendar.getName());
            System.out.println("  - User ID: " + (selectedCalendar.getIdUser() != null ? selectedCalendar.getIdUser().getIdUser() : "null"));
            System.out.println("  - Is managed: " + (selectedCalendar.getIdCalendar() != null));

            // Refresh calendar object to ensure it's properly loaded
            System.out.println("[EventServlet] Refreshing calendar object...");
            Calendar refreshedCalendar = calendarService.getCalendarById(selectedCalendar.getIdCalendar());
            if (refreshedCalendar != null) {
                event.setIdCalendar(refreshedCalendar);
            } else {
                event.setIdCalendar(selectedCalendar);
            }

            System.out.println("[EventServlet] Calendar set for event: " + selectedCalendar.getName() + " (ID: " + selectedCalendar.getIdCalendar() + ")");
            System.out.println("[EventServlet] Event calendar after set: " + (event.getIdCalendar() != null ? event.getIdCalendar().getName() : "NULL"));

            // Save event
            System.out.println("[EventServlet] About to save event...");
            UserEvents savedEvent = eventService.createEvent(event);

            if (savedEvent != null) {
                // Kiểm tra nếu là request AJAX (application/json)
                String accept = request.getHeader("Accept");
                String requestedWith = request.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equals(requestedWith) || (accept != null && accept.contains("application/json"))) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
                return;
            } else {
                System.out.println("[EventServlet] Failed to create event - savedEvent is null");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Failed to create event\"}");
            }

        } catch (Exception e) {
            System.err.println("Error creating event: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to create event\"}");
        }
    }

    private void handleDeleteEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get user session
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("user_id");
            if (userId == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User not logged in\"}");
                return;
            }

            // Get event ID
            String eventIdStr = request.getParameter("eventId");
            System.out.println("[EventServlet] Delete request - eventIdStr: " + eventIdStr);

            if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
                System.out.println("[EventServlet] Missing event ID");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Missing event ID\"}");
                return;
            }

            try {
                int eventId = Integer.parseInt(eventIdStr);

                // Get event to check ownership
                UserEvents event = eventService.getEventById(eventId);
                if (event == null) {
                    System.out.println("[EventServlet] Event not found for ID: " + eventId);
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"error\":\"Event not found\"}");
                    return;
                }

                System.out.println("[EventServlet] Found event: " + event.getName());
                System.out.println("[EventServlet] Event calendar user ID: " + (event.getIdCalendar() != null ? event.getIdCalendar().getIdUser().getIdUser() : "null"));
                System.out.println("[EventServlet] Current user ID: " + userId);

                // Check if user owns the event
                if (!event.getIdCalendar().getIdUser().getIdUser().equals(userId)) {
                    System.out.println("[EventServlet] User not authorized to delete this event");
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write("{\"error\":\"Not authorized to delete this event\"}");
                    return;
                }

                // Delete event
                boolean deleted = eventService.removeEvent(eventId);

                if (deleted) {
                    System.out.println("[EventServlet] Event deleted successfully");
                    response.getWriter().write("{\"success\": true, \"message\": \"Event deleted successfully\"}");
                } else {
                    System.out.println("[EventServlet] Failed to delete event");
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"error\":\"Failed to delete event\"}");
                }

            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid event ID format\"}");
            }

        } catch (Exception e) {
            System.err.println("Error deleting event: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to delete event\"}");
        }
    }

    private void handleUpdateEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get user session
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("user_id");
            if (userId == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User not logged in\"}");
                return;
            }

            // Get event ID
            String eventIdStr = request.getParameter("eventId");
            if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Missing event ID\"}");
                return;
            }

            int eventId = Integer.parseInt(eventIdStr);

            // Get form data (same as create event)
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            String startDate = request.getParameter("startDate");
            String startTime = request.getParameter("startTime");
            String endDate = request.getParameter("endDate");
            String endTime = request.getParameter("endTime");
            String allDay = request.getParameter("allDay");
            String color = request.getParameter("color");
            String calendarId = request.getParameter("calendarId");
            String remindMethod = request.getParameter("remindMethod");
            String remindBefore = request.getParameter("remindBefore");
            String remindUnit = request.getParameter("remindUnit");

            // Validate required fields
            if (title == null || title.trim().isEmpty()
                    || startDate == null || startDate.trim().isEmpty()
                    || calendarId == null || calendarId.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Missing required fields\"}");
                return;
            }

            // Get existing event
            UserEvents existingEvent = eventService.getEventById(eventId);
            if (existingEvent == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Event not found\"}");
                return;
            }

            // Check if user owns the event
            if (!existingEvent.getIdCalendar().getIdUser().getIdUser().equals(userId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Not authorized to update this event\"}");
                return;
            }

            // Update event data
            existingEvent.setName(title);
            existingEvent.setDescription(description != null ? description : "");
            existingEvent.setLocation(location != null ? location : "");
            existingEvent.setColor(color != null ? color : "#3b82f6");
            existingEvent.setIsAllDay("on".equals(allDay));

            // Cập nhật remindMethod từ form
            if (remindMethod != null && !remindMethod.trim().isEmpty()) {
                existingEvent.setRemindMethod("1".equals(remindMethod) || "true".equals(remindMethod));
            }

            // Cập nhật remindBefore từ form
            if (remindBefore != null && !remindBefore.trim().isEmpty()) {
                try {
                    int remindValue = Integer.parseInt(remindBefore);
                    if (remindValue >= 0) {
                        existingEvent.setRemindBefore(remindValue);
                    }
                    // Giữ nguyên giá trị cũ nếu âm
                } catch (NumberFormatException e) {
                    // Giữ nguyên giá trị cũ nếu parse lỗi
                }
            }

            // Cập nhật remindUnit từ form
            if (remindUnit != null && !remindUnit.trim().isEmpty()) {
                // Validate remindUnit chỉ nhận các giá trị hợp lệ
                String validUnits[] = {"minutes", "hours", "days", "weeks"};
                boolean isValidUnit = false;
                for (String unit : validUnits) {
                    if (unit.equals(remindUnit)) {
                        isValidUnit = true;
                        break;
                    }
                }
                if (isValidUnit) {
                    existingEvent.setRemindUnit(remindUnit);
                }
                // Giữ nguyên giá trị cũ nếu không hợp lệ
            }

            existingEvent.setUpdatedAt(new Date());

            // Parse and set dates (same logic as create)
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            try {
                Date startDateTime = null;
                Date endDateTime = null;

                if ("on".equals(allDay)) {
                    startDateTime = dateFormat.parse(startDate);
                    if (endDate != null && !endDate.trim().isEmpty()) {
                        endDateTime = dateFormat.parse(endDate);
                    } else {
                        endDateTime = startDateTime;
                    }
                } else {
                    boolean hasStartTime = startTime != null && !startTime.trim().isEmpty();
                    boolean hasEndTime = endTime != null && !endTime.trim().isEmpty();

                    if (hasStartTime) {
                        String timeStr = startTime;
                        if (timeStr.length() == 5) {
                            timeStr = timeStr + ":00";
                        }
                        startDateTime = dateTimeFormat.parse(startDate + " " + timeStr);
                    } else {
                        startDateTime = dateFormat.parse(startDate);
                    }

                    if (endDate != null && !endDate.trim().isEmpty()) {
                        if (hasEndTime) {
                            String timeStr = endTime;
                            if (timeStr.length() == 5) {
                                timeStr = timeStr + ":00";
                            }
                            endDateTime = dateTimeFormat.parse(endDate + " " + timeStr);
                        } else {
                            if (hasStartTime) {
                                String timeStr = startTime;
                                if (timeStr.length() == 5) {
                                    timeStr = timeStr + ":00";
                                }
                                endDateTime = dateTimeFormat.parse(endDate + " " + timeStr);
                            } else {
                                endDateTime = dateFormat.parse(endDate);
                            }
                        }
                    } else {
                        endDateTime = startDateTime;
                    }
                }

                existingEvent.setStartDate(startDateTime);
                existingEvent.setDueDate(endDateTime);

            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid date format: " + e.getMessage() + "\"}");
                return;
            }

            // Cập nhật recurrenceRule khi update event
            String recurrenceRule = request.getParameter("recurrenceRule");
            if (recurrenceRule == null || recurrenceRule.trim().isEmpty()) {
                // Không lặp lại
                existingEvent.setRecurrenceRule(null); // hoặc không set gì cả
                existingEvent.setIsRecurring(false);
            } else {
                existingEvent.setRecurrenceRule(recurrenceRule);
                existingEvent.setIsRecurring(true);
            }

            // Update calendar if changed
            if (calendarId != null && !calendarId.trim().isEmpty()) {
                try {
                    int calendarIdInt = Integer.parseInt(calendarId);
                    Calendar newCalendar = calendarService.getCalendarById(calendarIdInt);
                    if (newCalendar != null && newCalendar.getIdUser().getIdUser().equals(userId)) {
                        existingEvent.setIdCalendar(newCalendar);
                    }
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"Invalid calendar ID\"}");
                    return;
                }
            }

            // Save updated event
            boolean updated = eventService.updateEvent(existingEvent);

            if (updated) {
                // Kiểm tra nếu là request AJAX (application/json)
                String accept = request.getHeader("Accept");
                String requestedWith = request.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equals(requestedWith) || (accept != null && accept.contains("application/json"))) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Failed to update event\"}");
            }

        } catch (Exception e) {
            System.err.println("Error updating event: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to update event\"}");
        }
    }

    private void handleUpdateEventTime(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get user session
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("user_id");
            if (userId == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User not logged in\"}");
                return;
            }

            // Get event ID
            String eventIdStr = request.getParameter("eventId");
            if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Missing event ID\"}");
                return;
            }

            int eventId = Integer.parseInt(eventIdStr);

            // Get new start and end dates from request
            String start = request.getParameter("start"); // VD: "2025-07-18T08:00:00Z" hoặc "2025-07-18"
            String end = request.getParameter("end");
            boolean allDay = Boolean.parseBoolean(request.getParameter("allDay"));

            // Validate required fields
            if (start == null || start.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Missing required fields\"}");
                return;
            }

            // Get existing event
            UserEvents existingEvent = eventService.getEventById(eventId);
            if (existingEvent == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Event not found\"}");
                return;
            }

            // Check if user owns the event
            if (!existingEvent.getIdCalendar().getIdUser().getIdUser().equals(userId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Not authorized to update this event\"}");
                return;
            }

            // Parse dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            Date startDateTime = null;
            Date endDateTime = null;
            try {
                if (start != null && !start.trim().isEmpty()) {
                    String s = start;
                    if (s.length() == 10) {
                        s += "T00:00:00Z"; // Nếu chỉ có ngày, thêm giờ mặc định
                    }
                    startDateTime = Date.from(OffsetDateTime.parse(s).toInstant());
                }
                if (end != null && !end.trim().isEmpty()) {
                    String e = end;
                    if (e.length() == 10) {
                        e += "T00:00:00Z";
                    }
                    endDateTime = Date.from(OffsetDateTime.parse(e).toInstant());
                } else {
                    endDateTime = startDateTime;
                }
            } catch (DateTimeParseException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid date format: " + e.getMessage() + "\"}");
                return;
            }

            // Cập nhật recurrenceRule khi update event
            String recurrenceRule = request.getParameter("recurrenceRule");
            if (recurrenceRule == null || recurrenceRule.trim().isEmpty()) {
                // Không lặp lại
                existingEvent.setRecurrenceRule(null); // hoặc không set gì cả
                existingEvent.setIsRecurring(false);
            } else {
                existingEvent.setRecurrenceRule(recurrenceRule);
                existingEvent.setIsRecurring(true);
            }

            // Save updated event
            System.out.println("[DEBUG] eventId=" + eventId);
            System.out.println("[DEBUG] startDateTime=" + startDateTime);
            System.out.println("[DEBUG] endDateTime=" + endDateTime);
            System.out.println("[DEBUG] allDay=" + allDay);
            boolean updated = eventService.updateEventTime(eventId, startDateTime, endDateTime, allDay);

            if (updated) {
                // Kiểm tra nếu là request AJAX (application/json)
                String accept = request.getHeader("Accept");
                String requestedWith = request.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equals(requestedWith) || (accept != null && accept.contains("application/json"))) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Failed to update event\"}");
            }

        } catch (Exception e) {
            System.err.println("Error updating event: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to update event\"}");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Event Servlet - Handles event creation and management";
    }// </editor-fold>

}
