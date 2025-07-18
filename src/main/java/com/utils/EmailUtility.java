/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.utils;

import javax.mail.*;
import javax.mail.internet.*;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

/**
 *
 * @author DELL
 */
public class EmailUtility {

    public static void send(String toEmail, String subject, String messageText) throws MessagingException, UnsupportedEncodingException {

        // Email của bạn
        final String fromEmail = "noreply.jikan@gmail.com";
        // App password nếu dùng Gmail
        final String password = "zbeq rsey liow kfhh";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(fromEmail));
        msg.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        msg.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));
        msg.setContent(messageText, "text/plain; charset=UTF-8");

        Transport.send(msg);
    }

    public static void main(String[] args) {
        String toEmail = "toantruongcong2005bee@gmail.com"; // Thay bằng email người nhận
        String subject = "Xác nhận đơn hàng từ Cửa hàng ABC";
        String message = """
                Xin chào quý khách,

                Cảm ơn bạn đã đặt hàng tại Jikan.
                Đơn hàng của bạn đã được thanh toán thành công.

                Trân trọng,
                Đội ngũ hỗ trợ khách hàng
                """;

        try {
            send(toEmail, subject, message);
            System.out.println("✅ Đã gửi email xác nhận thành công tới: " + toEmail);
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi gửi email: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
