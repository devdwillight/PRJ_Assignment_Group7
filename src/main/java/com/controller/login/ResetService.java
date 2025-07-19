/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.login;


import java.time.LocalDateTime;
import java.util.Properties;
import java.util.UUID;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author HP
 */
public class ResetService {
    private final int LIMIT_MINUS = 10;
    static final String from = "nguyentuanqb201125@gmail.com";
    static final String password = "dvig bkcj fctq picp";
    
    public String generateToken() {
        return UUID.randomUUID().toString();
    }
    
    public LocalDateTime expireDateTime() {
        return LocalDateTime.now().plusMinutes(LIMIT_MINUS);
    }
    
    public boolean isExpireTime(LocalDateTime time) {
        return LocalDateTime.now().isAfter(time);
    }
    
    
    public boolean sendEmail(String to, String link, String name) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        
        
        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };
        
        Session session = Session.getInstance(props, auth);
        
        MimeMessage msg = new MimeMessage(session);
        
        try {
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(from);
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject("Reset Password", "UTF-8");
            String content = "<h1>Hello"+name+"</h1>"+"<p>Click the link to reset password "
                    + "<a href="+link+">Click here</a></p>";
            msg.setContent(content, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("Send successfully");
            return true;
        } catch (Exception e) {
            System.out.println("Send error");
            System.out.println(e);
            return false;
        }
    }
    
    public boolean sendEmailEvent(String to, String subject, String content) {
    Properties props = new Properties();
    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.port", "587");
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.starttls.enable", "true");

    Authenticator auth = new Authenticator() {
        @Override
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(from, password);
        }
    };

    Session session = Session.getInstance(props, auth);
    MimeMessage msg = new MimeMessage(session);

    try {
        msg.addHeader("Content-type", "text/html; charset=UTF-8");
        msg.setFrom(from);
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
        msg.setSubject(subject, "UTF-8");
        msg.setContent(content, "text/html; charset=UTF-8");
        Transport.send(msg);
        System.out.println("Send successfully");
        return true;
    } catch (Exception e) {
        System.out.println("Send error");
        System.out.println(e);
        return false;
    }
}
}

