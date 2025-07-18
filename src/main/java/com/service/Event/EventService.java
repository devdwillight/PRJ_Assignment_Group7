/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Event;

import com.dao.Event.EventDAO;
import com.model.UserEvents;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public class EventService implements IEventService {

    private final EventDAO eventDAO;

    public EventService() {
        this.eventDAO = new EventDAO();
    }

    @Override
    public int countEvent() {
        int count = eventDAO.countEvent();
        System.out.println("[countEvent] Tổng số sự kiện: " + count);
        return count;
    }

    @Override
    public boolean updateEvent(UserEvents event) {
        System.out.println("[updateEvent] Cập nhật sự kiện ID = " + event.getIdEvent());
        boolean success = eventDAO.updateEvent(event);
        System.out.println("[updateEvent] " + (success ? "✔ Thành công" : "✖ Thất bại"));
        return success;
    }

    @Override
    public boolean removeEvent(int id) {
        System.out.println("[removeEvent] Xoá sự kiện ID = " + id);
        boolean success = eventDAO.deleteEvent(id);
        System.out.println("[removeEvent] " + (success ? "✔ Đã xoá" : "✖ Không tìm thấy"));
        return success;
    }

    @Override
    public UserEvents getEventById(int id) {
        System.out.println("[getEventById] Lấy sự kiện theo ID = " + id);
        UserEvents event = eventDAO.selectEventById(id);
        if (event != null) {
            System.out.println("[getEventById] ✔ Tìm thấy sự kiện: " + event.getName());
        } else {
            System.out.println("[getEventById] ✖ Không tìm thấy sự kiện");
        }
        return event;
    }

    @Override
    public List<UserEvents> getAllEvent() {
        System.out.println("[getAllEvent] Lấy tất cả sự kiện");
        List<UserEvents> list = eventDAO.selectAllEvent();
        System.out.println("[getAllEvent] ✔ Tổng: " + list.size() + " sự kiện");
        return list;
    }

    @Override
    public UserEvents createEvent(UserEvents event) {
        System.out.println("[createEvent] tạo sự kiện ID = " + event.getIdEvent());
        boolean success = eventDAO.insertEvent(event);
        if (success) {
            System.out.println("[createEvent] " + (success ? "✔ Thành công" : "✖ Thất bại"));
        }
        return event;
    }

    @Override
    public List<UserEvents> getAllEventsByCalendarId(int id) {
        return eventDAO.selectAllEventByCalendarId(id);
    }

    @Override
    public List<UserEvents> getAllEventsByUserId(int userId) {
        System.out.println("[getAllEventsByUserId] Lấy tất cả events của user ID = " + userId);
        List<UserEvents> events = eventDAO.selectAllEventsByUserId(userId);
        System.out.println("[getAllEventsByUserId] ✔ Tìm thấy: " + events.size() + " events");

        for (UserEvents event : events) {
            System.out.println("⏺ Event: " + event.getName()
                    + " | Calendar: " + (event.getIdCalendar() != null ? event.getIdCalendar().getName() : "N/A")
                    + " | Start: " + event.getStartDate()
                    + "|Recurrent Rule " + event.getRecurrenceRule());
        }

        return events;
    }

    public static void main(String[] args) {
        EventService service = new EventService();

        int userIdToTest = 1; // thay bằng ID user bạn muốn test
        List<UserEvents> events = service.getAllEventsByUserId(userIdToTest);

        System.out.println("Danh sách sự kiện của người dùng có ID = " + userIdToTest + ":");
        System.out.println(events);
    }

    @Override
    public boolean updateEventTime(int eventId, Date start, Date end, boolean allDay) {
        System.out.println("[updateEventTime] Cập nhật thời gian sự kiện ID = " + eventId);
        boolean success = eventDAO.updateEventTime(eventId, start, end, allDay);
        System.out.println("[updateEventTime] " + (success ? "✔ Thành công" : "✖ Thất bại"));
        return success;
    }
}
