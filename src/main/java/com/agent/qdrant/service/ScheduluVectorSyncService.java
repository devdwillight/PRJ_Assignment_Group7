/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.qdrant.service;

import com.agent.qdrant.service.QdrantService;
import com.agent.service.EmbeddingService;
import com.model.UserEvents;
import com.service.Event.EventService;
import com.service.User.UserService;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.json.JSONObject;

/**
 *
 * @author Admin
 */
public class ScheduluVectorSyncService {

    private QdrantService qdrantService = new QdrantService();
    private EventService eventService = new EventService();
    private EmbeddingService embeddingService = new EmbeddingService();

    public void syncAll() {
        List<UserEvents> events = eventService.getAllEvent();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        for (UserEvents event : events) {
            try {
                // Ghép nội dung văn bản dùng để embedding
                String content = event.getName() + " "
                        + event.getDescription() + " "
                        + event.getLocation() + " "
                        + event.getStartDate() + " "
                        + event.getDueDate();

                float[] embedding = embeddingService.getEmbedding(content);
                System.out.println("Dimensionality = " + embedding.length);

                Map<String, Object> metadata = new HashMap<>();
                metadata.put("title", safeString(event.getName()));
                LocalDateTime start = event.getStartDate().toInstant()
                        .atZone(ZoneId.systemDefault())
                        .toLocalDateTime();

                LocalDateTime end = event.getDueDate().toInstant()
                        .atZone(ZoneId.systemDefault())
                        .toLocalDateTime();

                metadata.put("start", start.format(formatter));
                metadata.put("end", end.format(formatter));

                metadata.put("location", event.getLocation() != null ? event.getLocation() : "");
                metadata.put("description", event.getDescription() != null ? event.getDescription() : "");

                System.out.println(qdrantService.upsertEmbedding(
                        String.valueOf(event.getIdEvent()),
                        embedding,
                        metadata
                ));

            } catch (Exception e) {
                System.err.println("❌ Lỗi xử lý sự kiện ID " + event.getIdEvent() + ": " + e.getMessage());
            }
        }
    }

    public void syncPromtFreeTime() {
        List<String> freeTimeIntents = Arrays.asList(
                "Gợi ý khung giờ học môn Toán",
                "Bạn có thể gợi ý lịch học toán ngày mai,tuần sau được không?",
                "Tôi muốn biết lúc nào rảnh để học",
                "Bạn có thể cho tôi biết thời gian trống để lên lịch?",
                "Tìm khoảng thời gian rảnh trong tuần",
                "Lên lịch học phù hợp giúp tôi",
                "Hãy đề xuất giờ học hợp lý"
        );

        try {
            int i = 0;
            for (String promt : freeTimeIntents) {
                i += 1;
                float[] embedding = embeddingService.getEmbedding(promt);

                Map<String, Object> metadata = new HashMap<>();

                metadata.put("type", "prompt_free_time");

                metadata.put("prompt", promt);

                String id = UUID.randomUUID().toString();

                qdrantService.upsertEmbedding(id, embedding, metadata);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void syncPromtSummaryRequest() {
        List<String> summaryIntents = Arrays.asList(
                "Tổng hợp lịch hôm nay",
                "Lịch trình tuần tới",
                "Tổng hợp Lịch ngày mai",
                "Có gì trong tuần này?",
                "Sự kiện tuần sau",
                "Tuần tới có gì không?",
                "Lịch trình hôm nay như thế nào?",
                "Cho tôi biết lịch hôm nay"
        );
        try {
            int i = 0;
            for (String prompt : summaryIntents) {
                i += 1;
                float[] embedding = embeddingService.getEmbedding(prompt);
                Map<String, Object> metadata = new HashMap<>();

                metadata.put("type", "prompt_summary_time");

                metadata.put("prompt", prompt);

                String id = UUID.randomUUID().toString();

                qdrantService.upsertEmbedding(id, embedding, metadata);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void syncPromptSendEmail() {
        List<String> emailIntents = Arrays.asList(
                "Gửi email cho tôi trước 30 phút sự kiện này bắt đầu",
                "Nhắc tôi qua email trước 40 phút sự kiện",
                "Trước 1 tiếng thì gửi email nhắc nhé",
                "Email nhắc nhở trước 45 phút",
                "Gửi thông báo mail trước khi sự kiện diễn ra",
                "Làm ơn nhắc tôi bằng email khoảng 30-60 phút trước lịch hẹn này bắt đầu"
        );
        try {
            int i = 0;
            for (String prompt : emailIntents) {
                i += 1;
                float[] embedding = embeddingService.getEmbedding(prompt);
                Map<String, Object> metadata = new HashMap<>();

                metadata.put("type", "prompt_send_email");

                metadata.put("prompt", prompt);

                String id = UUID.randomUUID().toString();

                qdrantService.upsertEmbedding(id, embedding, metadata);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void syncOutdoorActivity() {
        List<String> outdoor = Arrays.asList(
                "đá bóng", "bơi", "dã ngoại", "leo núi", "chạy bộ", "tennis", "đạp xe", "chơi cầu lông", "cắm trại", "đi bộ đường dài",
                "đi phượt","đi banahill"
        );
        try {
            
            for (String prompt : outdoor) {
                
                float[] embedding = embeddingService.getEmbedding(prompt);
                Map<String, Object> metadata = new HashMap<>();

                metadata.put("type", "outdoor_activities");

                metadata.put("label", prompt);

                String id = UUID.randomUUID().toString();

                qdrantService.upsertEmbedding(id, embedding, metadata);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void syncPromptAddEvent() {
        List<String> addIntents = Arrays.asList(
                "Lên lịch hẹn học toán vào lúc 7h đến 9h",
                "Tạo sự kiện Inno vào lúc 11h đến 13h",
                "Tạo lịch hẹn đi bơi",
                "Tạo Event Thi Hoa Hậu vào ngày mai lúc 5h tại FPT University",
                "Tạo lịch trình học toán"
        );
        try {
            int i = 0;
            for (String prompt : addIntents) {
                i += 1;
                float[] embedding = embeddingService.getEmbedding(prompt);
                Map<String, Object> metadata = new HashMap<>();

                metadata.put("toolName", "ADD_EVENT");

                metadata.put("prompt", prompt);

                String id = UUID.randomUUID().toString();

                qdrantService.upsertEmbedding(id, embedding, metadata);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private String safeString(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\"", "\\\""); // escape dấu "
    }

    public static void main(String[] args) {
        ScheduluVectorSyncService scheduluVectorSyncService = new ScheduluVectorSyncService();
        scheduluVectorSyncService.syncPromptAddEvent();
    }

}
