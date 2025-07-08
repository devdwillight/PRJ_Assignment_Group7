/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Course;

import com.model.Course;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface ICourseDAO {

    void create(Course course);

    void update(Course course);

    void delete(int id);

    List<Course> selectAllCourse();

    List<Course> findByName(String name);

    List<Course> findByCategory(String category);

    List<Course> findByUserId(int userId);
}
