/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Reminder;

import com.model.EmailReminder;
import com.model.User;
import com.model.UserEvents;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Admin
 */
public class EmailReminderDAO {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("CLDPU");

    public void saveReminder(EmailReminder emailReminder) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(emailReminder);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<EmailReminder> findDueReminders(LocalDateTime now) {
        EntityManager em = emf.createEntityManager();
        List<EmailReminder> list = em.createQuery(
                "SELECT r FROM EmailReminder r WHERE r.emailSent = false AND r.reminderTime <= :now",
                EmailReminder.class
        ).setParameter("now", now).getResultList();
        em.close();
        return list;
    }

    public void markAsSent(EmailReminder reminder) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            reminder.setEmailSent(true);
            em.merge(reminder);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public UserEvents getNextUpcomingEventByEventId(int eventId) {
        EntityManager em = emf.createEntityManager();
        try {
            String query = "SELECT e FROM EmailReminder r "
                    + "JOIN r.event e "
                    + "WHERE e.id = :eventId AND e.startDate > CURRENT_TIMESTAMP "
                    + "ORDER BY e.startDate ASC";

            List<UserEvents> results = em.createQuery(query, UserEvents.class)
                    .setParameter("eventId", eventId)
                    .setMaxResults(1)
                    .getResultList();

            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }

    public void saveEmailReminder(int idEvent, int remindMinutes) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            // Lấy sự kiện từ id_event
            UserEvents event = em.find(UserEvents.class, idEvent);
            if (event == null) {
                System.err.println("❌ Không tìm thấy sự kiện với id = " + idEvent);
                return;
            }

            // Tính thời gian nhắc nhở
            Date startDate = event.getStartDate();
            LocalDateTime eventTime = ((Timestamp) startDate).toLocalDateTime();

            LocalDateTime reminderTime = eventTime.minusMinutes(remindMinutes);

            // Tạo reminder mới
            EmailReminder reminder = new EmailReminder();
            reminder.setEvent(event);
            reminder.setReminderTime(reminderTime);
            reminder.setEmailSent(false);

            em.persist(reminder);
            em.getTransaction().commit();
            System.out.println("✅ Đã lưu email reminder cho eventId = " + idEvent);

        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public List<EmailReminder> findRemindersByEventId(int eventId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT r FROM EmailReminder r WHERE r.event.id = :eventId", EmailReminder.class)
                    .setParameter("eventId", eventId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

}
