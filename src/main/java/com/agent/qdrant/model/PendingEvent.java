/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.qdrant.model;

import com.model.UserEvents;

/**
 *
 * @author Admin
 */
public class PendingEvent {

    private UserEvents event;

    public PendingEvent(UserEvents event) {
        this.event = event;
    }

    public UserEvents getEvent() {
        return event;
    }

    public PendingEvent() {
    }
     
}
