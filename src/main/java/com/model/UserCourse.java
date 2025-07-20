/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

import jakarta.persistence.Entity;
import jakarta.persistence.*;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import java.time.LocalDateTime;

/**
 *
 * @author Admin
 */
@Entity
@Table(name = "User_Course", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"id_user", "id_course"})
})
public class UserCourse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_enroll")
    private int idEnroll;

    @ManyToOne
    @JoinColumn(name = "id_user", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "id_course", nullable = false)
    private Course course;

    @Column(name = "enroll_date", columnDefinition = "DATETIME DEFAULT GETDATE()")
    private LocalDateTime enrollDate;

    // Constructors
    public UserCourse() {}

    public UserCourse(User user, Course course, LocalDateTime enrollDate) {
        this.user = user;
        this.course = course;
        this.enrollDate = enrollDate;
    }

    // Getters & Setters
    public int getIdEnroll() {
        return idEnroll;
    }

    public void setIdEnroll(int idEnroll) {
        this.idEnroll = idEnroll;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public LocalDateTime getEnrollDate() {
        return enrollDate;
    }

    public void setEnrollDate(LocalDateTime enrollDate) {
        this.enrollDate = enrollDate;
    }
}
