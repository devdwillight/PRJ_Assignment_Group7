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
@WebServlet(name = "GreetingServlet", urlPatterns = {"/api/greeting"})
public class GreetingServlet extends HttpServlet {

    private static final ObjectMapper mapper = new ObjectMapper();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet GreetingServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GreetingServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Map<String, String> request = mapper.readValue(req.getInputStream(), Map.class);
            String sessionId = request.get("sessionId");

            // Khởi tạo agent mới cho session
            ScheduleAIAgent agent = new ScheduleAIAgent();
            SessionManager.put(sessionId, agent);

            String greeting = agent.getGreeting();

            Map<String, String> response = new HashMap<>();
            response.put("message", greeting);
            response.put("sessionId", sessionId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            mapper.writeValue(resp.getWriter(), response);

        } catch (Exception e) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("message",
                    "🤖 Xin chào! Tôi là AI Assistant quản lý lịch trình thông minh.\n\n"
                            + "Tôi có thể giúp bạn:\n"
                            + "✅ Tạo lịch học tập, công việc, sự kiện\n"
                            + "✅ Tối ưu hóa thời gian\n"
                            + "✅ Đưa ra lời khuyên quản lý thời gian\n\n"
                            + "Hãy chia sẻ kế hoạch của bạn để bắt đầu!");
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
