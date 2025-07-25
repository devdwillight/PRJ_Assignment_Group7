/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Course;

import com.model.Course;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface ICourseService {

    int countCourses();

    boolean updateCourse(Course course);

    boolean removeCourse(int id);

    Course addCourse(Course course);

    Course getCourseById(int id);

    List<Course> getAllCourses();

    List<Course> getCoursesByCategory(String category);

    List<Course> selectCourseByPage(int pageNumber, int pageSize);

    int countCoursesByMonth(int year, int month);
    
    List<Course> searchCourses(String name, String category, String price);
    
    List<Course> searchCoursesWithPagination(String name, String category, String price, int pageNumber, int pageSize);
    
    int countSearchResults(String name, String category, String price);

}
