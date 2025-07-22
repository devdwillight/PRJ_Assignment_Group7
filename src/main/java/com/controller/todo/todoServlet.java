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
import com.model.ToDo;
import com.service.Task.TaskService;
import com.service.Todo.TodoService;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author DELL
 */
@WebServlet(name = "todoServlet", urlPatterns = {"/todo"})
public class todoServlet extends HttpServlet {

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
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("views/login/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("getAllTodos".equals(action)) {
            handleGetAllTodos(request, response, userId);
            return;
        }
    }

    private void handleGetAllTodos(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try {
            List<ToDo> todos = todoService.getAllToDoByUserId(userId);

            StringBuilder jsonResponse = new StringBuilder("[");
            for (int i = 0; i < todos.size(); i++) {
                ToDo t = todos.get(i);
                jsonResponse.append("{")
                        .append("\"idTodo\":").append(t.getIdTodo()).append(",")
                        .append("\"title\":\"").append(t.getTitle().replace("\"", "\\\"")).append("\",")
                        .append("\"description\":\"")
                        .append(t.getDescription() != null ? t.getDescription().replace("\"", "\\\"") : "")
                        .append("\",")
                        .append("\"dueDate\":\"").append(t.getDueDate()).append("\",")
                        .append("\"isAllDay\":").append(t.getIsAllDay() != null && t.getIsAllDay() ? "true" : "false")
                        .append(",")
                        .append("\"isCompleted\":")
                        .append(t.getIsCompleted() != null && t.getIsCompleted() ? "true" : "false").append(",")
                        .append("\"taskId\":")
                        .append((t.getIdTask() != null && t.getIdTask().getIdTask() != null) ? t.getIdTask().getIdTask()
                                : "null")
                        .append("}");
                if (i < todos.size() - 1) {
                    jsonResponse.append(",");
                }
            }
            jsonResponse.append("]");

            response.getWriter().write(jsonResponse.toString());

        } catch (Exception e) {
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
            String todoIdStr = request.getParameter("todoId");
            if (todoIdStr == null) {
                out.print("{\"success\":false, \"error\":\"Thiếu todoId\"}");
                return;
            }
            try {
                int todoId = Integer.parseInt(todoIdStr);
                System.out.println("[todoServlet] Xóa ToDo với ID: " + todoId);

                com.service.Todo.TodoService service = new com.service.Todo.TodoService();
                boolean deleted = service.removeTodo(todoId);

                if (deleted) {
                    System.out.println("[todoServlet] ✅ Xóa ToDo thành công");
                    out.print("{\"success\":true}");
                } else {
                    System.out.println("[todoServlet] ❌ Xóa ToDo thất bại");
                    out.print("{\"success\":false, \"error\":\"Không thể xóa ToDo\"}");
                }
            } catch (NumberFormatException e) {
                System.out.println("[todoServlet] Lỗi parse todoId: " + e.getMessage());
                out.print("{\"success\":false, \"error\":\"ID ToDo không hợp lệ\"}");
            } catch (Exception e) {
                System.out.println("[todoServlet] Lỗi xóa ToDo: " + e.getMessage());
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

        if ("updateTodoStatus".equals(action)) {
            String todoIdStr = request.getParameter("todoId");
            String isCompletedStr = request.getParameter("isCompleted");

            if (todoIdStr == null || isCompletedStr == null) {
                out.print("{\"success\":false, \"error\":\"Thiếu thông tin bắt buộc\"}");
                return;
            }

            try {
                int todoId = Integer.parseInt(todoIdStr);
                boolean isCompleted = Boolean.parseBoolean(isCompletedStr);

                System.out.println("[todoServlet] Cập nhật trạng thái ToDo:");
                System.out.println("  - TodoId: " + todoId);
                System.out.println("  - IsCompleted: " + isCompleted);

                com.service.Todo.TodoService service = new com.service.Todo.TodoService();
                boolean updated = service.updateTodoStatus(todoId, isCompleted);

                if (updated) {
                    System.out.println("[todoServlet] ✅ Cập nhật trạng thái thành công");
                    out.print("{\"success\":true}");
                } else {
                    System.out.println("[todoServlet] ❌ Cập nhật trạng thái thất bại");
                    out.print("{\"success\":false, \"error\":\"Không thể cập nhật trạng thái ToDo\"}");
                }
            } catch (Exception e) {
                System.out.println("[todoServlet] Lỗi cập nhật trạng thái ToDo: " + e.getMessage());
                out.print("{\"success\":false, \"error\":\"Lỗi cập nhật trạng thái ToDo\"}");
            }
            return;
        }

        if ("updateTime".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String start = request.getParameter("start");
                String allDayStr = request.getParameter("allDay");

                if (start == null || start.isEmpty()) {
                    out.print("{\"success\":false, \"error\":\"Thiếu thông tin ngày giờ mới\"}");
                    return;
                }

                // Parse start thành Timestamp theo chuẩn OffsetDateTime (UTC)
                java.sql.Timestamp dueDateTime;
                try {
                    String s = start;
                    if (s.length() == 10) {
                        s += "T00:00:00Z"; // Nếu chỉ có ngày, thêm giờ mặc định
                    }
                    dueDateTime = java.sql.Timestamp.from(java.time.OffsetDateTime.parse(s).toInstant());
                } catch (Exception e) {
                    out.print("{\"success\":false, \"error\":\"Định dạng ngày/giờ không hợp lệ\"}");
                    return;
                }

                // Lấy ToDo từ DB
                ToDo todo = todoService.getToDoById(id);
                if (todo == null) {
                    out.print("{\"success\":false, \"error\":\"ToDo không tồn tại\"}");
                    return;
                }

                // Cập nhật ngày giờ và allDay
                todo.setDueDate(dueDateTime);
                todo.setIsAllDay("true".equals(allDayStr) || "on".equals(allDayStr));
                todo.setUpdatedAt(new java.util.Date());

                boolean updated = todoService.updateTodo(todo);
                if (updated) {
                    out.print("{\"success\":true}");
                } else {
                    out.print("{\"success\":false, \"error\":\"Không thể cập nhật ToDo\"}");
                }
            } catch (Exception e) {
                out.print("{\"success\":false, \"error\":\"Lỗi xử lý updateTime: " + e.getMessage() + "\"}");
            }
            return;
        }

        if ("getTodoDetail".equals(action)) {
            int todoId = Integer.parseInt(request.getParameter("todoId"));
            com.service.Todo.TodoService service = new com.service.Todo.TodoService();
            com.model.ToDo todo = service.getToDoById(todoId);

            // Trả về JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (todo != null) {
                // Tạo JSON object với thông tin todo
                // Trả về response.success = true và response.todo = todo object
                out.print("{\"success\":true, \"todo\":" + todo.toString() + "}");
            } else {
                // Trả về response.success = false và response.error = "Todo không tồn tại"
                out.print("{\"success\":false, \"error\":\"Todo không tồn tại\"}");
            }
            return;
        }

        if ("updateTodoTask".equals(action)) {
            String todoIdStr = request.getParameter("todoId");
            String newTaskIdStr = request.getParameter("newTaskId");

            if (todoIdStr == null || newTaskIdStr == null) {
                out.print("{\"success\":false, \"error\":\"Thiếu thông tin bắt buộc\"}");
                return;
            }

            try {
                int todoId = Integer.parseInt(todoIdStr);
                int newTaskId = Integer.parseInt(newTaskIdStr);

                System.out.println("[todoServlet] Di chuyển ToDo:");
                System.out.println("  - TodoId: " + todoId);
                System.out.println("  - NewTaskId: " + newTaskId);

                com.service.Todo.TodoService service = new com.service.Todo.TodoService();
                com.model.ToDo todo = service.getToDoById(todoId);

                if (todo == null) {
                    out.print("{\"success\":false, \"error\":\"ToDo không tồn tại\"}");
                    return;
                }

                // Tạo task object mới
                com.model.Task newTask = new com.model.Task();
                newTask.setIdTask(newTaskId);
                todo.setIdTask(newTask);

                boolean updated = service.updateTodo(todo);

                if (updated) {
                    System.out.println("[todoServlet] ✅ Di chuyển ToDo thành công");
                    out.print("{\"success\":true, \"message\":\"Di chuyển ToDo thành công\"}");
                } else {
                    System.out.println("[todoServlet] ❌ Di chuyển ToDo thất bại");
                    out.print("{\"success\":false, \"error\":\"Không thể di chuyển ToDo\"}");
                }
            } catch (NumberFormatException e) {
                System.out.println("[todoServlet] Lỗi parse ID: " + e.getMessage());
                out.print("{\"success\":false, \"error\":\"ID không hợp lệ\"}");
            } catch (Exception e) {
                System.out.println("[todoServlet] Lỗi di chuyển ToDo: " + e.getMessage());
                out.print("{\"success\":false, \"error\":\"Lỗi di chuyển ToDo\"}");
            }
            return;
        }

        if ("updateTodo".equals(action)) {
            // Lấy dữ liệu từ request
            String todoIdStr = request.getParameter("todoId");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String dueDateStr = request.getParameter("dueDate");
            String dueTime = request.getParameter("dueTime");
            String isAllDayStr = request.getParameter("isAllDay");

            System.out.println("[todoServlet] Cập nhật todo với dữ liệu:");
            System.out.println("  - TodoId: " + todoIdStr);
            System.out.println("  - Title: " + title);
            System.out.println("  - Description: " + description);
            System.out.println("  - DueDate: " + dueDateStr);
            System.out.println("  - DueTime: " + dueTime);
            System.out.println("  - IsAllDay: " + isAllDayStr);

            // Validate
            if (todoIdStr == null || title == null || dueDateStr == null) {
                out.print("{\"success\":false, \"error\":\"Thiếu thông tin bắt buộc\"}");
                return;
            }

            try {
                int todoId = Integer.parseInt(todoIdStr);
                com.service.Todo.TodoService service = new com.service.Todo.TodoService();
                com.model.ToDo todo = service.getToDoById(todoId);

                if (todo == null) {
                    out.print("{\"success\":false, \"error\":\"ToDo không tồn tại\"}");
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

                // Cập nhật thông tin todo
                todo.setTitle(title);
                todo.setDescription(description);
                todo.setDueDate(dueDateTime);
                todo.setIsAllDay("on".equals(isAllDayStr));
                todo.setUpdatedAt(new java.util.Date());

                System.out.println("[todoServlet] Todo object đã cập nhật:");
                System.out.println("  - Title: " + todo.getTitle());
                System.out.println("  - DueDate: " + todo.getDueDate());
                System.out.println("  - IsAllDay: " + todo.getIsAllDay());
                System.out.println("  - UpdatedAt: " + todo.getUpdatedAt());

                // Gọi service để cập nhật
                boolean updated = service.updateTodo(todo);

                if (updated) {
                    System.out.println("[todoServlet] ✅ Cập nhật thành công");
                    out.print("{\"success\":true}");
                } else {
                    System.out.println("[todoServlet] ❌ Cập nhật thất bại");
                    out.print("{\"success\":false, \"error\":\"Không thể cập nhật ToDo\"}");
                }
            } catch (NumberFormatException e) {
                System.out.println("[todoServlet] Lỗi parse todoId: " + e.getMessage());
                out.print("{\"success\":false, \"error\":\"ID ToDo không hợp lệ\"}");
            } catch (Exception e) {
                System.out.println("[todoServlet] Lỗi cập nhật ToDo: " + e.getMessage());
                out.print("{\"success\":false, \"error\":\"Lỗi cập nhật ToDo\"}");
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
