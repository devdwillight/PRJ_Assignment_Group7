/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Todo;

import com.dao.Todo.TodoDAO;
import com.model.ToDo;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public class TodoService implements ITodoService {

    private final TodoDAO todoDAO;

    public TodoService() {
        this.todoDAO = new TodoDAO();
    }

    @Override
    public int countTodo() {
        int count = todoDAO.countTodo();
        System.out.println("[countTodo] ✔ Tổng số ToDo: " + count);
        return count;
    }

    @Override
    public boolean updateTodo(ToDo todo) {
        System.out.println("[updateTodo] Cập nhật ToDo ID = " + todo.getIdTodo());
        boolean result = todoDAO.updateTodo(todo);
        System.out.println("[updateTodo] " + (result ? "✔ Thành công" : "✖ Thất bại"));
        return result;
    }

    @Override
    public boolean removeTodo(int id) {
        System.out.println("[removeTodo] Xoá ToDo ID = " + id);
        boolean result = todoDAO.deleteTodo(id);
        System.out.println("[removeTodo] " + (result ? "✔ Đã xoá" : "✖ Không tồn tại"));
        return result;
    }

    @Override
    public ToDo createTodo(ToDo todo) {
        System.out.println("[createTodo] Tạo mới ToDo: " + todo.getTitle());
        if (todoDAO.insertTodo(todo)) {
            System.out.println("[createTodo] ✔ Đã thêm với ID: " + todo.getIdTodo());
            return todo;
        }
        System.out.println("[createTodo] ✖ Thêm thất bại");
        return null;
    }

    @Override
    public ToDo getToDoById(int id) {
        System.out.println("[getToDoById] Tìm ToDo ID = " + id);
        ToDo todo = todoDAO.selectTodoById(id);
        if (todo != null) {
            System.out.println("[getToDoById] ✔ Tìm thấy: " + todo.getTitle());
        } else {
            System.out.println("[getToDoById] ✖ Không tìm thấy");
        }
        return todo;
    }

    @Override
    public List<ToDo> getAllToDo() {
        System.out.println("[getAllToDo] Lấy tất cả ToDo");
        List<ToDo> list = todoDAO.selectAllTodo();
        System.out.println("[getAllToDo] ✔ Tổng: " + list.size());
        return list;
    }

    @Override
    public List<ToDo> getByDateRange(Date startDate, Date endDate) {
        System.out.println("[getByDateRange] Từ ngày " + startDate + " đến " + endDate);
        List<ToDo> list = todoDAO.selectByDateRange(startDate, endDate);
        System.out.println("[getByDateRange] ✔ Số ToDo tìm thấy: " + list.size());
        return list;
    }

    @Override
    public List<ToDo> getToDoByTaskId(int id) {
        System.out.println("[getToDoByTaskId] Lấy tất cả ToDo");
        List<ToDo> list = todoDAO.selectAllToDoByTaskId(id);
        System.out.println("[getToDoByTaskId] ✔ Tổng: " + list.size());
        return list;
    }

    @Override
    public List<ToDo> getAllToDoByUserId(int userId) {
        System.out.println("[getAllToDoByUserId] Lấy tất cả ToDo của userId = " + userId);
        List<ToDo> list = todoDAO.selectAllTodoByUserId(userId);
        System.out.println("[getAllToDoByUserId] ✔ Tổng: " + list.size());
        for (ToDo t : list) {
            System.out.println("ID  : " + t.getIdTodo() 
                    + "Tiêu đề    : " + t.getTitle()
                    + "Nội dung   : " + t.getDescription()
                    + "Hạn chót   : "   + t.getDueDate() 
                    + "Trạng thái : "+ (t.getIsCompleted() ? "Đã hoàn thành ✅" : "Chưa hoàn thành ❌"));
        }
        return list;
    }

    @Override
    public boolean completeTodo(int id) {
        System.out.println("[completeTodo] Hoàn thành ToDo ID = " + id);
        try {
            // Lấy ToDo hiện tại
            ToDo todo = todoDAO.selectTodoById(id);
            if (todo == null) {
                System.out.println("[completeTodo] ✖ Không tìm thấy ToDo với ID: " + id);
                return false;
            }
            
            // Cập nhật trạng thái thành hoàn thành
            todo.setIsCompleted(true);
            todo.setUpdatedAt(new Date());
            
            // Lưu vào database
            boolean result = todoDAO.updateTodo(todo);
            System.out.println("[completeTodo] " + (result ? "✔ Đã hoàn thành" : "✖ Thất bại"));
            return result;
        } catch (Exception e) {
            System.out.println("[completeTodo] ✖ Lỗi: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean updateTodoStatus(int id, boolean isCompleted) {
        System.out.println("[updateTodoStatus] Cập nhật trạng thái ToDo ID = " + id + " thành " + (isCompleted ? "hoàn thành" : "chưa hoàn thành"));
        try {
            // Lấy ToDo hiện tại
            ToDo todo = todoDAO.selectTodoById(id);
            if (todo == null) {
                System.out.println("[updateTodoStatus] ✖ Không tìm thấy ToDo với ID: " + id);
                return false;
            }
            
            // Cập nhật trạng thái
            todo.setIsCompleted(isCompleted);
            todo.setUpdatedAt(new Date());
            
            // Lưu vào database
            boolean result = todoDAO.updateTodo(todo);
            System.out.println("[updateTodoStatus] " + (result ? "✔ Cập nhật thành công" : "✖ Thất bại"));
            return result;
        } catch (Exception e) {
            System.out.println("[updateTodoStatus] ✖ Lỗi: " + e.getMessage());
            return false;
        }
    }

    public static void main(String[] args) {
        TodoService service = new TodoService();
        List<ToDo> todos = service.getAllToDoByUserId(1);

        System.out.println("📝 Danh sách tất cả ToDo:");
        for (ToDo t : todos) {
            System.out.println("-----------------------------");
            System.out.println("ID         : " + t.getIdTodo());
            System.out.println("Tiêu đề    : " + t.getTitle());
            System.out.println("Nội dung   : " + t.getDescription());
            System.out.println("Hạn chót   : " + t.getDueDate());
            System.out.println("Trạng thái : " + (t.getIsCompleted() ? "Đã hoàn thành ✅" : "Chưa hoàn thành ❌"));
        }
        System.out.println("-----------------------------");
        System.out.println("Tổng cộng: " + todos.size() + " công việc.");
    }

}
