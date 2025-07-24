package com.agent.model;

import com.model.UserEvents;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class TimeSlot {

    private final Date start;
    private final Date end;

    public TimeSlot(Date start, Date end) {
        this.start = start;
        this.end = end;
    }

    public boolean overlapsWith(UserEvents item) {
        return !(item.getDueDate().before(start) || item.getStartDate().after(end));
    }

    public String format() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE (dd/MM) HH:mm");
        return formatter.format(getStart()) + " → " + formatter.format(getEnd());
    }

    public LocalDateTime getStart() {
        return convertToLocalDateTime(start);
    }

    public LocalDateTime getEnd() {
        return convertToLocalDateTime(end);
    }

    private LocalDateTime convertToLocalDateTime(Date date) {
        return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
    }

    @Override
    public String toString() {
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

        LocalDateTime startTime = getStart();
        LocalDateTime endTime = getEnd();

        return String.format("%s từ %s đến %s",
                startTime.format(dateFormatter),
                startTime.format(timeFormatter),
                endTime.format(timeFormatter));
    }

}
