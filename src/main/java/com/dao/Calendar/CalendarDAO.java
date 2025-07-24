/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Calendar;

import com.dao.BaseDAO;
import com.model.Calendar;
import com.model.User;
import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

/**
 *
 * @author DELL
 */
public class CalendarDAO extends BaseDAO<Calendar> implements ICalendarDAO {

    public CalendarDAO() {
        super(Calendar.class);
    }

    @Override
    public int countCalendar() {
        return (int) count();
    }

    @Override
    public boolean insertCalendar(Calendar calendar) {
        return save(calendar);
    }

    @Override
    public boolean deleteCalendar(int id) {
        return delete(id);
    }

    @Override
    public boolean updateCalendar(Calendar calendar) {
        return update(calendar);
    }

    @Override
    public Calendar selectCalendarById(int id) {
        return find(id);
    }

    @Override
    public List<Calendar> selectAllCalendarByUserId(int userId) {
        return findAllById("idUser", userId);
    }

    @Override
    public List<Calendar> selectAllCalendar() {
        return findAllByEntity("Calendar.findAll");
    }

    @Override
    public int countCalendarsByMonth(int year, int month) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT COUNT(c) FROM Calendar c WHERE YEAR(c.createdAt) = :year AND MONTH(c.createdAt) = :month";
            jakarta.persistence.Query query = em.createQuery(jpql);
            query.setParameter("year", year);
            query.setParameter("month", month);
            return ((Long) query.getSingleResult()).intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    public Calendar getOrCreatePersonalCalendarByUserId(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Calendar> query = em.createQuery(
                    "SELECT c FROM Calendar c WHERE c.idUser.id = :userId AND c.name = :name", Calendar.class);
            query.setParameter("userId", userId);
            query.setParameter("name", "Personal Events");

            List<Calendar> results = query.getResultList();
            if (!results.isEmpty()) {
                return results.get(0); // đã có
            }

            // Chưa có -> tạo mới
            em.getTransaction().begin();

            Calendar newCalendar = new Calendar();
            newCalendar.setName("Personal Events");
            newCalendar.setColor("#3b82f6"); // blue mặc định
            LocalDateTime now = LocalDateTime.now();
            Date createdDate = Date.from(now.atZone(ZoneId.systemDefault()).toInstant());
            newCalendar.setCreatedAt(createdDate);

            // set user
            User user = em.find(User.class, userId);
            newCalendar.setIdUser(user);

            em.persist(newCalendar);
            em.getTransaction().commit();

            return newCalendar;
        } catch (Exception e) {
            e.printStackTrace();
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return null;
        } finally {
            em.close();
        }
    }


}
