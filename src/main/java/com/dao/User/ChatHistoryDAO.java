/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.User;

import com.model.ChatHistory;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ChatHistoryDAO {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("CLDPU");

    public void save(ChatHistory chat) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(chat);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public List<ChatHistory> findBySessionId(String sessionId) {
        EntityManager em = emf.createEntityManager();
        List<ChatHistory> result = new ArrayList<>();
        try {
            result = em.createQuery(
                    "SELECT c FROM ChatHistory c WHERE c.sessionId = :sessionId ORDER BY c.timestamp",
                    ChatHistory.class)
                    .setParameter("sessionId", sessionId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return result;
    }
    public boolean deleteBySessionId(String sessionId) {
   EntityManager em = emf.createEntityManager();
    try {
        em.getTransaction().begin();
        em.createQuery("DELETE FROM ChatHistory c WHERE c.sessionId = :sessionId")
          .setParameter("sessionId", sessionId)
          .executeUpdate();
        em.getTransaction().commit();
        return true;
    } catch (Exception e) {
        e.printStackTrace();
        em.getTransaction().rollback();
        return false;
    } finally {
        em.close();
    }
}
}
