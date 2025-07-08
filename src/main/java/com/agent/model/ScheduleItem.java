/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.model;

import java.time.LocalDateTime;

/**
 *
 * @author Admin
 */
public class ScheduleItem {
     private String title;
    private LocalDateTime start;
    private LocalDateTime end;
    private String time; // Optional string-based time input from user or LLM
    private String priority; // Priority level
    private ScheduleType scheduleType; // Type of schedule

    public enum ScheduleType {
        STUDY("Học tập"),
        WORK("Công việc"),
        EVENT("Sự kiện"),
        TRAVEL("Du lịch"),
        PERSONAL("Cá nhân");

        private final String displayName;

        ScheduleType(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    public ScheduleItem(String title, LocalDateTime start, LocalDateTime end) {
        this.title = title;
        this.start = start;
        this.end = end;
        this.priority = "MEDIUM"; // Default priority
        this.scheduleType = ScheduleType.PERSONAL; // Default type
    }

    public ScheduleItem(String title, LocalDateTime start, LocalDateTime end, String time) {
        this.title = title;
        this.start = start;
        this.end = end;
        this.time = time;
        this.priority = "MEDIUM";
        this.scheduleType = ScheduleType.PERSONAL;
    }

    // Getters and Setters
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public LocalDateTime getStartTime() {
        return start;
    }

    public void setStartTime(LocalDateTime start) {
        this.start = start;
    }

    public LocalDateTime getEndTime() {
        return end;
    }

    public void setEndTime(LocalDateTime end) {
        this.end = end;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public ScheduleType getScheduleType() {
        return scheduleType;
    }

    public void setScheduleType(ScheduleType scheduleType) {
        this.scheduleType = scheduleType;
    }

    @Override
    public String toString() {
        return "ScheduleItem{" +
                "title='" + title + '\'' +
                ", start=" + start +
                ", end=" + end +
                (time != null ? ", time='" + time + '\'' : "") +
                ", priority='" + priority + '\'' +
                ", type='" + scheduleType.getDisplayName() + '\'' +
                '}';
    }
}
