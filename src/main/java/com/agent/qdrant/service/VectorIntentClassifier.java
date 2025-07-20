/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.qdrant.service;

import com.agent.qdrant.model.ActionType;
import com.agent.service.EmbeddingService;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Admin
 */
public class VectorIntentClassifier {

    private QdrantService qdrantService = new QdrantService();
    private EmbeddingService embeddingService = new EmbeddingService();

    public ActionType classifyIntent(String userInput) {
        try {
            float[] queryVector = embeddingService.getEmbedding(userInput);
            List<Map<String, Object>> results = qdrantService.searchSimilarVectors(queryVector, 3);

            if (results.isEmpty()) {
                return ActionType.UNKNOWN;
            }

            Map<String, Object> bestMatch = results.get(0);
            double score = (double) bestMatch.get("score");

            if (score < 0.80) {
                return ActionType.UNKNOWN;
            }

            Map<String, Object> payload = (Map<String, Object>) bestMatch.get("payload");
            String typeString = (String) payload.getOrDefault("type", "unknown");

            return ActionType.fromString(typeString);

        } catch (Exception e) {
            e.printStackTrace();
            return ActionType.ERROR;
        }
    }
    public String classifyWeather(String userInput) {
        try {
            float[] queryVector = embeddingService.getEmbedding(userInput);
            List<Map<String, Object>> results = qdrantService.searchSimilarVectors(queryVector, 3);
            System.out.println(results);
            if (results.isEmpty()) {
               return "EMPTY";
            }

            Map<String, Object> bestMatch = results.get(0);
            double score = (double) bestMatch.get("score");
            System.out.println(score);
            if (score < 0.6) {
                return "<0.6";
            }

            Map<String, Object> payload = (Map<String, Object>) bestMatch.get("payload");
            String typeString = (String) payload.getOrDefault("type", "unknown");
           
            return typeString;

        } catch (Exception e) {
            e.printStackTrace();
            return "UNKNOW";
        }
    }
}
