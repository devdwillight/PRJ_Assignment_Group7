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
        
        // Tự động set position cho task mới (thêm vào cuối)
        int maxPosition = taskDAO.getMaxPositionByUserId(task.getIdUser().getIdUser());
        task.setPosition(maxPosition + 1);
        
        if (taskDAO.insertTask(task)) {
            System.out.println("[createTask] ✔ Đã tạo task với ID = " + task.getIdTask() + " tại vị trí " + task.getPosition());
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

    @Override
    public List<Task> getAllTasksByUserId(int id) {
        System.out.println("[getAllTasksByUserId] Lấy toàn bộ danh sách task");
        List<Task> list = taskDAO.selectAllByUserId(id);
        System.out.println("[getAllTasksByUserId] ✔ Tổng số: " + list.size() + " task");
        return list;
    }
    
    @Override
    public List<Task> getAllTasksByUserIdOrderByPosition(int userId) {
        System.out.println("[getAllTasksByUserIdOrderByPosition] Lấy danh sách task theo thứ tự position");
        List<Task> list = taskDAO.selectAllByUserIdOrderByPosition(userId);
        System.out.println("[getAllTasksByUserIdOrderByPosition] ✔ Tổng số: " + list.size() + " task");
        return list;
    }
    
    @Override
    public boolean updateTaskPosition(int taskId, int newPosition) {
        System.out.println("[updateTaskPosition] Cập nhật vị trí task ID = " + taskId + " thành position = " + newPosition);
        boolean success = taskDAO.updateTaskPosition(taskId, newPosition);
        System.out.println("[updateTaskPosition] " + (success ? "✔ Thành công" : "✖ Thất bại"));
        return success;
    }
    
    @Override
    public int getMaxPositionByUserId(int userId) {
        System.out.println("[getMaxPositionByUserId] Lấy position lớn nhất của user ID = " + userId);
        int maxPosition = taskDAO.getMaxPositionByUserId(userId);
        System.out.println("[getMaxPositionByUserId] ✔ Position lớn nhất: " + maxPosition);
        return maxPosition;
    }
    
    @Override
    public boolean reorderTasks(int userId, int oldPosition, int newPosition) {
        System.out.println("[reorderTasks] Sắp xếp lại task từ vị trí " + oldPosition + " đến " + newPosition);
        boolean success = taskDAO.reorderTasks(userId, oldPosition, newPosition);
        System.out.println("[reorderTasks] " + (success ? "✔ Thành công" : "✖ Thất bại"));
        return success;
    }

    // 🧪 Test nhanh
    public static void main(String[] args) {
        TaskService service = new TaskService();
        List<Task> tasks = service.getAllTasksByUserId(1);

        System.out.println("📋 Danh sách các task:");
        for (Task t : tasks) {
            System.out.println("ID: " + t.getIdTask() + ", Tiêu đề: " + t.getName() + ", Thời gian tạo " + t.getCreatedAt());
        }

        System.out.println("Tổng số task: " + service.countTask());
    }

}
