/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.agent.servlet;

import com.agent.service.ScheduleAIAgent;
import com.agent.util.SessionManager;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ChatServlet", urlPatterns = {"/api/chat"})
public class ChatServlet extends HttpServlet {

    private static final ObjectMapper mapper = new ObjectMapper();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ChatServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChatServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // Parse JSON request
            Map<String, String> request = mapper.readValue(req.getInputStream(), Map.class);
            String message = request.get("message");
            String sessionId = request.get("sessionId");

            // Lấy hoặc tạo mới agent cho session này
            ScheduleAIAgent agent = SessionManager.getOrCreate(sessionId);

            // Xử lý tin nhắn từ người dùng
            String aiResponse = agent.processUserInput(message);
            System.out.println(aiResponse);
            // Trả lại phản hồi dưới dạng JSON
            Map<String, String> response = new HashMap<>();
            response.put("response", aiResponse);
            response.put("sessionId", sessionId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            mapper.writeValue(resp.getWriter(), response);

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", "Internal server error");
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            mapper.writeValue(resp.getWriter(), errorResponse);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
