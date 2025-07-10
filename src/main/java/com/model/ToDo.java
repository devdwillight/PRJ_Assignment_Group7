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
 * @author ADMIN
 */
@Entity
@Table(name = "To_Do")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "ToDo.findAll", query = "SELECT t FROM ToDo t"),
    @NamedQuery(name = "ToDo.findByIdTodo", query = "SELECT t FROM ToDo t WHERE t.idTodo = :idTodo"),
    @NamedQuery(name = "ToDo.findByTitle", query = "SELECT t FROM ToDo t WHERE t.title = :title"),
    @NamedQuery(name = "ToDo.findByDescription", query = "SELECT t FROM ToDo t WHERE t.description = :description"),
    @NamedQuery(name = "ToDo.findByDueDate", query = "SELECT t FROM ToDo t WHERE t.dueDate = :dueDate"),
    @NamedQuery(name = "ToDo.findByIsAllDay", query = "SELECT t FROM ToDo t WHERE t.isAllDay = :isAllDay"),
    @NamedQuery(name = "ToDo.findByIsRecurring", query = "SELECT t FROM ToDo t WHERE t.isRecurring = :isRecurring"),
    @NamedQuery(name = "ToDo.findByRecurrenceRule", query = "SELECT t FROM ToDo t WHERE t.recurrenceRule = :recurrenceRule"),
    @NamedQuery(name = "ToDo.findByIsCompleted", query = "SELECT t FROM ToDo t WHERE t.isCompleted = :isCompleted"),
    @NamedQuery(name = "ToDo.findByCreatedAt", query = "SELECT t FROM ToDo t WHERE t.createdAt = :createdAt"),
    @NamedQuery(name = "ToDo.findByUpdatedAt", query = "SELECT t FROM ToDo t WHERE t.updatedAt = :updatedAt")})
public class ToDo implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_todo")
    private Integer idTodo;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "title")
    private String title;
    @Size(max = 255)
    @Column(name = "description")
    private String description;
    @Basic(optional = false)
    @NotNull
    @Column(name = "due_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dueDate;
    @Column(name = "is_all_day")
    private Boolean isAllDay;
    @Column(name = "is_recurring")
    private Boolean isRecurring;
    @Size(max = 255)
    @Column(name = "recurrence_rule")
    private String recurrenceRule;
    @Column(name = "is_completed")
    private Boolean isCompleted;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "updated_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    @JoinColumn(name = "id_task", referencedColumnName = "id_task")
    @ManyToOne(optional = false)
    private Task idTask;

    public ToDo() {
    }

    public ToDo(Integer idTodo) {
        this.idTodo = idTodo;
    }

    public ToDo(Integer idTodo, String title, Date dueDate) {
        this.idTodo = idTodo;
        this.title = title;
        this.dueDate = dueDate;
    }

    public Integer getIdTodo() {
        return idTodo;
    }

    public void setIdTodo(Integer idTodo) {
        this.idTodo = idTodo;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
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

    public Boolean getIsCompleted() {
        return isCompleted;
    }

    public void setIsCompleted(Boolean isCompleted) {
        this.isCompleted = isCompleted;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Task getIdTask() {
        return idTask;
    }

    public void setIdTask(Task idTask) {
        this.idTask = idTask;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idTodo != null ? idTodo.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ToDo)) {
            return false;
        }
        ToDo other = (ToDo) object;
        if ((this.idTodo == null && other.idTodo != null) || (this.idTodo != null && !this.idTodo.equals(other.idTodo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.model.ToDo[ idTodo=" + idTodo + " ]";
    }
    
}
