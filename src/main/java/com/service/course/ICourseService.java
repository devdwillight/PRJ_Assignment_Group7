/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.course;

import com.model.Course;
import java.util.List;

/**
 *
 * @author Admin
 */
public interface ICourseService {
    void create(Course course);

    boolean update(Course course);

    boolean delete(int id);

    List<Course> findAll();

    List<Course> findByName(String name);

    List<Course> findByCategory(String category);

    List<Course> findByUserId(int userId);
}
