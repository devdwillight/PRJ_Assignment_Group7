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

 
    
    public static void main(String[] args) {
        TodoService service = new TodoService();
        List<ToDo> todos = service.getAllToDo();

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
