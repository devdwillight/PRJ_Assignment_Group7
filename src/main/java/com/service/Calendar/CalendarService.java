/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Calendar;

import com.dao.Calendar.CalendarDAO;
import com.model.Calendar;
import java.util.List;

public class CalendarService implements ICalendarService {

    private final CalendarDAO calendarDAO;

    public CalendarService() {
        this.calendarDAO = new CalendarDAO();
    }

    @Override
    public int countCalendar() {
        int count = calendarDAO.countCalendar();
        System.out.println("[countCalendar] Tổng số lịch: " + count);
        return count;
    }

    @Override
    public boolean updateCalendar(Calendar calendar) {
        System.out.println("[updateCalendar] Cập nhật lịch ID = " + calendar.getIdCalendar());
        boolean success = calendarDAO.updateCalendar(calendar);
        System.out.println("[updateCalendar] " + (success ? "✔ Thành công" : "✖ Thất bại"));
        return success;
    }

    @Override
    public boolean removeCalendar(int id) {
        System.out.println("[removeCalendar] Xoá lịch ID = " + id);
        boolean success = calendarDAO.deleteCalendar(id);
        System.out.println("[removeCalendar] " + (success ? "✔ Đã xoá" : "✖ Không tìm thấy"));
        return success;
    }

    @Override
    public Calendar createCalendar(Calendar calendar) {
        System.out.println("[createCalendar] Tạo lịch: " + calendar.getName());
        if (calendarDAO.insertCalendar(calendar)) {
            System.out.println("[createCalendar] ✔ Lịch đã được tạo với ID = " + calendar.getIdCalendar());
            return calendar;
        } else {
            System.out.println("[createCalendar] ✖ Tạo lịch thất bại");
            return null;
        }
    }

    @Override
    public Calendar getCalendarById(int id) {
        System.out.println("[getCalendarById] Lấy lịch ID = " + id);
        Calendar calendar = calendarDAO.selectCalendarById(id);
        if (calendar != null) {
            System.out.println("[getCalendarById] ✔ Tìm thấy lịch: " + calendar.getName());
        } else {
            System.out.println("[getCalendarById] ✖ Không tìm thấy lịch");
        }
        return calendar;
    }

    @Override
    public List<Calendar> getAllCalendar() {
        System.out.println("[getAllCalendar] Đang lấy tất cả lịch");
        List<Calendar> list = calendarDAO.selectAllCalendar();
        System.out.println("[getAllCalendar] ✔ Tổng cộng: " + list.size() + " lịch");
        return list;
    }

    @Override
    public List<Calendar> getAllCalendarByUserId(int userId) {
        System.out.println("[getCalendarByUserId] Lấy lịch theo người dùng ID = " + userId);

        List<Calendar> list = calendarDAO.selectAllCalendarByUserId(userId);

        System.out.println("[getCalendarByUserId] ✔ Tìm thấy: " + list.size() + " lịch");

        for (Calendar c : list) {
            System.out.println("⏺ Calendar ID: " + c.getIdCalendar()
                    + ", Name: " + c.getName()
                    + ", CreatedAt: " + c.getCreatedAt()
                    + ", Owner: " + (c.getIdUser() != null ? c.getIdUser().getIdUser() : "null"));
        }

        return list;
    }

    public static void main(String[] args) {
        CalendarService service = new CalendarService();
        service.removeCalendar(37);
    }

}
