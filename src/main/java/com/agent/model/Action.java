/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.model;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Admin
 */
public class Action {
    private String toolName;
    private Map<String, Object> args;

    // Default constructor for Jackson
    public Action() {
        this.args = new HashMap<>();
    }

    public Action(String toolName, Map<String, Object> args) {
        this.toolName = toolName;
        this.args = args != null ? args : new HashMap<>();
    }

    public String getToolName() {
        return toolName;
    }

    public void setToolName(String toolName) {
        this.toolName = toolName;
    }

    public Map<String, Object> getArgs() {
        return args;
    }

    public void setArgs(Map<String, Object> args) {
        this.args = args;
    }
}
