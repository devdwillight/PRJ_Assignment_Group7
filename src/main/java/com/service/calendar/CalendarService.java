/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.calendar;

import com.dao.BaseDAO;
import com.dao.GenericDAO;
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
public class CalendarService implements ICalendarService{

    public GenericDAO<Calendar>calendarDao ;

    @Override
    public List<Calendar> findByUserId(int userId) {
        EntityManager em = calendarDao.getEntityManager();
        return em.createQuery(
                "SELECT c FROM Calendar c WHERE c.idUser.idUser = :userId", Calendar.class)
                .setParameter("userId", userId)
                .getResultList();

    }

    @Override
    public List<Calendar> findByDateRange(Date start, Date end) {
        EntityManager em = calendarDao.getEntityManager();
        return em.createQuery(
                "SELECT c FROM Calendar c WHERE c.startDate >= :start AND c.endDate <= :end", Calendar.class)
                .setParameter("start", start)
                .setParameter("end", end)
                .getResultList();

    }

    @Override
    public List<Calendar> findByName(String name) {
        EntityManager em = calendarDao.getEntityManager();
        return em.createQuery(
                "SELECT c FROM Calendar c WHERE LOWER(c.name) LIKE :name", Calendar.class)
                .setParameter("name", "%" + name.toLowerCase() + "%")
                .getResultList();
    }

    @Override
    public void create(Calendar calendar) {
        calendarDao.save(calendar);
    }

    @Override
    public boolean update(Calendar calendar) {
        return calendarDao.update(calendar);
    }

    @Override
    public boolean delete(int id) {
        return calendarDao.delete(id);
    }

    @Override
    public Calendar findById(int id) {
        return calendarDao.findById(id);
    }

    @Override
    public List<Calendar> findAll() {
        return calendarDao.findAll();
    }

}
