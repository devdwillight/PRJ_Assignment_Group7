/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao;

import jakarta.persistence.EntityManager;
import java.util.Collections;
import java.util.List;

/**
 *
 * @author Admin
 */
public class GenericDAO <T> extends BaseDAO{
    
    private final Class <T> entityClass;
    
    public GenericDAO (Class <T> entityClass){
        this.entityClass= entityClass;
    }
    @Override
    public EntityManager getEntityManager(){
        return emf.createEntityManager();
    }
    public List<T>findAll(){
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT e FROM " + entityClass.getSimpleName() + " e", entityClass)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
        finally{
            em.close();
        }
    }
    public T findById(int id ){
        EntityManager em = getEntityManager();
        try {
            return em.find(entityClass, id);
        } 
        finally {
            em.close();
        }
    }
    public  void save ( T entity){
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(entity);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        }finally{
            em.close();
        }
    }
    
    public boolean update (T entity){
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(entity);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }finally{
            em.close();
        }
    }
    public boolean delete( int id){
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            T entity = em.find(entityClass, id);
            if ( entity!= null){
                em.remove(entity);
            }
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
    
}
