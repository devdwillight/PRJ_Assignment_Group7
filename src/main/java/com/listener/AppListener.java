package com.listener;

import com.reminder.ReminderScheduler;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppListener implements ServletContextListener {

    private ReminderScheduler reminderScheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        reminderScheduler = new ReminderScheduler();
        reminderScheduler.start();
        System.out.println(">>> ReminderScheduler started by AppListener");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (reminderScheduler != null) {
            reminderScheduler.stop();
        }
        System.out.println(">>> App destroyed");
    }
}
