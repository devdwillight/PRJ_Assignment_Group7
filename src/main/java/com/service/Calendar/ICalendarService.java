/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Calendar;

import com.model.Calendar;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface ICalendarService {

    int countCalendar();

    boolean updateCalendar(Calendar calendar);

    boolean removeCalendar(int id);

    Calendar createCalendar(Calendar calendar);

    Calendar getCalendarById(int id);

    List<Calendar> getAllCalendar();

    List<Calendar> getCalendarByUserId(int userid);

}
