/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.agent.servlet;

import com.agent.model.ScheduleItem;
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
import jakarta.servlet.http.HttpSession;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ScheduleServlet", urlPatterns = {"/api/schedule"})
public class ScheduleServlet extends HttpServlet {

    private static final ObjectMapper mapper = new ObjectMapper();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ScheduleServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ScheduleServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            HttpSession session = req.getSession(false);
            // Parse JSON request
            Map<String, String> request = mapper.readValue(req.getInputStream(), Map.class);
            String sessionId = request.get("sessionId");

            ScheduleAIAgent agent = SessionManager.get(sessionId);
            String scheduleInfo;

            if (agent != null) {
                int user_id = (int) session.getAttribute("user_id");
                List<ScheduleItem> schedules = agent.getCurrentSchedule(user_id);
                if (schedules.isEmpty()) {
                    scheduleInfo = "📅 **Lịch trình hiện tại:**\n\nChưa có lịch trình nào được tạo. Hãy bắt đầu bằng cách cho tôi biết kế hoạch của bạn!";
                } else {
                    StringBuilder sb = new StringBuilder("📅 **Lịch trình hiện tại:**\n\n");
                    for (int i = 0; i < schedules.size(); i++) {
                        ScheduleItem item = schedules.get(i);
                        sb.append(String.format("%d. [%s] %s\n", i + 1, item.getScheduleType().getDisplayName(), item.getTitle()));
                        sb.append(String.format("   ⏰ %s - %s\n",
                                item.getStartTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                                item.getEndTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))));
                        sb.append(String.format("   🎯 Ưu tiên: %s\n\n", item.getPriority()));
                    }
                    sb.append(String.format("💡 **Tổng số sự kiện:** %d", schedules.size()));
                    scheduleInfo = sb.toString();
                }
            } else {
                scheduleInfo = "Không thể tải lịch trình. Vui lòng thử lại.";
            }

            // Response JSON
            Map<String, String> response = new HashMap<>();
            response.put("schedule", scheduleInfo);
            response.put("sessionId", sessionId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            mapper.writeValue(resp.getWriter(), response);

        } catch (Exception e) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("schedule", "Không thể tải lịch trình hiện tại.");
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
