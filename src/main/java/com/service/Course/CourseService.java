/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Course;

import com.dao.Course.CourseDAO;
import com.model.Course;
import java.util.List;

/**
 *
 * @author DELL
 */
public class CourseService implements ICourseService {

    private final CourseDAO courseDAO;

    public CourseService() {
        this.courseDAO = new CourseDAO();
    }

    @Override
    public int countCourses() {
        int count = courseDAO.countCourse();
        System.out.println("[countCourses] Tổng số khóa học: " + count);
        return count;
    }

    @Override
    public boolean updateCourse(Course course) {
        System.out.println("[updateCourse] Cập nhật khóa học ID = " + course.getIdCourse());
        boolean success = courseDAO.updateCourse(course);
        System.out.println("[updateCourse] " + (success ? "✔ Thành công" : "✖ Thất bại"));
        return success;
    }

    @Override
    public boolean removeCourse(int id) {
        System.out.println("[removeCourse] Xoá khóa học ID = " + id);
        boolean success = courseDAO.deleteCourse(id);
        System.out.println("[removeCourse] " + (success ? "✔ Đã xoá" : "✖ Không tìm thấy"));
        return success;
    }

    @Override
    public Course addCourse(Course course) {
        System.out.println("[addCourse] Thêm khóa học: " + course.getName());
        if (courseDAO.insertCourse(course)) {
            System.out.println("[addCourse] ✔ Đã thêm với ID = " + course.getIdCourse());
            return course;
        } else {
            System.out.println("[addCourse] ✖ Thêm khóa học thất bại");
            return null;
        }
    }

    @Override
    public Course getCourseById(int id) {
        System.out.println("[getCourseById] Lấy khóa học theo ID = " + id);
        Course course = courseDAO.selectCourseById(id);
        if (course != null) {
            System.out.println("[getCourseById] ✔ Tìm thấy: " + course.getName());
        } else {
            System.out.println("[getCourseById] ✖ Không tìm thấy khóa học");
        }
        return course;
    }

    @Override
    public List<Course> getAllCourses() {
        System.out.println("[getAllCourses] Lấy tất cả khóa học");
        List<Course> list = courseDAO.selectAllCourse();
        System.out.println("[getAllCourses] ✔ Tổng: " + list.size() + " khóa học");
        return list;
    }

    @Override
    public List<Course> getCoursesByCategory(String category) {
        System.out.println("[getCoursesByCategory] Lấy khóa học theo danh mục: " + category);
        List<Course> list = courseDAO.selectCourseByCategory(category);
        System.out.println("[getCoursesByCategory] ✔ Tổng: " + list.size() + " khóa học");
        return list;
    }

    @Override
    public List<Course> selectCourseByPage(int pageNumber, int pageSize) {
        System.out.println("[selectCourseByPage] Trang = " + pageNumber + ", kích thước = " + pageSize);
        List<Course> list = courseDAO.selectCourseByPage(pageNumber, pageSize);
        System.out.println("[selectCourseByPage] ✔ Trả về: " + list.size() + " khóa học");
        return list;
    }

    public static void main(String[] args) {
        CourseService courseService = new CourseService();

        System.out.println("====== DANH SÁCH KHÓA HỌC ======");
        List<Course> courses = courseService.getAllCourses();

        if (courses.isEmpty()) {
            System.out.println("Không có khóa học nào trong hệ thống.");
        } else {
            for (Course course : courses) {
                System.out.println("ID       : " + course.getIdCourse());
                System.out.println("Tên      : " + course.getName());
                System.out.println("Mô tả    : " + course.getDescription());
                System.out.println("Danh mục : " + course.getCategory());
                System.out.println("Giá      : " + course.getPrice());
                System.out.println("Ngày tạo : " + course.getCreatedAt());
                System.out.println("-------------------------------");
            }
            System.out.println("Tổng số khóa học: " + courses.size());
        }
    }

}
