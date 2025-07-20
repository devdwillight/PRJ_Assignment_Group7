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

    @Override
    public List<String> getAllCategoryNames() {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT c.category FROM Course c";
            return em.createQuery(jpql, String.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Course> filterCourses(String search, String sort, String[] categories) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT c FROM Course c WHERE 1=1");
            if (search != null && !search.trim().isEmpty()) {
                jpql.append(" AND LOWER(c.name) LIKE :search");
            }
            if (categories != null && categories.length > 0) {
                jpql.append(" AND c.category IN :categories");
            }

            // Sắp xếp
            if ("name-asc".equals(sort)) {
                jpql.append(" ORDER BY c.name ASC");
            } else if ("name-desc".equals(sort)) {
                jpql.append(" ORDER BY c.name DESC");
            } else if ("price-asc".equals(sort)) {
                jpql.append(" ORDER BY c.price ASC");
            } else if ("price-desc".equals(sort)) {
                jpql.append(" ORDER BY c.price DESC");
            } else if ("newest".equals(sort)) {
                jpql.append(" ORDER BY c.idCourse DESC"); // hoặc c.createTime nếu có
            }
            var query = em.createQuery(jpql.toString(), Course.class);
            if (search != null && !search.trim().isEmpty()) {
                query.setParameter("search", "%" + search.trim().toLowerCase() + "%");
            }
            if (categories != null && categories.length > 0) {
                query.setParameter("categories", java.util.Arrays.asList(categories));
            }
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public int countCoursesByMonth(int year, int month) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT COUNT(c) FROM Course c WHERE YEAR(c.createdAt) = :year AND MONTH(c.createdAt) = :month";
            jakarta.persistence.Query query = em.createQuery(jpql);
            query.setParameter("year", year);
            query.setParameter("month", month);
            return ((Long) query.getSingleResult()).intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Course> searchCourses(String name, String category, String price) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT c FROM Course c WHERE 1=1");
            
            if (name != null && !name.trim().isEmpty()) {
                jpql.append(" AND c.name LIKE :name");
            }
            
            if (category != null && !category.trim().isEmpty()) {
                jpql.append(" AND c.category LIKE :category");
            }
            
            if (price != null && !price.trim().isEmpty()) {
                jpql.append(" AND c.price = :price");
            }
            
            jpql.append(" ORDER BY c.createdAt DESC");
            
            jakarta.persistence.Query query = em.createQuery(jpql.toString(), Course.class);
            
            if (name != null && !name.trim().isEmpty()) {
                query.setParameter("name", "%" + name.trim() + "%");
            }
            
            if (category != null && !category.trim().isEmpty()) {
                query.setParameter("category", "%" + category.trim() + "%");
            }
            
            if (price != null && !price.trim().isEmpty()) {
                try {
                    query.setParameter("price", new java.math.BigDecimal(price.trim()));
                } catch (NumberFormatException e) {
                    // Nếu price không phải số, bỏ qua filter này
                }
            }
            
            return query.getResultList();
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Course> searchCoursesWithPagination(String name, String category, String price, int pageNumber, int pageSize) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT c FROM Course c WHERE 1=1");
            
            if (name != null && !name.trim().isEmpty()) {
                jpql.append(" AND c.name LIKE :name");
            }
            
            if (category != null && !category.trim().isEmpty()) {
                jpql.append(" AND c.category LIKE :category");
            }
            
            if (price != null && !price.trim().isEmpty()) {
                jpql.append(" AND c.price = :price");
            }
            
            jpql.append(" ORDER BY c.createdAt DESC");
            
            jakarta.persistence.Query query = em.createQuery(jpql.toString(), Course.class);
            
            if (name != null && !name.trim().isEmpty()) {
                query.setParameter("name", "%" + name.trim() + "%");
            }
            
            if (category != null && !category.trim().isEmpty()) {
                query.setParameter("category", "%" + category.trim() + "%");
            }
            
            if (price != null && !price.trim().isEmpty()) {
                try {
                    query.setParameter("price", new java.math.BigDecimal(price.trim()));
                } catch (NumberFormatException e) {
                    // Nếu price không phải số, bỏ qua filter này
                }
            }
            
            // Set pagination
            query.setFirstResult((pageNumber - 1) * pageSize);
            query.setMaxResults(pageSize);
            
            return query.getResultList();
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public int countSearchResults(String name, String category, String price) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT COUNT(c) FROM Course c WHERE 1=1");
            
            if (name != null && !name.trim().isEmpty()) {
                jpql.append(" AND c.name LIKE :name");
            }
            
            if (category != null && !category.trim().isEmpty()) {
                jpql.append(" AND c.category LIKE :category");
            }
            
            if (price != null && !price.trim().isEmpty()) {
                jpql.append(" AND c.price = :price");
            }
            
            jakarta.persistence.Query query = em.createQuery(jpql.toString());
            
            if (name != null && !name.trim().isEmpty()) {
                query.setParameter("name", "%" + name.trim() + "%");
            }
            
            if (category != null && !category.trim().isEmpty()) {
                query.setParameter("category", "%" + category.trim() + "%");
            }
            
            if (price != null && !price.trim().isEmpty()) {
                try {
                    query.setParameter("price", new java.math.BigDecimal(price.trim()));
                } catch (NumberFormatException e) {
                    // Nếu price không phải số, bỏ qua filter này
                }
            }
            
            return ((Long) query.getSingleResult()).intValue();
            
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

}
