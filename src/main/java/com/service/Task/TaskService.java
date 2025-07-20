/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Task;

import com.dao.Task.TaskDAO;
import com.model.Task;
import java.util.List;

/**
 *
 * @author DELL
 */
public class TaskService implements ITaskService {

    private final TaskDAO taskDAO;

    public TaskService() {
        this.taskDAO = new TaskDAO();
    }

    @Override
    public int countTask() {
        int count = taskDAO.countTask();
        System.out.println("[countTask] Tổng số công việc: " + count);
        return count;
    }

    @Override
    public boolean updateTask(Task task) {
        System.out.println("[updateTask] Cập nhật task ID = " + task.getIdTask());
        boolean success = taskDAO.updateTask(task);
        System.out.println("[updateTask] " + (success ? "✔ Thành công" : "✖ Thất bại"));
        return success;
    }

    @Override
    public boolean removeTask(int id) {
        System.out.println("[removeTask] Xoá task ID = " + id);
        boolean success = taskDAO.deleteTask(id);
        System.out.println("[removeTask] " + (success ? "✔ Đã xoá" : "✖ Không tìm thấy"));
        return success;
    }

    @Override
    public Task createTask(Task task) {
        System.out.println("[createTask] Tạo mới công việc: " + task.getName());
        if (taskDAO.insertTask(task)) {
            System.out.println("[createTask] ✔ Đã tạo task với ID = " + task.getIdTask());
            return task;
        } else {
            System.out.println("[createTask] ✖ Không thể tạo task");
            return null;
        }
    }

    @Override
    public Task getTaskById(int id) {
        System.out.println("[getTaskById] Lấy task theo ID = " + id);
        Task task = taskDAO.selectTaskById(id);
        if (task != null) {
            System.out.println("[getTaskById] ✔ Tìm thấy task: " + task.getName());
        } else {
            System.out.println("[getTaskById] ✖ Không tìm thấy task");
        }
        return task;
    }

    @Override
    public List<Task> getAllTasks() {
        System.out.println("[getAllTasks] Lấy toàn bộ danh sách task");
        List<Task> list = taskDAO.selectAllTasks();
        System.out.println("[getAllTasks] ✔ Tổng số: " + list.size() + " task");
        return list;
    }

    // 🧪 Test nhanh
    public static void main(String[] args) {
        TaskService service = new TaskService();
        List<Task> tasks = service.getAllTasks();

        System.out.println("📋 Danh sách các task:");
        for (Task t : tasks) {
            System.out.println("ID: " + t.getIdTask() + ", Tiêu đề: " + t.getName() + ", Thời gian tạo " + t.getCreatedAt());
        }

        System.out.println("Tổng số task: " + service.countTask());
    }
}
