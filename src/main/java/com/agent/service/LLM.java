/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.service;

import com.agent.model.Message;
import com.agent.util.ConfigLoader;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

/**
 *
 * @author Admin
 */
public class LLM {

    private static final String API_KEY =ConfigLoader.get("GEMINI_API_KEY");
    private static final String ENDPOINT = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=" + API_KEY;

    public String generateResponse(List<Message> messages) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(ENDPOINT);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            // Build the request JSON
            List<Map<String, String>> parts = new ArrayList<>();
            for (Message msg : messages) {
                if (msg.getContent() != null && !msg.getContent().isEmpty()) {
                    Map<String, String> part = new HashMap<>();
                    part.put("text", msg.getContent());
                    parts.add(part);
                }
            }

            Map<String, Object> content = new HashMap<>();
            content.put("role", "user");
            content.put("parts", parts);
            
            List<Map<String, Object>> contents = new ArrayList<>();
            contents.add(content);
            
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("contents", contents);

            // Convert to JSON
            ObjectMapper mapper = new ObjectMapper();
            String json = mapper.writeValueAsString(requestBody);


            // Send request
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = json.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            // Read response
            Scanner scanner = new Scanner(conn.getInputStream());
            StringBuilder response = new StringBuilder();
            while (scanner.hasNext()) {
                response.append(scanner.nextLine());
            }
            scanner.close();

            // Parse response
            Map<String, Object> result = mapper.readValue(response.toString(), Map.class);
            List<Map<String, Object>> candidates = (List<Map<String, Object>>) result.get("candidates");
            Map<String, Object> firstCandidate = candidates.get(0);
            Map<String, Object> message = (Map<String, Object>) firstCandidate.get("content");
            List<Map<String, Object>> contentParts = (List<Map<String, Object>>) message.get("parts");

            return (String) contentParts.get(0).get("text");

        } catch (Exception e) {
            e.printStackTrace();
            return "[Gemini API error: " + e.getMessage() + "]";
        }
    }
}
