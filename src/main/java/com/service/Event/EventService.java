/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Event;

import com.dao.Event.EventDAO;
import com.model.UserEvents;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
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
        System.out.println("[createEvent] Tạo sự kiện: " + event.getName());
        boolean success = eventDAO.insertEvent(event);
        if (success) {
            System.out.println("[createEvent] ✔ Thành công với ID = " + event.getIdEvent());
            return event; // JPA automatically updates the ID after persist
        } else {
            System.out.println("[createEvent] ✖ Thất bại");
            return null;
        }

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

    @Override
    public int countEventsByMonth(int year, int month) {
        int count = eventDAO.countEventsByMonth(year, month);
        System.out.println("[countEventsByMonth] Tháng " + month + "/" + year + ": " + count + " sự kiện");
        return count;
    }

    @Override
    public boolean updateEventTime(int eventId, Date start, Date end, boolean allDay) {
        System.out.println("[updateEventTime] Cập nhật thời gian sự kiện ID = " + eventId);
        boolean success = eventDAO.updateEventTime(eventId, start, end, allDay);
        System.out.println("[updateEventTime] " + (success ? "✔ Thành công" : "✖ Thất bại"));
        return success;
    }

    /**
     * Kiểm tra có event nào trong calendar bị trùng thời gian không
     *
     * @param calendarId id của calendar
     * @param newStart thời gian bắt đầu event mới
     * @param newEnd thời gian kết thúc event mới
     * @return true nếu có event trùng, false nếu không
     */
    public boolean isEventConflict(int calendarId, Date newStart, Date newEnd) {
        List<UserEvents> events = getAllEventsByCalendarId(calendarId);
        for (UserEvents e : events) {
            if (!(newEnd.before(e.getStartDate()) || newStart.after(e.getDueDate()))) {
                // Có giao nhau
                return true;
            }
        }
        return false;
    }

    public UserEvents getFirstEventByTitle(String title) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("CLDPU");
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<UserEvents> query = em.createQuery(
                    "SELECT e FROM UserEvents e WHERE e.name = :title", UserEvents.class);
            query.setParameter("title", title);
            List<UserEvents> results = query.setMaxResults(1).getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }

    public List<UserEvents> isTimeConflict(LocalDateTime start, LocalDateTime end, int userId) {
        List<UserEvents> all = getAllEventsByUserId(userId); // hoặc query theo user/session
        List<UserEvents> conflicted = new ArrayList<>();
        for (UserEvents e : all) {
            Date startDate = e.getStartDate();
            Date dueDate = e.getDueDate();

            LocalDateTime existingStart = startDate.toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDateTime();

            LocalDateTime existingEnd = dueDate.toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDateTime();

            if (start.isBefore(existingEnd) && end.isAfter(existingStart)) {
                conflicted.add(e);
            }
        }
        return conflicted;
    }

    public List<UserEvents> getEventsBetween(LocalDateTime start, LocalDateTime end, int userId) {
        Timestamp startTs = Timestamp.valueOf(start);
        Timestamp endTs = Timestamp.valueOf(end);
        return eventDAO.findEventsBetweenUserID(startTs, endTs, userId);
    }

    @Override
    public boolean deleteByTitle(String title) {
        return eventDAO.deleteByTitle(title);
    }

    public static void main(String[] args) {
        EventService service = new EventService();

        int userIdToTest = 1; // thay bằng ID user bạn muốn test
        List<UserEvents> events = service.getAllEventsByUserId(userIdToTest);

        System.out.println("Danh sách sự kiện của người dùng có ID = " + userIdToTest + ":");
        System.out.println(events);
    }

}
