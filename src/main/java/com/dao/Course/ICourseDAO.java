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

    public int countCourse();

    public boolean insertCourse(Course course);

    public boolean updateCourse(Course course);

    public boolean deleteCourse(int id);

    public Course selectCourseById(int id);

    public List<Course> selectAllCourse();

    public List<Course> selectCourseByCategory(String category);

    public List<Course> selectCourseByPage(int pageNumber, int pageSize);

}
