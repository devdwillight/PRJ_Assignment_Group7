package com.reminder;

import com.dao.Event.EventDAO;
import com.model.UserEvents;
import com.model.Calendar;
import com.model.User;
import com.controller.login.ResetService; // dùng luôn gửi mail của bạn
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.HashSet;
import java.util.Set;

public class ReminderScheduler {

    private final EventDAO userEventsDAO = new EventDAO();
    private final ResetService mailSender = new ResetService();
    private Timer timer; // Lưu reference để có thể dừng

    // Lưu ID của event đã gửi email (trong vòng đời app)
    private static final Set<Integer> sentEventIds = new HashSet<>();

    public void start() {
        if (timer != null) {
            timer.cancel(); // Dừng timer cũ nếu có
        }
        
        timer = new Timer(true); // background thread
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                try {
                    // Kiểm tra xem ứng dụng có đang chạy không
                    if (timer == null) {
                        return; // Timer đã bị dừng
                    }
                    
                    List<UserEvents> events = userEventsDAO.getEventsToRemind();

                    // Lọc ra chỉ những event chưa gửi
                    for (UserEvents event : events) {
                        int eventId = event.getIdEvent();
                        if (sentEventIds.contains(eventId)) {
                            continue; // Bỏ qua nếu đã gửi email trước đó
                        }

                        Calendar calendar = event.getIdCalendar();
                        if (calendar != null) {
                            User user = calendar.getIdUser();
                            if (user != null && user.getEmail() != null) {
                                String to = user.getEmail();
                                String subject = "[Reminder] Sắp đến sự kiện: " + event.getName();
                                String body = "<h3>Bạn có lịch: " + event.getName() + "</h3>" +
                                              "<p>Bắt đầu lúc: " + event.getStartDate() + "</p>" +
                                              "<p>Vị trí: " + (event.getLocation() == null ? "N/A" : event.getLocation()) + "</p>" +
                                              "<p>Chi tiết: " + (event.getDescription() == null ? "" : event.getDescription()) + "</p>";
                                boolean sent = mailSender.sendEmailEvent(to, subject, body);
                                // Chỉ đánh dấu đã gửi khi gửi thành công
                                if (sent) {
                                    sentEventIds.add(eventId);
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    // Log lỗi nhưng không crash timer thread
                    System.err.println("Error in ReminderScheduler: " + e.getMessage());
                    // Không in stack trace để tránh spam log khi ứng dụng shutdown
                }
            }
        }, 0, 60 * 1000); // check mỗi 1 phút (60*1000ms) – Càng nhỏ càng chính xác
    }
    
    public void stop() {
        if (timer != null) {
            timer.cancel();
            timer = null;
            System.out.println(">>> ReminderScheduler stopped");
        }
    }
}
