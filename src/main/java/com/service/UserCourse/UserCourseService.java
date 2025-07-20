/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.UserCourse;

import com.dao.User_Course.UserCourseDAO;
import com.model.UserCourse;
import com.model.Course;

/**
 *
 * @author DELL
 */
import java.util.List;

public class UserCourseService implements IUserCourseService {

    private final UserCourseDAO userCourseDAO;

    public UserCourseService() {
        this.userCourseDAO = new UserCourseDAO();
    }

    @Override
    public int countUserCourse() {
        int count = userCourseDAO.countUserCourse();
        System.out.printf("[Service] countUserCourse → %d\n", count);
        return count;
    }

    @Override
    public boolean updateUserCourse(UserCourse userCourse) {
        int courseId = (userCourse.getIdCourse() != null) ? userCourse.getIdCourse().getIdCourse() : -1;
        System.out.printf("[Service] updateUserCourse → ID: %d\n", courseId);
        boolean result = userCourseDAO.updateUserCourse(userCourse);
        System.out.printf("[Service] updateUserCourse result → %s\n", result ? "SUCCESS" : "FAIL");
        return result;
    }

    @Override
    public boolean removeUserCourse(int id) {
        System.out.printf("[Service] removeUserCourse → ID: %d\n", id);
        boolean result = userCourseDAO.deleteUserCourse(id);
        System.out.printf("[Service] removeUserCourse result → %s\n", result ? "SUCCESS" : "FAIL");
        return result;
    }

    @Override
    public UserCourse createUserCourse(UserCourse userCourse) {
        int userId = (userCourse.getIdUser() != null) ? userCourse.getIdUser().getIdUser() : -1;
        int courseId = (userCourse.getIdCourse() != null) ? userCourse.getIdCourse().getIdCourse() : -1;
        System.out.printf("[Service] createUserCourse → UserID: %d, CourseID: %d\n", userId, courseId);
        if (userCourseDAO.insertUserCourse(userCourse)) {
            System.out.println("Create Complete");
        }
        return userCourse;
    }

    @Override
    public UserCourse getUserCourseById(int id) {
        System.out.printf("[Service] getUserCourseById → ID: %d\n", id);
        UserCourse uc = userCourseDAO.selectUserCourse(id);
        System.out.printf("[Service] getUserCourseById result → %s\n", uc != null ? "FOUND" : "NOT FOUND");
        return uc;
    }

    @Override
    public List<UserCourse> getAllUserCourses() {
        System.out.println("[Service] getAllUserCourses");
        List<UserCourse> list = userCourseDAO.selectAllUserCourses();
        System.out.printf("[Service] getAllUserCourses → total: %d\n", list.size());
        return list;
    }

    @Override
    public List<UserCourse> getAllUserCoursesByCourseId(int id) {
        System.out.println("[Service] getAllUserCourses");
        List<UserCourse> list = userCourseDAO.selectAllUserCoursesByCourseId(id);
        System.out.printf("[Service] getAllUserCourses → total: %d\n", list.size());
        return list;
    }

    @Override
    public List<UserCourse> getAllUserCoursesByUserId(int id) {
        System.out.println("[Service] getAllUserCourses");
        List<UserCourse> list = userCourseDAO.selectAllUserCoursesByUserId(id);
        System.out.printf("[Service] getAllUserCourses → total: %d\n", list.size());
        return list;
    }

<<<<<<< HEAD
    @Override
    public boolean isUserEnrolled(int userId, int courseId) {
        boolean result = userCourseDAO.isUserEnrolled(userId, courseId);
        System.out.printf("[Service] isUserEnrolled → userId: %d, courseId: %d → %s\n",
                userId, courseId, result ? "ENROLLED" : "NOT ENROLLED");
        return result;
=======
    // Lấy danh sách Course đã đăng ký của user
    public List<Course> getCoursesByUserId(int userId) {
        return userCourseDAO.getCoursesByUserId(userId);
>>>>>>> fba18bb (update admin)
    }
}
