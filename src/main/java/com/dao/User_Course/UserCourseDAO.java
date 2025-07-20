/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.User_Course;

import com.dao.BaseDAO;
import com.model.UserCourse;
import jakarta.persistence.EntityManager;
import com.model.Course;
import com.dao.Course.CourseDAO;
import java.util.List;
import java.util.ArrayList;

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
        return findAllById("idUser", id);
    }

    @Override
    public List<UserCourse> selectAllUserCoursesByCourseId(int id) {
        return findAllById("idCourse", id);
    }

    @Override
    public boolean isUserEnrolled(int userId, int courseId) {
        EntityManager em = getEntityManager();
        String jpql = "SELECT COUNT(uc) FROM UserCourse uc WHERE uc.idUser.idUser = :userId AND uc.idCourse.idCourse = :courseId";
        Long count = em.createQuery(jpql, Long.class)
                .setParameter("userId", userId)
                .setParameter("courseId", courseId)
                .getSingleResult();
        return count != null && count > 0;
    }
    // Lấy danh sách Course đã đăng ký của user
    public List<Course> getCoursesByUserId(int userId) {
        List<Course> courses = new ArrayList<>();
        List<UserCourse> userCourses = selectAllUserCoursesByUserId(userId);
        CourseDAO courseDAO = new CourseDAO();
        for (UserCourse uc : userCourses) {
            if (uc.getIdCourse() != null) {
                Course course = courseDAO.selectCourseById(uc.getIdCourse().getIdCourse());
                if (course != null) {
                    courses.add(course);
                }
            }
        }
        return courses;
    }
}
