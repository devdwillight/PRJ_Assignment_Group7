package com.listener;

import com.reminder.ReminderScheduler;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        new ReminderScheduler().start();
        System.out.println(">>> ReminderScheduler started by AppListener");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println(">>> App destroyed");
    }
}
