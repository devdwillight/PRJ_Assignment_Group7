/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.task;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.service.Task.TaskService;
import com.service.Todo.TodoService;
import com.model.Task;
import com.model.ToDo;
import java.util.List;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.io.PrintWriter;

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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
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
        if ("getAllTasks".equals(action)) {
            handleGetAllTasks(request, response, userId);
            return;
        }

        try {
            System.out.println("[taskServlet doGet] Starting to load data for user " + userId);
            
            // Lấy danh sách Task của user
            List<Task> tasks = taskService.getAllTasksByUserIdOrderByPosition(userId);
            
            System.out.println("[taskServlet doGet] Found " + tasks.size() + " tasks for user " + userId);

            // Gán danh sách ToDo cho từng Task
            for (Task task : tasks) {
                try {
                    List<ToDo> allTodos = todoService.getToDoByTaskId(task.getIdTask());
                    task.setToDoList(allTodos);
                    System.out.println("Task " + task.getIdTask() + " - Total todos: " + allTodos.size());
                } catch (Exception e) {
                    System.err.println("[taskServlet doGet] Error loading todos for task " + task.getIdTask() + ": " + e.getMessage());
                    task.setToDoList(new ArrayList<>());
                }
            }

            // Lấy tất cả todos để truyền cho subSiderbar.jsp
            List<ToDo> allTodos = todoService.getAllToDoByUserId(userId);
            System.out.println("[taskServlet doGet] Found " + allTodos.size() + " todos for user " + userId);

            // Set attribute cho task.jsp (columns)
            request.setAttribute("columns", tasks);

            // Set attribute cho subSiderbar.jsp (tasks và todos)
            request.setAttribute("tasks", tasks);
            request.setAttribute("todos", allTodos);

            System.out.println("[taskServlet doGet] Forwarding to subHome.jsp");
            request.getRequestDispatcher("subHome.jsp").forward(request, response);
            System.out.println("[taskServlet doGet] Forward completed");
        } catch (Exception e) {
            System.err.println("[taskServlet doGet] Error: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("Lỗi khi tải dữ liệu: " + e.getMessage());
            out.flush();
        }
    }



    private void handleGetAllTasks(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            List<Task> tasks = taskService.getAllTasksByUserId(userId);
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < tasks.size(); i++) {
                Task t = tasks.get(i);
                json.append("{")
                        .append("\"idTask\":").append(t.getIdTask()).append(",")
                        .append("\"name\":\"").append(t.getName().replace("\"", "\\\"")).append("\"")
                        .append("}");
                if (i < tasks.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            out.print(json.toString());
            out.flush();
        } catch (Exception e) {
            System.err.println("[handleGetAllTasks] Error: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Không thể tải dữ liệu tasks\"}");
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("views/login/login.jsp");
            return;
        }
        String action = request.getParameter("action");
        System.out.println("[taskServlet doPost] Action: " + action);
        System.out.println("[taskServlet doPost] Action length: " + (action != null ? action.length() : "null"));
        System.out.println("[taskServlet doPost] Action equals 'deleteTask': " + "deleteTask".equals(action));
        System.out.println("[taskServlet doPost] UserId: " + userId);
        
        if (action == null) {
            action = "";
        }
        // Sử dụng if-else thay vì switch để debug
        if ("createTask".equals(action)) {
            handleCreateTask(request, response, userId);
            return;
        } else if ("updateColumnPosition".equals(action)) {
            handleUpdateColumnPosition(request, response, userId);
            return;
        } else if ("updateTaskName".equals(action)) {
            System.out.println("[taskServlet doPost] Processing updateTaskName action");
            handleUpdateTaskName(request, response, userId);
            return;
        } else if ("edit".equals(action)) {
            handleEditTask(request, response, userId);
            return;
        } else if ("deleteTask".equals(action)) {
            System.out.println("[taskServlet doPost] Processing deleteTask action");
            handleDeleteTaskAjax(request, response, userId);
            return;
        } else {
            System.out.println("[taskServlet doPost] Unknown action: " + action);
            // Không làm gì
        }
    }

    private void handleCreateTask(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String name = request.getParameter("name");
            String color = request.getParameter("color");

            if (name == null || name.trim().isEmpty()) {
                out.print("{\"success\":false,\"error\":\"Tên Task không được để trống\"}");
                out.flush();
                return;
            }

            Task task = new Task();
            task.setName(name.trim());
            task.setColor(color);
            
            // Set thời gian tạo và cập nhật
            java.util.Date currentDate = new java.util.Date();
            task.setCreatedAt(currentDate);
            task.setUpdatedAt(currentDate);
            
            com.model.User user = new com.model.User(userId);
            task.setIdUser(user);

            System.out.println("[handleCreateTask] Creating task with data:");
            System.out.println("  - Name: " + task.getName());
            System.out.println("  - Color: " + task.getColor());
            System.out.println("  - CreatedAt: " + task.getCreatedAt());
            System.out.println("  - UpdatedAt: " + task.getUpdatedAt());
            System.out.println("  - UserId: " + userId);

            Task createdTask = taskService.createTask(task);

            if (createdTask != null && createdTask.getIdTask() != null) {
                System.out.println("[handleCreateTask] ✅ Task created successfully with ID: " + createdTask.getIdTask());
                out.print("{\"success\":true,\"message\":\"Task đã được tạo thành công\"}");
            } else {
                System.out.println("[handleCreateTask] ❌ Failed to create task");
                out.print("{\"success\":false,\"error\":\"Không thể tạo Task\"}");
            }
            out.flush();
        } catch (Exception e) {
            System.err.println("[handleCreateTask] Error: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\":false,\"error\":\"Lỗi server: " + e.getMessage() + "\"}");
            out.flush();
        }
    }

    private void handleUpdateColumnPosition(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String taskIdParam = request.getParameter("taskId");
            String oldPositionParam = request.getParameter("oldPosition");
            String newPositionParam = request.getParameter("newPosition");

            if (taskIdParam == null || oldPositionParam == null || newPositionParam == null) {
                out.print("{\"success\":false,\"error\":\"Thiếu thông tin cần thiết\"}");
                out.flush();
                return;
            }

            int taskId = Integer.parseInt(taskIdParam);
            int oldPosition = Integer.parseInt(oldPositionParam);
            int newPosition = Integer.parseInt(newPositionParam);

            // Kiểm tra task có thuộc về user này không
            Task task = taskService.getTaskById(taskId);
            if (task == null || !task.getIdUser().getIdUser().equals(userId)) {
                out.print("{\"success\":false,\"error\":\"Task không tồn tại hoặc không thuộc về bạn\"}");
                out.flush();
                return;
            }

            // Thực hiện reorder
            boolean success = taskService.reorderTasks(userId, oldPosition, newPosition);

            if (success) {
                // Cập nhật position của task được kéo
                taskService.updateTaskPosition(taskId, newPosition);
                out.print("{\"success\":true,\"message\":\"Cập nhật vị trí thành công\"}");
            } else {
                out.print("{\"success\":false,\"error\":\"Không thể cập nhật vị trí\"}");
            }
            out.flush();

        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"error\":\"Dữ liệu không hợp lệ\"}");
            out.flush();
        } catch (Exception e) {
            System.err.println("[handleUpdateColumnPosition] Error: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\":false,\"error\":\"Lỗi server: " + e.getMessage() + "\"}");
            out.flush();
        }
    }



    private void handleEditTask(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String color = request.getParameter("color");
        if (idParam != null) {
            try {
                int taskId = Integer.parseInt(idParam);
                Task task = taskService.getTaskById(taskId);
                if (task != null && task.getIdUser() != null && task.getIdUser().getIdUser().equals(userId)) {
                    task.setName(name);
                    task.setColor(color);
                    task.setUpdatedAt(new java.util.Date());
                    taskService.updateTask(task);
                }
            } catch (Exception e) {
                // Có thể log lỗi hoặc xử lý thông báo
            }
        }
        response.sendRedirect(request.getContextPath() + "/task");
    }

    private void handleDeleteTaskAjax(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        System.out.println("[handleDeleteTaskAjax] Starting delete task process");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String taskIdParam = request.getParameter("taskId");
            
            if (taskIdParam == null) {
                out.print("{\"success\":false,\"error\":\"Thiếu ID task\"}");
                out.flush();
                return;
            }

            int taskId = Integer.parseInt(taskIdParam);
            
            // Kiểm tra task có thuộc về user này không
            Task task = taskService.getTaskById(taskId);
            if (task == null) {
                out.print("{\"success\":false,\"error\":\"Task không tồn tại\"}");
                out.flush();
                return;
            }
            
            if (!task.getIdUser().getIdUser().equals(userId)) {
                out.print("{\"success\":false,\"error\":\"Task không thuộc về bạn\"}");
                out.flush();
                return;
            }

            // Xóa task
            boolean success = taskService.removeTask(taskId);

            if (success) {
                out.print("{\"success\":true,\"message\":\"Task đã được xóa thành công\"}");
            } else {
                out.print("{\"success\":false,\"error\":\"Không thể xóa task\"}");
            }
            out.flush();

        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"error\":\"ID task không hợp lệ\"}");
            out.flush();
        } catch (Exception e) {
            System.err.println("[handleDeleteTaskAjax] Error: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\":false,\"error\":\"Lỗi server: " + e.getMessage() + "\"}");
            out.flush();
        }
    }

    

    private void handleUpdateTaskName(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String taskIdParam = request.getParameter("taskId");
            String newTaskName = request.getParameter("newTaskName");

            System.out.println("[handleUpdateTaskName] Debug info:");
            System.out.println("  - taskIdParam: " + taskIdParam);
            System.out.println("  - newTaskName: " + newTaskName);
            System.out.println("  - userId: " + userId);

            if (taskIdParam == null || newTaskName == null || newTaskName.trim().isEmpty()) {
                System.out.println("[handleUpdateTaskName] Validation failed");
                out.print("{\"success\":false,\"error\":\"Thiếu thông tin cần thiết hoặc tên task không được để trống\"}");
                out.flush();
                return;
            }

            int taskId = Integer.parseInt(taskIdParam);
            String taskName = newTaskName.trim();

            System.out.println("[handleUpdateTaskName] Parsed values:");
            System.out.println("  - taskId: " + taskId);
            System.out.println("  - taskName: " + taskName);

            // Kiểm tra task có thuộc về user này không
            Task task = taskService.getTaskById(taskId);
            if (task == null) {
                System.out.println("[handleUpdateTaskName] Task not found: " + taskId);
                out.print("{\"success\":false,\"error\":\"Task không tồn tại\"}");
                out.flush();
                return;
            }
            
            if (!task.getIdUser().getIdUser().equals(userId)) {
                System.out.println("[handleUpdateTaskName] Task doesn't belong to user. Task userId: " + task.getIdUser().getIdUser() + ", Current userId: " + userId);
                out.print("{\"success\":false,\"error\":\"Task không thuộc về bạn\"}");
                out.flush();
                return;
            }

            System.out.println("[handleUpdateTaskName] Task found and belongs to user. Current name: " + task.getName());

            // Cập nhật tên task và thời gian cập nhật
            task.setName(taskName);
            task.setUpdatedAt(new java.util.Date());
            boolean success = taskService.updateTask(task);

            System.out.println("[handleUpdateTaskName] Update result: " + success);

            if (success) {
                out.print("{\"success\":true,\"message\":\"Cập nhật tên task thành công\"}");
            } else {
                out.print("{\"success\":false,\"error\":\"Không thể cập nhật tên task\"}");
            }
            out.flush();

        } catch (NumberFormatException e) {
            System.out.println("[handleUpdateTaskName] NumberFormatException: " + e.getMessage());
            out.print("{\"success\":false,\"error\":\"Dữ liệu không hợp lệ\"}");
            out.flush();
        } catch (Exception e) {
            System.out.println("[handleUpdateTaskName] Exception: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\":false,\"error\":\"Lỗi server: " + e.getMessage() + "\"}");
            out.flush();
        }
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
