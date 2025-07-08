/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Course;

import com.dao.BaseDAO;
import com.model.Course;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.util.List;

/**
 *
 * @author DELL
 */
public class CourseDAO extends BaseDAO<Course> implements ICourseDAO {

    public CourseDAO() {
        super(Course.class);
    }

    @Override
    public int countCourse() {
        return (int) count();
    }

    @Override
    public boolean insertCourse(Course course) {
        return save(course);
    }

    @Override
    public boolean updateCourse(Course course) {
        return update(course);
    }

    @Override
    public boolean deleteCourse(int id) {
        return delete(id);
    }

    @Override
    public Course selectCourseById(int id) {
        return find(id);
    }

    @Override
    public List<Course> selectAllCourse() {
        return findAllByEntity("Course.findAll");
    }

    @Override
    public List<Course> selectCourseByCategory(String category) {
        return findAllByNamedEntity("Course.findByCategory", "category", category);
    }

    @Override
    public List<Course> selectCourseByPage(int pageNumber, int pageSize) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT c FROM Course c ORDER BY c.idCourse", Course.class)
                    .setFirstResult((pageNumber - 1) * pageSize)
                    .setMaxResults(pageSize)
                    .getResultList();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

}
