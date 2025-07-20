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
@WebServlet(name = "SummaryServlet", urlPatterns = {"/api/summary"})
public class SummaryServlet extends HttpServlet {

    private static final ObjectMapper mapper = new ObjectMapper();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SummaryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SummaryServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // Đọc JSON từ request body
            Map<String, String> request = mapper.readValue(req.getInputStream(), Map.class);
            String sessionId = request.get("sessionId");

            ScheduleAIAgent agent = SessionManager.get(sessionId);
            String summary;

            if (agent != null) {
                summary = agent.getConversationSummary();
            } else {
                summary = "Không có cuộc trò chuyện nào được ghi nhận.";
            }

            Map<String, String> response = new HashMap<>();
            response.put("summary", summary);
            response.put("sessionId", sessionId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            mapper.writeValue(resp.getWriter(), response);

        } catch (Exception e) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("summary", "Không thể tạo tóm tắt cuộc trò chuyện.");
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
