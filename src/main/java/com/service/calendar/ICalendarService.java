/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.calendar;

import com.model.Calendar;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface ICalendarService {
    // Thêm mới một Calendar

    void create(Calendar calendar);

    // Cập nhật Calendar
    boolean update(Calendar calendar);

    // Xoá theo ID
    boolean delete(int id);

    // Tìm theo ID
    Calendar findById(int id);

    // Lấy tất cả các calendar
    List<Calendar> findAll();

    // Tìm lịch theo id_user
    List<Calendar> findByUserId(int userId);

    // Tìm lịch trong khoảng thời gian
    List<Calendar> findByDateRange(Date start, Date end);

    // Tìm lịch theo tên
    List<Calendar> findByName(String name);
}
