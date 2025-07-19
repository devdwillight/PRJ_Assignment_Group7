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
import java.util.ArrayList;

/**
 *
 * @author DELL
 */
@WebServlet(name = "taskServlet", urlPatterns = { "/task" })
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
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
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
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
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
        if ("getTodos".equals(action)) {
            handleGetTodos(request, response, userId);
            return;
        } else if ("getAllTodos".equals(action)) {
            handleGetAllTodos(request, response, userId);
            return;
        } else if ("getAllTasks".equals(action)) {
            handleGetAllTasks(request, response, userId);
            return;
        } else if ("create".equals(action)) {
            request.getRequestDispatcher("views/task/addTask.jsp").forward(request, response);
            return;
        } else if ("edit".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int taskIdEdit = Integer.parseInt(idParam);
                    Task task = taskService.getTaskById(taskIdEdit);
                    request.setAttribute("task", task);
                } catch (Exception e) {
                    // Có thể log lỗi hoặc xử lý thông báo
                }
            }
            request.getRequestDispatcher("views/task/addTask.jsp").forward(request, response);
            return;
        }

        // Lấy danh sách Task của user
        List<Task> tasks = taskService.getAllTasksByUserId(userId);
        request.setAttribute("tasks", tasks);

        // Lấy taskId từ request (nếu có), mặc định lấy task đầu tiên
        String taskIdParam = request.getParameter("taskId");
        Integer taskId = null;
        if (taskIdParam != null && !taskIdParam.isEmpty()) {
            taskId = Integer.parseInt(taskIdParam);
        } else if (!tasks.isEmpty()) {
            taskId = tasks.get(0).getIdTask();
        }

        // Lấy ToDo theo taskId
        List<ToDo> todos = (taskId != null)
                ? todoService.getToDoByTaskId(taskId)
                : new ArrayList<>();

        // Chuyển todos sang JSON cho client nếu cần
        StringBuilder todosJson = new StringBuilder("[");
        for (int i = 0; i < todos.size(); i++) {
            ToDo t = todos.get(i);
            todosJson.append("{")
                    .append("\"idTodo\":").append(t.getIdTodo()).append(",")
                    .append("\"title\":\"").append(t.getTitle().replace("\"", "\\\"")).append("\",")
                    .append("\"description\":\"")
                    .append(t.getDescription() != null ? t.getDescription().replace("\"", "\\\"") : "").append("\",")
                    .append("\"dueDate\":\"").append(t.getDueDate()).append("\",")
                    .append("\"isAllDay\":").append(t.getIsAllDay() != null && t.getIsAllDay() ? "true" : "false")
                    .append(",")
                    .append("\"isCompleted\":")
                    .append(t.getIsCompleted() != null && t.getIsCompleted() ? "true" : "false")
                    .append("}");
            if (i < todos.size() - 1) {
                todosJson.append(",");
            }
        }
        todosJson.append("]");

        // Truyền dữ liệu sang JSP
        request.setAttribute("taskId", taskId);
        request.setAttribute("todosJson", todosJson.toString());
        request.getRequestDispatcher("views/calendar/calendar.jsp").forward(request, response);
    }

    private void handleGetTodos(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try {
            String taskIdParam = request.getParameter("taskId");
            Integer taskId = null;
            if (taskIdParam != null && !taskIdParam.isEmpty()) {
                taskId = Integer.parseInt(taskIdParam);
            } else {
                List<Task> tasks = taskService.getAllTasksByUserId(userId);
                if (!tasks.isEmpty()) {
                    taskId = tasks.get(0).getIdTask();
                }
            }
            List<ToDo> todos = (taskId != null)
                    ? todoService.getToDoByTaskId(taskId)
                    : new ArrayList<>();
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < todos.size(); i++) {
                ToDo t = todos.get(i);
                json.append("{")
                        .append("\"idTodo\":").append(t.getIdTodo()).append(",")
                        .append("\"title\":\"").append(t.getTitle().replace("\"", "\\\"")).append("\",")
                        .append("\"description\":\"")
                        .append(t.getDescription() != null ? t.getDescription().replace("\"", "\\\"") : "")
                        .append("\",")
                        .append("\"dueDate\":\"").append(t.getDueDate()).append("\",")
                        .append("\"isAllDay\":").append(t.getIsAllDay() != null && t.getIsAllDay() ? "true" : "false")
                        .append(",")
                        .append("\"isCompleted\":")
                        .append(t.getIsCompleted() != null && t.getIsCompleted() ? "true" : "false")
                        .append("}");
                if (i < todos.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Không thể tải dữ liệu todo\"}");
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

    private void handleGetAllTasks(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
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
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Không thể tải dữ liệu tasks\"}");
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
        if (action == null) {
            action = "";
        }
        switch (action) {
            case "create": {
                handleCreateTask(request, response, userId);
                return;
            }
            case "edit": {
                handleEditTask(request, response, userId);
                return;
            }
            case "delete": {
                handleDeleteTask(request, response, userId);
                return;
            }

            default: {
                // Không làm gì
            }
        }
    }

    private void handleCreateTask(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        String name = request.getParameter("name");
        String color = request.getParameter("color");
        Task task = new Task();
        task.setName(name);
        task.setColor(color);
        com.model.User user = new com.model.User(userId);
        task.setIdUser(user);
        taskService.createTask(task);
        response.sendRedirect(request.getContextPath() + "/home");
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
                    taskService.updateTask(task);
                }
            } catch (Exception e) {
                // Có thể log lỗi hoặc xử lý thông báo
            }
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }

    private void handleDeleteTask(HttpServletRequest request, HttpServletResponse response, Integer userId)
            throws IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int taskId = Integer.parseInt(idParam);
                Task task = taskService.getTaskById(taskId);
                if (task != null && task.getIdUser() != null && task.getIdUser().getIdUser().equals(userId)) {
                    boolean result = taskService.removeTask(taskId);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/home");
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
