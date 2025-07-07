/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.course;

import com.dao.GenericDAO;
import com.model.Course;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 *
 * @author Admin
 */
public class CourseService implements ICourseService {

    public GenericDAO<Course> courseDAO;

    public CourseService() {
        this.courseDAO = new GenericDAO<>(Course.class);
    }

    @Override
    public void create(Course course) {
        courseDAO.save(course);
    }

    @Override
    public boolean update(Course course) {
        return courseDAO.update(course);
    }

    @Override
    public boolean delete(int id) {
        return courseDAO.delete(id);
    }

    @Override
    public List<Course> findAll() {
        return courseDAO.findAll();
    }

    @Override
    public List<Course> findByName(String name) {
        EntityManager em = courseDAO.getEntityManager();
        try {
            TypedQuery<Course> query = em.createQuery(
                    "SELECT c FROM Course c WHERE c.name LIKE :name", Course.class);
            query.setParameter("name", "%" + name + "%"); // Tìm gần đúng
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Course> findByCategory(String category) {
        EntityManager em = courseDAO.getEntityManager();
        try {
            TypedQuery<Course> query = em.createQuery(
                    "SELECT c FROM Course c WHERE c.category = :category", Course.class);
            query.setParameter("category", category);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Course> findByUserId(int userId) {
        EntityManager em = courseDAO.getEntityManager();
        try {
            TypedQuery<Course> query = em.createQuery(
                    "SELECT c FROM Course c WHERE c.user.id = :userId", Course.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

}
