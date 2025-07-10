/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.UserCourse;

import com.model.UserCourse;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface IUserCourseService {

    int countUserCourse();

    boolean updateUserCourse(UserCourse userCourse);

    boolean removeUserCourse(int id);

    UserCourse createUserCourse(UserCourse userCourse);

    UserCourse getUserCourseById(int id);

    List<UserCourse> getAllUserCourses();
}
