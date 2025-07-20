/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao;

import com.model.UserEvents;
import jakarta.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author DELL
 */
public abstract class BaseDAO<T> {

    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("CLDPU");

    private final Class<T> entityClass;

    public BaseDAO(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    protected EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    
    protected void close() {
        emf.close();
    }

    protected boolean save(T entity) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(entity);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    protected boolean update(T entity) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(entity);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    protected boolean delete(int id) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            T entity = em.find(entityClass, id);
            if (entity != null) {
                tx.begin();
                em.remove(entity);
                tx.commit();
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    protected T find(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(entityClass, id);
        } finally {
            em.close();
        }
    }

    protected List<T> findAllByNamedEntity(String queryName, String paramName, Object paramValue) {
        EntityManager em = getEntityManager();
        try {
            return em.createNamedQuery(queryName, entityClass)
                    .setParameter(paramName, paramValue)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    protected List<T> findAllByEntity(String namedQuery) {
        EntityManager em = getEntityManager();
        try {
            return em.createNamedQuery(namedQuery, entityClass).getResultList();
        } finally {
            em.close();
        }
    }

    protected long count() {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT COUNT(e) FROM " + entityClass.getSimpleName() + " e";
            return em.createQuery(jpql, Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }
    protected boolean deleteByTitles(String title) {
         EntityManager em = getEntityManager();
    try {
        TypedQuery<UserEvents> query = em.createQuery(
            "SELECT e FROM UserEvents e WHERE e.name = :title", UserEvents.class);
        query.setParameter("title", title);
        List<UserEvents> events = query.getResultList();

        if (!events.isEmpty()) {
            em.getTransaction().begin();
            for (UserEvents event : events) {
                em.remove(event);
            }
           em.getTransaction().commit();
            return true;
        }
    } catch (Exception e) {
        e.printStackTrace();
        em.getTransaction().rollback();
    }
    return false;
}
    protected List<UserEvents> findEventsBetweens(Timestamp start, Timestamp end) {
    EntityManager em = getEntityManager(); // tự tạo class này hoặc inject nếu dùng Spring

    try {
        return em.createQuery(
                "SELECT e FROM UserEvents e WHERE e.startDate >= :start AND e.startDate < :end ORDER BY e.startDate",
                UserEvents.class)
                .setParameter("start", start)
                .setParameter("end", end)
                .getResultList();
    } catch (Exception e) {
        e.printStackTrace();
        return new ArrayList<>();
    } finally {
        em.close();
    }
}

}
