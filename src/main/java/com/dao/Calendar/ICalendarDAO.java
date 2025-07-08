/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Calendar;

import com.model.Calendar;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface ICalendarDAO {
    
    // Thêm mới một Calendar
    public int insertCalendar(Calendar calendar);

    // Cập nhật Calendar
    public boolean updateCalendar(Calendar calendar);

    // Xoá theo ID
    public boolean deleteCalendar(int id);

    // Tìm theo ID
    public Calendar findById(int id);

    // Lấy tất cả các calendar
    public List<Calendar> selectAllCalendar();

    // Tìm lịch theo id_user
    public List<Calendar> selectCalendarByUserId(int userId);

    // Tìm lịch trong khoảng thời gian
    public List<Calendar> selectCalendarByDateRange(Date start, Date end);

    // Tìm lịch theo tên
    public List<Calendar> selectCalendarByName(String name);
}
