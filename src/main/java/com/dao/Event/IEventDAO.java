/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Event;

import com.model.UserEvents;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface IEventDAO {

    public int countEvent();

    public boolean insertEvent(UserEvents event);

    public boolean updateEvent(UserEvents event);

    public boolean deleteEvent(int id);

    public UserEvents selectEventById(int id);

    public List<UserEvents> selectAllEvent();

    public List<UserEvents> selectAllEventByCalendarId(int id);

    public List<UserEvents> selectAllEventsByUserId(int userId);

    public boolean updateEventTime(int eventId, Date start, Date end, boolean allDay);
    public List<UserEvents> getEventsToRemind();
    public int countEventsByMonth(int year, int month);
    public boolean deleteByTitle(String title);
    public List<UserEvents> findEventsBetween(Timestamp start, Timestamp end);
public List<UserEvents> findEventsBetweenUserID(Timestamp start, Timestamp end,int userId); 
}
