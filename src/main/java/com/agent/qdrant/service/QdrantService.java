/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.qdrant.service;

/**
 *
 * @author Admin
 */
import com.fasterxml.jackson.databind.JsonNode;
import java.net.URI;
import java.net.http.*;
import java.util.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import io.qdrant.client.grpc.Points.ScoredPoint;

public class QdrantService {

    private static final String QDRANT_URL = "https://45124d23-3e70-444c-884a-99ffe3ee3107.us-east4-0.gcp.cloud.qdrant.io:6333"; // hoặc URL của Qdrant cloud
    private static final String COLLECTION_NAME = "vector_duc";
    private final HttpClient httpClient = HttpClient.newHttpClient();
    private final ObjectMapper mapper = new ObjectMapper();

    public String upsertEmbedding(String id, float[] embedding, Map<String, Object> payload) throws Exception {
        List<Float> vector = new ArrayList<>();
        for (float v : embedding) {
            vector.add(v);
        }
        Object parsedId;
        // Sửa tại đây: parse ID sang Integer (hoặc UUID nếu bạn dùng UUID)
        try {
           parsedId = Integer.parseInt(id);
        } catch (NumberFormatException e) {
            try {
                // Nếu không phải số, thử parse thành UUID
                parsedId = UUID.fromString(id);
            } catch (IllegalArgumentException e2) {
                throw new RuntimeException("ID phải là số nguyên hoặc UUID hợp lệ. Giá trị: " + id);
            }
        }
        Map<String, Object> point = new HashMap<>();
        point.put("id", parsedId);  
        point.put("vector", vector);
        point.put("payload", payload);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("points", List.of(point));
        String jsonRequest = mapper.writeValueAsString(requestBody);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(QDRANT_URL + "/collections/" + COLLECTION_NAME + "/points"))
                .header("Content-Type", "application/json")
                .header("api-key", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3MiOiJtIn0.K1KkF5GitElW8iLR8WgOnbG3KXW0DADlcJO-MDTdFks")
                .PUT(HttpRequest.BodyPublishers.ofString(jsonRequest))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() != 200) {
            throw new RuntimeException("Lỗi khi gửi embedding tới Qdrant: " + response.body());
        }

        return response.body();
    }

    public List<Map<String, Object>> searchSimilarVectors(float[] queryVector, int topK) throws Exception {
        List<Float> vector = new ArrayList<>();
        for (float v : queryVector) {
            vector.add(v);
        }

        Map<String, Object> searchRequest = new HashMap<>();
        searchRequest.put("vector", vector);
        searchRequest.put("top", topK); // số kết quả tương đồng muốn lấy
        searchRequest.put("with_payload", true); // trả luôn metadata/payload

        String jsonRequest = mapper.writeValueAsString(searchRequest);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(QDRANT_URL + "/collections/" + COLLECTION_NAME + "/points/search"))
                .header("Content-Type", "application/json")
                .header("api-key", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3MiOiJtIn0.K1KkF5GitElW8iLR8WgOnbG3KXW0DADlcJO-MDTdFks")
                .POST(HttpRequest.BodyPublishers.ofString(jsonRequest))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new RuntimeException("Lỗi khi tìm vector tương tự: " + response.body());
        }

        // Phân tích JSON kết quả
        JsonNode jsonNode = mapper.readTree(response.body());
        List<Map<String, Object>> results = new ArrayList<>();

        for (JsonNode resultNode : jsonNode.get("result")) {
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("id", resultNode.get("id").asText());
            resultMap.put("score", resultNode.get("score").asDouble());
            if (resultNode.has("payload")) {
                resultMap.put("payload", mapper.convertValue(resultNode.get("payload"), Map.class));
            }
            results.add(resultMap);
        }

        return results;
    }

}
