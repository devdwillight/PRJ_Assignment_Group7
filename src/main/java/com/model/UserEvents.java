/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author DELL
 */
@Entity
@Table(name = "UserEvents")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "UserEvents.findAll", query = "SELECT u FROM UserEvents u"),
    @NamedQuery(name = "UserEvents.findByIdEvent", query = "SELECT u FROM UserEvents u WHERE u.idEvent = :idEvent"),
    @NamedQuery(name = "UserEvents.findByName", query = "SELECT u FROM UserEvents u WHERE u.name = :name"),
    @NamedQuery(name = "UserEvents.findByStartDate", query = "SELECT u FROM UserEvents u WHERE u.startDate = :startDate"),
    @NamedQuery(name = "UserEvents.findByDueDate", query = "SELECT u FROM UserEvents u WHERE u.dueDate = :dueDate"),
    @NamedQuery(name = "UserEvents.findByDescription", query = "SELECT u FROM UserEvents u WHERE u.description = :description"),
    @NamedQuery(name = "UserEvents.findByLocation", query = "SELECT u FROM UserEvents u WHERE u.location = :location"),
    @NamedQuery(name = "UserEvents.findByIsAllDay", query = "SELECT u FROM UserEvents u WHERE u.isAllDay = :isAllDay"),
    @NamedQuery(name = "UserEvents.findByIsRecurring", query = "SELECT u FROM UserEvents u WHERE u.isRecurring = :isRecurring"),
    @NamedQuery(name = "UserEvents.findByRecurrenceRule", query = "SELECT u FROM UserEvents u WHERE u.recurrenceRule = :recurrenceRule"),
    @NamedQuery(name = "UserEvents.findByColor", query = "SELECT u FROM UserEvents u WHERE u.color = :color"),
    @NamedQuery(name = "UserEvents.findByRemindMethod", query = "SELECT u FROM UserEvents u WHERE u.remindMethod = :remindMethod"),
    @NamedQuery(name = "UserEvents.findByRemindBefore", query = "SELECT u FROM UserEvents u WHERE u.remindBefore = :remindBefore"),
    @NamedQuery(name = "UserEvents.findByRemindUnit", query = "SELECT u FROM UserEvents u WHERE u.remindUnit = :remindUnit"),
    @NamedQuery(name = "UserEvents.findByUpdatedAt", query = "SELECT u FROM UserEvents u WHERE u.updatedAt = :updatedAt"),
    @NamedQuery(name = "UserEvents.findByCreatedAt", query = "SELECT u FROM UserEvents u WHERE u.createdAt = :createdAt")})
public class UserEvents implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_event")
    private Integer idEvent;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "name")
    private String name;
    @Column(name = "Start_Date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date startDate;
    @Column(name = "Due_Date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dueDate;
    @Size(max = 2147483647)
    @Column(name = "description")
    private String description;
    @Size(max = 255)
    @Column(name = "location")
    private String location;
    @Column(name = "is_all_day")
    private Boolean isAllDay;
    @Column(name = "is_recurring")
    private Boolean isRecurring;
    @Size(max = 255)
    @Column(name = "recurrence_rule")
    private String recurrenceRule;
    @Size(max = 50)
    @Column(name = "color")
    private String color;
    @Column(name = "remind_method")
    private Boolean remindMethod;
    @Column(name = "remind_before")
    private Integer remindBefore;
    @Size(max = 10)
    @Column(name = "remind_unit")
    private String remindUnit;
    @Column(name = "updated_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @JoinColumn(name = "id_calendar", referencedColumnName = "id_calendar")
    @ManyToOne(optional = false)
    private Calendar_1 idCalendar;

    public UserEvents() {
    }

    public UserEvents(Integer idEvent) {
        this.idEvent = idEvent;
    }

    public UserEvents(Integer idEvent, String name) {
        this.idEvent = idEvent;
        this.name = name;
    }

    public Integer getIdEvent() {
        return idEvent;
    }

    public void setIdEvent(Integer idEvent) {
        this.idEvent = idEvent;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Boolean getIsAllDay() {
        return isAllDay;
    }

    public void setIsAllDay(Boolean isAllDay) {
        this.isAllDay = isAllDay;
    }

    public Boolean getIsRecurring() {
        return isRecurring;
    }

    public void setIsRecurring(Boolean isRecurring) {
        this.isRecurring = isRecurring;
    }

    public String getRecurrenceRule() {
        return recurrenceRule;
    }

    public void setRecurrenceRule(String recurrenceRule) {
        this.recurrenceRule = recurrenceRule;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Boolean getRemindMethod() {
        return remindMethod;
    }

    public void setRemindMethod(Boolean remindMethod) {
        this.remindMethod = remindMethod;
    }

    public Integer getRemindBefore() {
        return remindBefore;
    }

    public void setRemindBefore(Integer remindBefore) {
        this.remindBefore = remindBefore;
    }

    public String getRemindUnit() {
        return remindUnit;
    }

    public void setRemindUnit(String remindUnit) {
        this.remindUnit = remindUnit;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Calendar_1 getIdCalendar() {
        return idCalendar;
    }

    public void setIdCalendar(Calendar_1 idCalendar) {
        this.idCalendar = idCalendar;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idEvent != null ? idEvent.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserEvents)) {
            return false;
        }
        UserEvents other = (UserEvents) object;
        if ((this.idEvent == null && other.idEvent != null) || (this.idEvent != null && !this.idEvent.equals(other.idEvent))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.model.UserEvents[ idEvent=" + idEvent + " ]";
    }
    
}
