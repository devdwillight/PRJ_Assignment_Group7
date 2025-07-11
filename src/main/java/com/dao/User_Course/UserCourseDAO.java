/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.User_Course;

import com.dao.BaseDAO;
import com.model.UserCourse;
import java.util.List;

/**
 *
 * @author DELL
 */
public class UserCourseDAO extends BaseDAO<UserCourse> implements IUserCourseDAO {

    public UserCourseDAO() {
        super(UserCourse.class);
    }

    @Override
    public int countUserCourse() {
        return (int) count();
    }

    @Override
    public boolean insertUserCourse(UserCourse userCourse) {
        return save(userCourse);
    }

    @Override
    public boolean updateUserCourse(UserCourse userCourse) {
        return update(userCourse);
    }

    @Override
    public boolean deleteUserCourse(int id) {
        return delete(id);
    }

    @Override
    public UserCourse selectUserCourse(int id) {
        return find(id);
    }

    @Override
    public List<UserCourse> selectAllUserCourses() {
        return findAllByEntity("UserCourse.findAll");
    }

    @Override
    public List<UserCourse> selectAllUserCoursesByUserId(int id) {
        return findAllById("userId", id);
    }

    @Override
    public List<UserCourse> selectAllUserCoursesByCourseId(int id) {
        return findAllById("idCourse", id);
    }

}
