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
            
            if ("create".equals(action)) {
                handleCreateEvent(request, response);
            } else {
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
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User not logged in\"}");
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
            
            // Validate required fields
            if (title == null || title.trim().isEmpty() || 
                startDate == null || startDate.trim().isEmpty() ||
                calendarId == null || calendarId.trim().isEmpty()) {
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
            event.setRemindMethod(false);
            event.setRemindBefore(30);
            event.setRemindUnit("minutes");
            event.setCreatedAt(new Date());
            event.setUpdatedAt(new Date());
            
            // Parse dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            
            try {
                Date startDateTime = null;
                Date endDateTime = null;
                
                if ("on".equals(allDay)) {
                    // All day event
                    startDateTime = dateFormat.parse(startDate);
                    if (endDate != null && !endDate.trim().isEmpty()) {
                        endDateTime = dateFormat.parse(endDate);
                    } else {
                        endDateTime = startDateTime;
                    }
                } else {
                    // Time-specific event
                    if (startTime != null && !startTime.trim().isEmpty()) {
                        startDateTime = dateTimeFormat.parse(startDate + " " + startTime);
                    } else {
                        startDateTime = dateFormat.parse(startDate);
                    }
                    
                    if (endDate != null && !endDate.trim().isEmpty()) {
                        if (endTime != null && !endTime.trim().isEmpty()) {
                            endDateTime = dateTimeFormat.parse(endDate + " " + endTime);
                        } else {
                            endDateTime = dateFormat.parse(endDate);
                        }
                    } else {
                        endDateTime = startDateTime;
                    }
                }
                
                event.setStartDate(startDateTime);
                event.setDueDate(endDateTime);
                
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid date format\"}");
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
                    System.out.println("[EventServlet] Checking calendar: " + cal.getName() + " (ID: " + cal.getIdCalendar() + ")");
                    if (cal.getIdCalendar().equals(calendarIdInt)) {
                        selectedCalendar = cal;
                        System.out.println("[EventServlet] Calendar found and belongs to user: " + cal.getName());
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
                System.out.println("[EventServlet] Calendar refreshed successfully");
                event.setIdCalendar(refreshedCalendar);
            } else {
                System.out.println("[EventServlet] Failed to refresh calendar, using original");
                event.setIdCalendar(selectedCalendar);
            }
            
            System.out.println("[EventServlet] Calendar set for event: " + selectedCalendar.getName() + " (ID: " + selectedCalendar.getIdCalendar() + ")");
            System.out.println("[EventServlet] Event calendar after set: " + (event.getIdCalendar() != null ? event.getIdCalendar().getName() : "NULL"));
            
            // Save event
            System.out.println("[EventServlet] About to save event...");
            UserEvents savedEvent = eventService.createEvent(event);
            
            if (savedEvent != null) {
                // Return success response
                String jsonResponse = "{\"success\": true, \"message\": \"Event created successfully\", \"eventId\": " + savedEvent.getIdEvent() + "}";
                System.out.println("[EventServlet] Success response: " + jsonResponse);
                response.getWriter().write(jsonResponse);
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
