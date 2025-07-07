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
public abstract class BaseDAO {

    protected static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("CLDPU");

    protected EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void close() {
        emf.close();
    }

}
