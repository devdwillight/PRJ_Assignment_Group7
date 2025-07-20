/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Event;

import com.dao.BaseDAO;
import com.model.UserEvents;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public class EventDAO extends BaseDAO<UserEvents> implements IEventDAO {

    public EventDAO() {
        super(UserEvents.class);
    }

    @Override
    public int countEvent() {
        return (int) count();
    }

    @Override
    public boolean insertEvent(UserEvents event) {
        return save(event);
    }

    @Override
    public boolean updateEvent(UserEvents event) {
        return update(event);
    }

    @Override
    public boolean deleteEvent(int id) {
        return delete(id);
    }

    @Override
    public UserEvents selectEventById(int id) {
        return find(id);
    }

    @Override
    public List<UserEvents> selectAllEvent() {
        return findAllByEntity("UserEvents.findAll");
    }

    @Override
    public List<UserEvents> selectAllEventByCalendarId(int id) {
        return findAllById("idCalendar", id);
    }

    @Override
    public List<UserEvents> selectAllEventsByUserId(int userId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT e FROM UserEvents e WHERE e.idCalendar.idUser.idUser = :userId";
            return em.createQuery(jpql, UserEvents.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean updateEventTime(int eventId, Date start, Date end, boolean allDay) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            String jpql = "UPDATE UserEvents e SET e.startDate = :start, e.dueDate = :end, e.isAllDay = :allDay WHERE e.idEvent = :eventId";
            Query q = em.createQuery(jpql);
            q.setParameter("start", start);
            q.setParameter("end", end);
            q.setParameter("allDay", allDay);
            q.setParameter("eventId", eventId);
            int updated = q.executeUpdate();
            tx.commit();
            return updated > 0;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    @Override
    public List<UserEvents> getEventsToRemind() {
        EntityManager em = null;
        try {
            em = getEntityManager();
            Date now = new Date();

            // Lấy tất cả event cần nhắc (remindMethod = true) có startDate >= hiện tại
            String jpql
                    = "SELECT e FROM UserEvents e "
                    + "WHERE e.remindMethod = true "
                    + "AND e.startDate >= :now";
            TypedQuery<UserEvents> query = em.createQuery(jpql, UserEvents.class);
            query.setParameter("now", now);

            List<UserEvents> result = query.getResultList();

            // Lọc lại ở Java để đảm bảo nhắc đúng thời điểm, tránh gửi lặp
            List<UserEvents> toRemind = new java.util.ArrayList<>();
            long current = now.getTime();

            for (UserEvents event : result) {
                if (event.getStartDate() == null || event.getRemindBefore() == null || event.getRemindUnit() == null) {
                    continue;
                }

                long remindMs = 0;
                switch (event.getRemindUnit()) {
                    case "minutes":
                        remindMs = event.getRemindBefore() * 60L * 1000L;
                        break;
                    case "hours":
                        remindMs = event.getRemindBefore() * 60L * 60L * 1000L;
                        break;
                    case "days":
                        remindMs = event.getRemindBefore() * 24L * 60L * 60L * 1000L;
                        break;
                    case "weeks":
                        remindMs = event.getRemindBefore() * 7L * 24L * 60L * 60L * 1000L;
                        break;
                    default:
                        remindMs = 0;
                }

                long remindTime = event.getStartDate().getTime() - remindMs;
                // Cho phép nhắc trong vòng 1 phút quanh thời điểm chính xác (cửa sổ gửi)
                if (current >= remindTime && current < remindTime + 60 * 1000L) {
                    toRemind.add(event);
                }
            }
            return toRemind;
        } catch (Exception e) {
            // Log lỗi nhưng trả về list rỗng thay vì crash
            System.err.println("Error getting events to remind: " + e.getMessage());
            return new java.util.ArrayList<>();
        } finally {
            if (em != null && em.isOpen()) {
                try {
                    em.close();
                } catch (Exception e) {
                    // Ignore errors when closing EntityManager during shutdown
                }
            }
        }
    }
}
