/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.email.service;

import com.dao.Reminder.EmailReminderDAO;
import com.model.EmailReminder;
import com.model.UserEvents;
import jakarta.mail.*;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.List;
import java.util.Properties;

/**
 *
 * @author Admin
 */
public class EmailSenderService {

    private final EmailReminderDAO reminderDAO = new EmailReminderDAO();

    // Cấu hình email của bạn tại đây
    private final String from = "ducle0554@gmail.com";
    private final String password = "gyip lwwx fdpq bpba"; // ⚠️ Không phải mật khẩu Gmail, mà là app password

    public void sendRemindersByEventId(int eventId) {
        List<EmailReminder> reminders = reminderDAO.findRemindersByEventId(eventId);

        for (EmailReminder reminder : reminders) {
            if (!reminder.isEmailSent()) {
                try {
                    sendEmail(reminder);
                    reminderDAO.markAsSent(reminder);
                } catch (Exception e) {
                    System.err.println("❌ Gửi email thất bại cho eventId=" + eventId);
                    e.printStackTrace();
                }
            }
        }
    }

    private void sendEmail(EmailReminder reminder) throws MessagingException {
        UserEvents event = reminder.getEvent();
        String to = event.getIdCalendar().getIdUser().getFirstName(); // đảm bảo UserEvents có getUser().getEmail()
        String subject = "📅 Nhắc nhở sự kiện sắp tới!";
        String content = "Bạn có sự kiện bắt đầu lúc " + event.getStartDate() + ". Đừng quên nhé!";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(content);

        Transport.send(message);
        System.out.println("✅ Đã gửi email đến: " + to);
    }
}
