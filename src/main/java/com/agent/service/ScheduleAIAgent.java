/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.service;

import com.agent.model.Action;
import com.agent.model.Message;
import com.agent.model.ScheduleItem;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ScheduleAIAgent implements Serializable{
    private final LLM llm;
    private final ExcelDataManager dataManager;
    private final String sessionId;
    private final List<Message> conversationHistory;
    private final List<ScheduleItem> currentSchedule;
    private static final ObjectMapper objectMapper = new ObjectMapper();
    public ScheduleAIAgent() {
        this.llm = new LLM();
        this.dataManager = new ExcelDataManager();
        this.sessionId = generateSessionId();
        this.conversationHistory = new ArrayList<>();
        this.currentSchedule = dataManager.loadSchedules();

        initializeSystemMessage();
    }

    private void initializeSystemMessage() {
        StringBuilder systemPrompt = new StringBuilder();
        systemPrompt.append("Bạn là một Trợ lý AI thông minh chuyên hỗ trợ người dùng quản lý lịch cá nhân và sự kiện.\n");
        systemPrompt.append("Bạn cần hiểu được các yêu cầu phức tạp của người dùng về thời gian, ngày tháng và lịch học/làm việc định kỳ.\n\n");

        systemPrompt.append("## NHIỆM VỤ CỦA BẠN:\n");
        systemPrompt.append("1. Giúp người dùng thêm, chỉnh sửa, gợi ý hoặc xem các sự kiện trong lịch.\n");
        systemPrompt.append("2. Hiểu các mốc thời gian như: 'hôm nay', 'tuần sau', 'ba buổi một tuần', 'chỉ vào buổi tối', 'trừ thứ 2', v.v.\n");
        systemPrompt.append("3. Tự động phân tích yêu cầu và tạo nhiều sự kiện nếu cần thiết (ví dụ: lặp lại 3 buổi mỗi tuần).\n");
        systemPrompt.append("4. **Tuyệt đối KHÔNG trả JSON cho người dùng**, mà chỉ phản hồi bằng văn bản dễ hiểu.\n\n");

        systemPrompt.append("## KHI NGƯỜI DÙNG MUỐN TẠO SỰ KIỆN:\n");
        systemPrompt.append("- Nếu đủ thông tin (tiêu đề, thời gian bắt đầu, thời gian kết thúc), tạo một hoặc nhiều sự kiện.\n");
        systemPrompt.append("- Trả về phản hồi văn bản như: '✅ Đã thêm 3 sự kiện học tiếng Anh vào các buổi tối thứ 3, 5, 7 trong tuần này.'\n");
        systemPrompt.append("- Ngầm định tạo JSON nội bộ theo định dạng:\n");
        systemPrompt.append("{ \"toolName\": \"ADD_EVENT\", \"args\": { \"title\": \"Tên sự kiện\", \"start_time\": \"YYYY-MM-DDTHH:mm\", \"end_time\": \"YYYY-MM-DDTHH:mm\" } }\n");
        systemPrompt.append("- Không hiển thị JSON này với người dùng.\n\n");

        systemPrompt.append("## KHI CHƯA ĐỦ THÔNG TIN:\n");
        systemPrompt.append("- Nếu thiếu tiêu đề hoặc thời gian, hãy hỏi lại người dùng rõ ràng, ví dụ: 'Bạn muốn học vào lúc mấy giờ và trong những ngày nào?'\n");
        systemPrompt.append("- Đừng tạo sự kiện hoặc JSON nếu chưa rõ yêu cầu.\n\n");

        systemPrompt.append("## KHI NGƯỜI DÙNG YÊU CẦU GỢI Ý THỜI GIAN RẢNH:\n");
        systemPrompt.append("- Phân tích lịch hiện tại, tìm các khoảng trống dài hơn 30 phút.\n");
        systemPrompt.append("- Gợi ý bằng văn bản như: 'Bạn rảnh vào 19:00 - 20:00 ngày mai, muốn đặt lịch không?'\n");
        systemPrompt.append("- Nếu họ đồng ý, bạn sẽ tự động tạo JSON nội bộ.\n\n");


        systemPrompt.append("Ngày hiện tại là " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + ".\n");


// Không cần đoạn hiển thị mô tả lại nội dung cho người dùng nữa


        systemPrompt.append("- Nếu chưa rõ nội dung hoặc người dùng chưa xác nhận thời gian gợi ý, hãy hỏi lại người dùng trước khi trả về JSON.\n");

        systemPrompt.append("Các loại lịch trình:\n");
        for (ScheduleItem.ScheduleType type : ScheduleItem.ScheduleType.values()) {
            systemPrompt.append("- ").append(type.getDisplayName()).append("\n");
        }


        conversationHistory.add(new Message("system", systemPrompt.toString()));
    }

    private String generateSessionId() {
        return "SCHEDULE_SESSION_" + System.currentTimeMillis();
    }

    /**
     * Process user input and generate AI response
     */
    private void updateTodayInfo() {
        // Xóa các message system chứa ngày hôm nay cũ nếu có (để tránh trùng)
        conversationHistory.removeIf(m -> m.getRole().equals("system") && m.getContent().startsWith("Ngày hôm nay là"));

        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        conversationHistory.add(0, new Message("system", "Ngày hôm nay là: " + today));
    }

    public String processUserInput(String userInput) {
        conversationHistory.add(new Message("user", userInput + "\n" +
                "Nếu bạn muốn thêm sự kiện, hãy trả về danh sách các hành động ở dạng JSON:\n" +
                "[\n" +
                "  {\n" +
                "    \"tool_name\": \"ADD_EVENT\",\n" +
                "    \"args\": {\n" +
                "      \"title\": \"...\",\n" +
                "      \"start_time\": \"...\",\n" +
                "      \"end_time\": \"...\"\n" +
                "    }\n" +
                "  }\n" +
                "]\n" +
                "Nếu không có hành động nào, chỉ cần phản hồi bình thường.\n" +
                "⚠️ JSON action sẽ không hiển thị ra giao diện, dùng cho hệ thống xử lý tự động."
        ));

        String aiResponse = llm.generateResponse(conversationHistory);
        System.out.println("📥 AI Response:\n" + aiResponse);
        conversationHistory.add(new Message("assistant", aiResponse));

        // ✂️ 1. Cố gắng tách JSON ra khỏi phản hồi
        List<Action> actions = tryParseActions(aiResponse);
        System.out.println("🎯 Actions parsed: " + actions);


        // ✂️ 2. Gỡ phần JSON khỏi aiResponse để chỉ hiển thị phần văn bản cho người dùng
        String userVisibleText = aiResponse.replaceAll("(?s)\\[\\s*\\{.*?\\}\\s*\\]", "").trim();

        StringBuilder systemResult = new StringBuilder();

        if (actions != null && !actions.isEmpty()) {
            int count = 0;

            for (Action action : actions) {
                if ("ADD_EVENT".equals(action.getToolName())) {
                    try {
                        if (!action.getArgs().containsKey("title") ||
                                !action.getArgs().containsKey("start_time") ||
                                !action.getArgs().containsKey("end_time")) {
                            systemResult.append("📝 Thiếu thông tin sự kiện (tiêu đề hoặc thời gian).\n");
                            continue;
                        }

                        ScheduleItem item = new ScheduleItem(
                                (String) action.getArgs().get("title"),
                                LocalDateTime.parse((String) action.getArgs().get("start_time")),
                                LocalDateTime.parse((String) action.getArgs().get("end_time"))
                        );
                        currentSchedule.add(item);
                        count++;

                    } catch (Exception e) {
                        systemResult.append("⚠️ Lỗi định dạng thời gian trong sự kiện.\n");
                    }

                } else {
                    systemResult.append("⚠️ Hành động không được hỗ trợ: ")
                            .append(action.getToolName()).append("\n");
                }
            }

            dataManager.saveSchedules(currentSchedule);
            if (count > 0) {
                systemResult.append("✅ Đã thêm ").append(count).append(" sự kiện vào lịch trình.");
            }
        }

        // ✅ Trả kết quả đầy đủ: phản hồi của AI + kết quả hệ thống
        return (userVisibleText + "\n\n" + systemResult).trim();
    }



    public static List<Action> tryParseActions(String aiResponse) {
        try {
            aiResponse = aiResponse.trim();

            // Kiểm tra xem có bắt đầu bằng '{' hoặc '[' không => JSON
            if (!(aiResponse.startsWith("{") || aiResponse.startsWith("["))) {
                return Collections.emptyList();  // Không phải JSON, bỏ qua
            }

            if (aiResponse.startsWith("[")) {
                return Arrays.asList(objectMapper.readValue(aiResponse, Action[].class));
            } else {
                Action single = objectMapper.readValue(aiResponse, Action.class);
                return Collections.singletonList(single);
            }
        } catch (Exception e) {
            System.out.println("❌ Không thể parse Action(s): " + e.getMessage());
            return Collections.emptyList();
        }
    }



    //    public String processUserInput(String userInput) {
//        conversationHistory.add(new Message("user", userInput));
//        updateTodayInfo();
//
//        ActionType action = ActionRouter.detectAction(userInput);
//
//        switch (action) {
//            case ADD_EVENT:
//                return handleAddEvent(userInput);
//            case SHOW_TODAY:
//                return handleShowToday();
//            case SHOW_WEEK:
//                return getConversationSummary();
//            case SUGGEST_TIME:
//                return suggestAvailableTime();
//            case END_CONVERSATION:
//                return "Kết thúc rồi nhé bạn!";
//            case UNKNOWN:
//            default:
//                return "Mình chưa hiểu rõ lắm, bạn có thể nói lại không?";
//        }
//    }
    private String handleShowToday() {
        LocalDate today = LocalDate.now();
        List<ScheduleItem> todayEvents = currentSchedule.stream()
                .filter(e -> e.getStartTime().toLocalDate().equals(today))
                .toList();

        if (todayEvents.isEmpty()) return "📭 Hôm nay bạn không có lịch nào.";

        StringBuilder sb = new StringBuilder("📅 Lịch hôm nay:\n");
        for (ScheduleItem e : todayEvents) {
            sb.append("• ").append(e.getTitle()).append(" lúc ")
                    .append(e.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm"))).append("\n");
        }
        return sb.toString();
    }

    private String suggestAvailableTime() {
        // Giả sử bạn chỉ check hôm nay, từ 8h đến 20h
        LocalDateTime start = LocalDate.now().atTime(8, 0);
        LocalDateTime end = LocalDate.now().atTime(20, 0);
        List<ScheduleItem> events = currentSchedule.stream()
                .filter(e -> e.getStartTime().toLocalDate().equals(LocalDate.now()))
                .sorted(Comparator.comparing(ScheduleItem::getStartTime))
                .toList();

        List<String> freeSlots = new ArrayList<>();
        for (ScheduleItem event : events) {
            if (start.isBefore(event.getStartTime())) {
                freeSlots.add(start.format(DateTimeFormatter.ofPattern("HH:mm")) + " - " +
                        event.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm")));
            }
            start = event.getEndTime().isAfter(start) ? event.getEndTime() : start;
        }

        if (start.isBefore(end)) {
            freeSlots.add(start.format(DateTimeFormatter.ofPattern("HH:mm")) + " - " +
                    end.format(DateTimeFormatter.ofPattern("HH:mm")));
        }

        if (freeSlots.isEmpty()) return "Hôm nay bạn đã kín lịch! 😅";

        StringBuilder sb = new StringBuilder("🕐 Thời gian bạn còn rảnh hôm nay:\n");
        freeSlots.forEach(slot -> sb.append("• ").append(slot).append("\n"));
        return sb.toString();
    }


    private String handleAddEvent(String userInput) {
        ScheduleItem item = parseScheduleFromInput(userInput, "");
        if (item != null) {
            currentSchedule.add(item);
            dataManager.saveSchedules(currentSchedule);
            return "✅ Đã thêm sự kiện: " + item.getTitle();
        }
        return "Không thể thêm sự kiện.";
    }


    private String extractTitle(String input) {
        String[] stopWords = {
                "thêm", "lịch", "hẹn", "vào", "lúc", "tối", "sáng", "chiều", "trưa",
                "nay", "mai", "giờ", "phút", "ngày", "đi", "xem", "làm", "học", "gặp", "cùng"
        };

        // Chuẩn hóa câu
        input = input.toLowerCase().replaceAll("[^a-zA-Z0-9àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ\\s]", "");

        // Tách từ
        List<String> words = new ArrayList<>(Arrays.asList(input.split("\\s+")));

        // Lọc bỏ các từ không mang nghĩa danh từ
        words.removeIf(w -> Arrays.asList(stopWords).contains(w));

        if (words.isEmpty()) return "Lịch chưa rõ";

        // Gộp lại làm tiêu đề (có thể lấy từ cuối, hoặc tất cả từ còn lại)
        StringBuilder title = new StringBuilder();
        for (String word : words) {
            title.append(Character.toUpperCase(word.charAt(0)))
                    .append(word.substring(1))
                    .append(" ");
        }

        return title.toString().trim();
    }

    private ScheduleItem parseScheduleFromInput(String userInput, String aiResponse) {
        // Simplified parsing logic - in real implementation, this would be more sophisticated
        try {
            if (userInput.toLowerCase().contains("lịch") || userInput.toLowerCase().contains("hẹn") || userInput.toLowerCase().contains("kiện")) {
                // Create a basic schedule item
                LocalDateTime now = LocalDateTime.now();
                String title = extractTitle(userInput);
                ScheduleItem item = new ScheduleItem(title, now, now.plusHours(1));

                // Detect type
                if (userInput.toLowerCase().contains("học")) {
                    item.setScheduleType(ScheduleItem.ScheduleType.STUDY);
                } else if (userInput.toLowerCase().contains("làm việc") || userInput.toLowerCase().contains("họp")) {
                    item.setScheduleType(ScheduleItem.ScheduleType.WORK);
                } else if (userInput.toLowerCase().contains("du lịch")) {
                    item.setScheduleType(ScheduleItem.ScheduleType.TRAVEL);
                } else if (userInput.toLowerCase().contains("sự kiện")) {
                    item.setScheduleType(ScheduleItem.ScheduleType.EVENT);
                }

                return item;
            }
        } catch (Exception e) {
            System.err.println("Lỗi parse lịch: " + e.getMessage());
        }

        return null;
    }

    public String getGreeting() {
        List<Message> greetingMessages = new ArrayList<>();
        greetingMessages.add(conversationHistory.get(0));
        greetingMessages.add(new Message("user", "Xin chào, tôi cần tư vấn quản lý lịch trình"));

        try {
            return llm.generateResponse(greetingMessages);
        } catch (Exception e) {
            return "🤖 Xin chào! Tôi là AI Assistant quản lý lịch trình thông minh.\n" +
                    "Tôi có thể giúp bạn:\n" +
                    "✅ Tạo lịch học tập, công việc, sự kiện\n" +
                    "✅ Tối ưu hóa thời gian\n" +
                    "✅ Đưa ra lời khuyên quản lý thời gian\n\n" +
                    "Hãy chia sẻ kế hoạch của bạn để bắt đầu!";
        }
    }

    public boolean shouldEndConversation(String userInput) {
        String input = userInput.toLowerCase().trim();
        return input.equals("bye") || input.equals("tạm biệt") ||
                input.equals("kết thúc") || input.equals("quit") ||
                input.equals("exit") || input.equals("end");
    }

    public String getConversationSummary() {
        if (conversationHistory.size() <= 1) {
            return "Không có cuộc trò chuyện nào được ghi nhận.";
        }

        StringBuilder summary = new StringBuilder();
        summary.append("📌 TÓM TẮT LỊCH TRÌNH:\n");

        for (ScheduleItem item : currentSchedule) {
            summary.append("• [").append(item.getScheduleType().getDisplayName()).append("] ")
                    .append(item.getTitle()).append(" - ")
                    .append(item.getStartTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")))
                    .append("\n");
        }

        summary.append("\n💡 Số lượng sự kiện: ").append(currentSchedule.size());

        return summary.toString();
    }

    public List<ScheduleItem> getCurrentSchedule() {
        return new ArrayList<>(currentSchedule);
    }
}

/**
 * Console chat application for schedule management
 */
