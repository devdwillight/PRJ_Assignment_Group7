/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.task;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.service.Task.TaskService;
import com.model.Task;
import java.util.List;
import jakarta.servlet.http.HttpSession;
import com.model.ToDo;
import com.service.Todo.TodoService;

/**
 *
 * @author DELL
 */
@WebServlet(name = "taskServlet", urlPatterns = {"/task"})
public class taskServlet extends HttpServlet {

    private TaskService taskService;
    private TodoService todoService;

    @Override
    public void init() throws ServletException {
        taskService = new TaskService();
        todoService = new TodoService();
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
            out.println("<title>Servlet taskServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet taskServlet at " + request.getContextPath() + "</h1>");
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
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"not_logged_in\"}");
            return;
        }

        String action = request.getParameter("action");
        if ("getAllTodoByUser".equals(action)) {
            handleGetAllTodoByUser(request, response, userId);
            return;
        }

        processRequest(request, response);
    }

    private void handleGetAllTodoByUser(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try {
            System.out.println("[TaskServlet] Bắt đầu load danh sách ToDo cho userId = " + userId);
            List<ToDo> todos = todoService.getAllToDoByUserId(userId);
            System.out.println("[TaskServlet] Số lượng ToDo lấy được: " + todos.size());
            for (ToDo t : todos) {
                System.out.println("  - ToDo: id=" + t.getIdTodo() + ", title=" + t.getTitle() + ", dueDate=" + t.getDueDate());
            }
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < todos.size(); i++) {
                ToDo t = todos.get(i);
                json.append("{")
                    .append("\"idTodo\":").append(t.getIdTodo()).append(",")
                    .append("\"title\":\"").append(t.getTitle().replace("\"", "\\\"")).append("\",")
                    .append("\"description\":\"").append(t.getDescription() != null ? t.getDescription().replace("\"", "\\\"") : "").append("\",")
                    .append("\"dueDate\":\"").append(t.getDueDate()).append("\",")
                    .append("\"isAllDay\":").append(t.getIsAllDay() != null && t.getIsAllDay() ? "true" : "false").append(",")
                    .append("\"isCompleted\":").append(t.getIsCompleted() != null && t.getIsCompleted() ? "true" : "false")
                    .append("}");
                if (i < todos.size() - 1) json.append(",");
            }
            json.append("]");
            response.getWriter().write(json.toString());
            System.out.println("[TaskServlet] Đã trả về JSON danh sách ToDo cho client.");
        } catch (Exception e) {
            System.out.println("[TaskServlet] Lỗi khi load ToDo: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Không thể tải dữ liệu todo\"}");
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
        return "Short description";
    }// </editor-fold>

}
