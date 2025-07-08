/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.Event;

import com.dao.BaseDAO;
import com.model.UserEvents;
import java.util.List;

/**
 *
 * @author DELL
 */
public class EventDAO extends BaseDAO<UserEvents> implements IEventDAO {

    public EventDAO() {
        super(UserEvents.class);
    }

    @Override
    public int countEvent() {
        return (int) count();
    }

    @Override
    public boolean insertEvent(UserEvents event) {
        return save(event);
    }

    @Override
    public boolean updateEvent(UserEvents event) {
        return update(event);
    }

    @Override
    public boolean deleteEvent(int id) {
        return delete(id);
    }

    @Override
    public UserEvents selectEventById(int id) {
        return find(id);
    }

    @Override
    public List<UserEvents> selectAllEvent() {
        return findAllByEntity("UserEvents.findAll");
    }

}
