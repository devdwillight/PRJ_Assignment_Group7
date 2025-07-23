/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Event;

import com.agent.model.TimeSlot;
import com.agent.qdrant.model.TimeContext;
import com.model.Calendar;
import com.model.UserEvents;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author Admin
 */
public class TimeSlotUnit {

    public static List<TimeSlot> findFreeTime(List<UserEvents> events) {
        // Giả sử tuần làm việc từ 8h-22h, chia slot 2 tiếng
        List<TimeSlot> allPossibleSlots = generateWeekSlots();

        // Duyệt và loại bỏ các slot đã bị chiếm
        for (UserEvents event : events) {
            allPossibleSlots.removeIf(slot -> slot.overlapsWith(event));
        }

        return allPossibleSlots;
    }

    private static List<TimeSlot> generateWeekSlots() {
        List<TimeSlot> slots = new ArrayList<>();
        LocalDate today = LocalDate.now();

        for (int i = 0; i < 7; i++) {
            LocalDate date = today.plusDays(i);
            for (int hour = 8; hour <= 22; hour += 2) {
                LocalDateTime start = date.atTime(hour, 0);
                LocalDateTime end = start.plusHours(2);
                slots.add(new TimeSlot(convertToDate(start), convertToDate(end)));
            }
        }
        return slots;
    }

    public static Date convertToDate(LocalDateTime localDateTime) {
        return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
    }

    public static TimeContext extracTimeContext(String userInput) {
        String lower = userInput.toLowerCase();
        if (lower.contains("hôm nay")) {
            return TimeContext.TODAY;
        }
        if (lower.contains("ngày mai")) {
            return TimeContext.TOMORROW;
        }
        if (lower.contains("tuần này")) {
            return TimeContext.THIS_WEEK;
        }
        if (lower.contains("tuần sau") || lower.contains("tuần tới")) {
            return TimeContext.NEXT_WEEK;
        }
        if (lower.contains("tháng này")) {
            return TimeContext.THIS_MONTH;
        }

        return TimeContext.UNKNOWN;

    }

    public static List<UserEvents> filterEventsToday(List<UserEvents> events) {
        LocalDate today = LocalDate.now();
        return events.stream()
                .filter(e -> e.getStartDate()
                .toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate()
                .isEqual(today))
                .collect(Collectors.toList());
    }

    public static List<UserEvents> filterEventsTomorrow(List<UserEvents> events) {
        LocalDate tomorrow = LocalDate.now().plusDays(1);
        return events.stream()
                .filter(e -> e.getStartDate()
                .toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate()
                .isEqual(tomorrow))
                .collect(Collectors.toList());
    }

    public static List<UserEvents> filterEventsThisWeek(List<UserEvents> events) {
        LocalDate today = LocalDate.now();
        LocalDate startOfWeek = today.with(DayOfWeek.MONDAY);
        LocalDate endOfWeek = today.with(DayOfWeek.SUNDAY);

        return events.stream()
                .filter(e -> {
                    LocalDate date = e.getStartDate()
                            .toInstant()
                            .atZone(ZoneId.systemDefault())
                            .toLocalDate();
                    return (date.isEqual(startOfWeek) || date.isAfter(startOfWeek))
                            && (date.isEqual(endOfWeek) || date.isBefore(endOfWeek));
                })
                .collect(Collectors.toList());
    }

    public static List<UserEvents> filterEventsNextWeek(List<UserEvents> events) {
        LocalDate today = LocalDate.now();
        LocalDate startOfNextWeek = today.with(DayOfWeek.MONDAY).plusWeeks(1);
        LocalDate endOfNextWeek = startOfNextWeek.plusDays(6);

        return events.stream()
                .filter(e -> {
                    LocalDate date = e.getStartDate()
                            .toInstant()
                            .atZone(ZoneId.systemDefault())
                            .toLocalDate();
                    return !date.isBefore(startOfNextWeek) && !date.isAfter(endOfNextWeek);
                })
                .collect(Collectors.toList());
    }
}
