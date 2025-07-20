/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.util;

import com.agent.service.ScheduleAIAgent;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author Admin
 */
public class SessionManager {

    private static final Map<String, ScheduleAIAgent> sessions = new ConcurrentHashMap<>();

    public static ScheduleAIAgent get(String sessionId) {
        return sessions.computeIfAbsent(sessionId, k -> new ScheduleAIAgent());
    }

    public static void put(String sessionId, ScheduleAIAgent agent) {
        sessions.put(sessionId, agent);
    }

    public static ScheduleAIAgent getOrCreate(String sessionId) {
        return sessions.computeIfAbsent(sessionId, k -> new ScheduleAIAgent());
    }

    
}
