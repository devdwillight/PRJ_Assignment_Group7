/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Calendar;

import com.dao.BaseDAO;
import com.model.Calendar;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public class CalendarDAO extends BaseDAO<Calendar> implements ICalendarDAO {

    public CalendarDAO() {
        super(Calendar.class);
    }

    @Override
    public int insertCalendar(Calendar calendar) {
        save(calendar);
        return 1;
    }

    @Override
    public boolean deleteCalendar(int id) {
        delete(id);
        return true;
    }

    @Override
    public Calendar findById(int id) {
        return find(id);
    }

    @Override
    public List<Calendar> selectCalendarByUserId(int userId) {
        EntityManager em = getEntityManager();
        return em.createQuery(
                "SELECT c FROM Calendar c WHERE c.idUser.idUser = :userId", Calendar.class)
                .setParameter("userId", userId)
                .getResultList();

    }

    @Override
    public List<Calendar> selectCalendarByDateRange(Date start, Date end) {
        EntityManager em = getEntityManager();
        return em.createQuery(
                "SELECT c FROM Calendar c WHERE c.startDate >= :start AND c.endDate <= :end", Calendar.class)
                .setParameter("start", start)
                .setParameter("end", end)
                .getResultList();

    }

    @Override
    public List<Calendar> selectCalendarByName(String name) {
        EntityManager em = getEntityManager();
        return em.createQuery(
                "SELECT c FROM Calendar c WHERE LOWER(c.name) LIKE :name", Calendar.class)
                .setParameter("name", "%" + name.toLowerCase() + "%")
                .getResultList();
    }

    @Override
    public List<Calendar> selectAllCalendar() {
        return findAll();
    }

    @Override
    public boolean updateCalendar(Calendar calendar) {
        update(calendar);
        return true;
    }

}
