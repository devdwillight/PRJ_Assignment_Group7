/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Calendar;

import com.model.Calendar;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface ICalendarDAO {

    public int countCalendar();

    public boolean insertCalendar(Calendar calendar);

    public boolean updateCalendar(Calendar calendar);

    public boolean deleteCalendar(int id);

    public Calendar selectCalendarById(int id);

    public List<Calendar> selectAllCalendar();

    public List<Calendar> selectAllCalendarByUserId(int userId);

    public int countCalendarsByMonth(int year, int month);
    
    
}
