/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.todo;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author DELL
 */
@WebServlet(name = "todoServlet", urlPatterns = {"/todo"})
public class todoServlet extends HttpServlet {

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
            out.println("<title>Servlet todoServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet todoServlet at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");
        System.out.println("todoServlet: action=" + action);
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if ("createTodo".equals(action)) {
            // Lấy dữ liệu từ request
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String dueDateStr = request.getParameter("dueDate");
            String dueTime = request.getParameter("dueTime");
            String isAllDayStr = request.getParameter("isAllDay");
            String taskIdStr = request.getParameter("taskId");

            System.out.println("[todoServlet] Tạo todo với dữ liệu:");
            System.out.println("  - Title: " + title);
            System.out.println("  - Description: " + description);
            System.out.println("  - DueDate: " + dueDateStr);
            System.out.println("  - DueTime: " + dueTime);
            System.out.println("  - IsAllDay: " + isAllDayStr);
            System.out.println("  - TaskId: " + taskIdStr);

            // Validate
            if (title == null || dueDateStr == null || taskIdStr == null) {
                out.print("{\"success\":false, \"error\":\"Thiếu thông tin bắt buộc\"}");
                return;
            }

            // Parse ngày và giờ
            java.sql.Timestamp dueDateTime;
            try {
                String dateTimeStr = dueDateStr;
                if (dueTime != null && !dueTime.isEmpty()) {
                    dateTimeStr += " " + dueTime + ":00";
                } else {
                    dateTimeStr += " 00:00:00";
                }
                dueDateTime = java.sql.Timestamp.valueOf(dateTimeStr.replace("T", " "));
                System.out.println("[todoServlet] DueDateTime parsed: " + dueDateTime);
            } catch (Exception e) {
                System.out.println("[todoServlet] Lỗi parse datetime: " + e.getMessage());
                out.print("{\"success\":false, \"error\":\"Định dạng ngày/giờ không hợp lệ\"}");
                return;
            }

            // Tạo ToDo object
            com.model.ToDo todo = new com.model.ToDo();
            todo.setTitle(title);
            todo.setDescription(description);
            todo.setDueDate(dueDateTime);
            todo.setIsAllDay("on".equals(isAllDayStr));
            
            // Set các giá trị mặc định
            todo.setIsCompleted(false);
            todo.setCreatedAt(new java.util.Date());
            todo.setUpdatedAt(new java.util.Date());
            
            com.model.Task task = new com.model.Task();
            task.setIdTask(Integer.parseInt(taskIdStr));
            todo.setIdTask(task);
            // TODO: set userId nếu cần

            System.out.println("[todoServlet] Todo object đã tạo:");
            System.out.println("  - Title: " + todo.getTitle());
            System.out.println("  - TaskId: " + todo.getIdTask().getIdTask());
            System.out.println("  - IsCompleted: " + todo.getIsCompleted());
            System.out.println("  - CreatedAt: " + todo.getCreatedAt());
            System.out.println("  - UpdatedAt: " + todo.getUpdatedAt());

            // Gọi service
            com.service.Todo.TodoService service = new com.service.Todo.TodoService();
            com.model.ToDo created = service.createTodo(todo);

            if (created != null) {
                System.out.println("[todoServlet] ✅ Tạo thành công với ID: " + created.getIdTodo());
                out.print("{\"success\":true, \"id\":" + created.getIdTodo() + "}");
            } else {
                System.out.println("[todoServlet] ❌ Tạo thất bại");
                out.print("{\"success\":false, \"error\":\"Không thể thêm ToDo\"}");
            }
            return;
        }

        if ("deleteTodo".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                out.print("{\"success\":false, \"error\":\"Thiếu id\"}");
                return;
            }
            try {
                int id = Integer.parseInt(idStr);
                com.service.Todo.TodoService service = new com.service.Todo.TodoService();
                boolean deleted = service.removeTodo(id);
                if (deleted) {
                    out.print("{\"success\":true}");
                } else {
                    out.print("{\"success\":false, \"error\":\"Không thể xóa ToDo\"}");
                }
            } catch (Exception e) {
                out.print("{\"success\":false, \"error\":\"Lỗi xóa ToDo\"}");
            }
            return;
        }

        if ("completeTodo".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                out.print("{\"success\":false, \"error\":\"Thiếu id\"}");
                return;
            }
            try {
                int id = Integer.parseInt(idStr);
                com.service.Todo.TodoService service = new com.service.Todo.TodoService();
                boolean completed = service.completeTodo(id);
                if (completed) {
                    out.print("{\"success\":true}");
                } else {
                    out.print("{\"success\":false, \"error\":\"Không thể hoàn thành ToDo\"}");
                }
            } catch (Exception e) {
                System.out.println("[todoServlet] Lỗi hoàn thành ToDo: " + e.getMessage());
                out.print("{\"success\":false, \"error\":\"Lỗi hoàn thành ToDo\"}");
            }
            return;
        }

        // ... các action khác ...
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
