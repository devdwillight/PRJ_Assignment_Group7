///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package com.controller.calendar;
//
//import com.service.Event.EventService;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import com.google.gson.Gson;
//import com.model.UserEvents;
//import com.service.Event.IEventService;
//import java.io.BufferedReader;
//import java.util.Date;
//import java.util.List;
//
///**
// *
// * @author ACER
// */
//@WebServlet(name = "EventServlet", urlPatterns = {"/events"})
//public class EventServlet extends HttpServlet {
//
//    private IEventService eventService;
//    private Gson gson;
//
//    @Override
//    public void init() throws ServletException {
//        super.init();
//        eventService = new EventService(); // Khởi tạo DAO
//        gson = new Gson();
//    }
//
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet EventServlet</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet EventServlet at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String action = request.getParameter("action");
//
//        if (action == null) {
//            action = "list"; // Nếu không có action, mặc định là "list"
//        }
//
//        switch (action) {
//            case "insert":
//                insertEvent(request, response);
//                break;
//            case "view":
//                viewEvent(request, response);
//                break;
//            case "edit":
//                editEvent(request, response);
//                break;
//            case "delete":
//                deleteEvent(request, response);
//                break;
//            default:
//                listEvents(request, response);
//                break;
//        }
//    }
//
//    private void insertEvent(HttpServletRequest request, HttpServletResponse response) throws IOException {
//        BufferedReader reader = request.getReader();
//        UserEvents event = gson.fromJson(reader, UserEvents.class);
//
//        // Gán thời gian tạo
//        event.setCreatedAt(new Date());
//        event.setUpdatedAt(new Date());
//
//        // Gán lịch tạm (nếu không có)
//        if (event.getIdCalendar() == null) {
//            com.model.Calendar cal = new com.model.Calendar();
//            cal.setIdCalendar(1); // gán tạm
//            event.setIdCalendar(cal);
//        }
//
//        boolean inserted = eventService.insertEvent(event);
//
//        response.setContentType("application/json");
//        response.setCharacterEncoding("UTF-8");
//
//        if (inserted) {
//            response.getWriter().write("{\"status\":\"success\",\"message\":\"Thêm sự kiện thành công\"}");
//        } else {
//            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
//            response.getWriter().write("{\"status\":\"error\",\"message\":\"Thêm sự kiện thất bại\"}");
//        }
//    }
//
//    private void listEvents(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        // Lấy danh sách sự kiện từ DAO
//        List<UserEvents> eventList = eventService.getAllEvent();
//
//        // Trả lại dữ liệu dưới dạng JSON
//        String jsonResponse = gson.toJson(eventList);
//
//        // Cài đặt content type cho response
//        response.setContentType("application/json");
//        response.setCharacterEncoding("UTF-8");
//
//        // Gửi dữ liệu JSON về phía client
//        response.getWriter().write(jsonResponse);
//    }
//
//    private void viewEvent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        int eventId = Integer.parseInt(request.getParameter("id"));
//        UserEvents event = eventService.getEventById(eventId);
//
//        if (event != null) {
//            // Trả lại dữ liệu sự kiện dưới dạng JSON
//            String jsonResponse = gson.toJson(event);
//
//            // Cài đặt content type cho response
//            response.setContentType("application/json");
//            response.setCharacterEncoding("UTF-8");
//
//            // Gửi dữ liệu JSON về phía client
//            response.getWriter().write(jsonResponse);
//        } else {
//            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sự kiện không tồn tại");
//        }
//    }
//
//    private void editEvent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        int eventId = Integer.parseInt(request.getParameter("id"));
//        UserEvents event = eventService.getEventById(eventId);
//
//        if (event != null) {
//            // Cập nhật thông tin sự kiện
//            event.setName(request.getParameter("name"));
//            event.setDescription(request.getParameter("description"));
//            event.setDueDate(request.getParameter("eventDate"));
//            event.(request.getParameter("eventTime"));
//            event.setEventDescription(request.getParameter("eventDescription"));
//
//            // Cập nhật sự kiện trong cơ sở dữ liệu
//            boolean updated = eventDAO.updateEvent(event);
//            if (updated) {
//                response.sendRedirect("eventServlet?action=list");
//            } else {
//                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể cập nhật sự kiện");
//            }
//        } else {
//            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sự kiện không tồn tại");
//        }
//    }
//
//    private void deleteEvent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        int eventId = Integer.parseInt(request.getParameter("id"));
//
//        // Xóa sự kiện khỏi cơ sở dữ liệu
//        boolean deleted = eventDAO.deleteEvent(eventId);
//        if (deleted) {
//            response.sendRedirect("eventServlet?action=list");
//        } else {
//            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể xóa sự kiện");
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
