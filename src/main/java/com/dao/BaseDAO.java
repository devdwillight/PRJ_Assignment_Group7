/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao;

import jakarta.persistence.*;
import java.io.Serializable;
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
}
