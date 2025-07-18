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
}
