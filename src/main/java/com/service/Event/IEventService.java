/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.Event;

import com.model.UserEvents;
import java.util.List;

/**
 *
 * @author DELL
 */
public interface IEventService {

    int countEvent();

    boolean updateEvent(UserEvents event);

    boolean removeEvent(int id);
    
    UserEvents createEvent(UserEvents event);

    UserEvents getEventById(int id);

    List<UserEvents> getAllEvent();

}
