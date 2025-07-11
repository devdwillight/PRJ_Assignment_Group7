/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.User_Course;

import com.model.UserCourse;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface IUserCourseDAO {

    public int countUserCourse();

    public boolean insertUserCourse(UserCourse userCourse);

    public boolean updateUserCourse(UserCourse userCourse);

    public boolean deleteUserCourse(int id);

    public UserCourse selectUserCourse(int id);

    public List<UserCourse> selectAllUserCourses();

    public List<UserCourse> selectAllUserCoursesByUserId(int id);
    
    public List<UserCourse> selectAllUserCoursesByCourseId(int id);
}
