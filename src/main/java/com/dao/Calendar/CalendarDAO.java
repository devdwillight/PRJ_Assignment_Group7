/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Calendar;

import com.dao.BaseDAO;
import com.model.Calendar;
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

}
