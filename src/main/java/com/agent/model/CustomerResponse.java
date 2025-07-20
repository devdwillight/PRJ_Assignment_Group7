/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.model;

/**
 *
 * @author Admin
 */
public class CustomerResponse {
    private String timestamp;
    private String customerInput;
    private String aiResponse;
    private String sessionId;

    public CustomerResponse(String timestamp, String customerInput, String aiResponse, String sessionId) {
        this.timestamp = timestamp;
        this.customerInput = customerInput;
        this.aiResponse = aiResponse;
        this.sessionId = sessionId;
    }

    // Getters
    public String getTimestamp() {
        return timestamp;
    }

    public String getCustomerInput() {
        return customerInput;
    }

    public String getAiResponse() {
        return aiResponse;
    }

    public String getSessionId() {
        return sessionId;
    }
}
