/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.service;

import com.agent.model.Action;
import com.agent.qdrant.model.ActionType;
import com.agent.model.Message;
import com.agent.model.ScheduleItem;
import com.agent.model.TimeSlot;
import com.agent.qdrant.model.PendingEvent;
import com.agent.qdrant.model.TimeContext;
import com.agent.qdrant.service.VectorIntentClassifier;
import com.dao.Calendar.CalendarDAO;
import com.dao.Reminder.EmailReminderDAO;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.model.Calendar;
import com.model.UserEvents;
import com.service.Event.EventService;
import com.service.Event.TimeSlotUnit;
import java.io.Serializable;
import java.sql.Timestamp;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author Admin
 */
public class ScheduleAIAgent implements Serializable {

    private final LLM llm;
    private final String sessionId;
    private final List<Message> conversationHistory;
    private static final ObjectMapper objectMapper = new ObjectMapper();
    private Map<String, PendingEvent> pendingEvents = new HashMap<>();
    private EmbeddingService embeddingService = new EmbeddingService();
    private EmailReminderDAO emailReminderDAO = new EmailReminderDAO();
    private CalendarDAO calendarDAO = new CalendarDAO();
    private EventService eventService = new EventService();
    private AgentEventService agentEventService = new AgentEventService();
    private VectorIntentClassifier classifier = new VectorIntentClassifier();
    private WheatherService wheatherService = new WheatherService();

    public ScheduleAIAgent() {
        this.llm = new LLM();
        this.sessionId = generateSessionId();
        this.conversationHistory = new ArrayList<>();

        initializeSystemMessage();
    }

    private void initializeSystemMessage() {
        StringBuilder systemPrompt = new StringBuilder();

        systemPrompt.append("""
Bạn là một Trợ lý AI giúp người dùng quản lý lịch trình học tập và công việc và luôn nhớ các ngày lễ và sự kiện quan trọng của Việt Nam.
Hãy hiểu ngôn ngữ tự nhiên, linh hoạt với các mô tả như "tối nay", "cuối tuần", "3 buổi mỗi tuần", v.v.

## MỤC TIÊU:
- Gợi ý, tạo, sửa, hoặc xoá sự kiện.
- Luôn phản hồi bằng văn bản tự nhiên (không hiện JSON).
- Nếu thiếu thông tin, hãy hỏi lại người dùng.
- Bạn hãy phản hồi dựa theo system message

## KHI TẠO SỰ KIỆN:
- Khi người dùng nói các câu như:
  - "Tạo lịch hẹn lúc 9h ngày mai"
  - "Thêm event học nhóm"
  - "Lên lịch họp với team vào thứ 6"
  => Hiểu là người dùng muốn **tạo sự kiện mới**.
-Nếu đủ thông tin, tạo JSON nội bộ và luôn nhớ không hiển thị JSON cho người dùng
[
  {
    "toolName": "ADD_EVENT",
    "args": {
      "title": "...",
      "start_time": "YYYY-MM-DDTHH:mm",
      "end_time": "YYYY-MM-DDTHH:mm",
      "description": "...",
      "location": "...",
      "is_all_day": false,
      "is_recurring": false,
      "color": "#2196f3",
      "remind_method": true,
      "remind_before": 30,
      "remind_unit": "minutes"
    }
  }
]
- Nếu phát hiện thời gian bị trùng với sự kiện khác, hãy hỏi lại người dùng một thời gian khác. Không tự ý thêm nếu bị trùng.

## KHI SỬA SỰ KIỆN:
- Khi người dùng nói các câu như:
    -"Thay đổi thời gian của lịch hẹn `Đi bơi` lại"
    -"Sửa lịch hẹn `event_id` = 1"
    -"Update lịch hẹn"
    => Hiểu là người dùng muốn** Sửa sự kiện"
- Nếu có `event_id`, dùng nó.
- Nếu không, dùng `original_title` để tìm sự kiện cần sửa.
- Ví dụ:
[
  {
    "toolName": "UPDATE_EVENT",
    "args": {
      "event_id": 123,
      "original_title": "Cuộc họp cũ",
      "title": "Cuộc họp mới",
      "start_time": "YYYY-MM-DDTHH:mm",
      "description": "mô tả mới"
    }
  }
]

## KHI XOÁ SỰ KIỆN:
- Khi người dùng nói các câu như:
    -"Xóa lịch hẹn `Học toán` ngày 21 tháng 7"
    -"Xóa lịch học Tiếng Anh"
    -"Xóa lịch hẹn `event_id` = 1"
    => Hiểu là người dùng muốn** Xóa sự kiện"
- Dùng `event_id` nếu có, hoặc `title` nếu không có ID.
- Ví dụ:
[
  { "toolName": "DELETE_EVENT", "args": { "event_id": 42 } }
]
hoặc
[
  { "toolName": "DELETE_EVENT", "args": { "title": "Tên sự kiện" } }
]
                            

## NGUYÊN TẮC:
- Tránh dùng từ kỹ thuật với người dùng.
- Nếu phát hiện thời gian bị trùng với sự kiện khác, hãy hỏi lại người dùng một thời gian khác. Không tự ý thêm nếu bị trùng.
- Luôn diễn giải ý định rõ ràng, thân thiện.
- Ngày hiện tại là """ + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + ".\n");
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
    public String processUserInput(String userInput) throws Exception {

        conversationHistory.add(new Message("user", userInput));

        String aiResponse = llm.generateResponse(conversationHistory);
        UserEvents recentEvent = null;
        StringBuilder systemResult = new StringBuilder();

        aiResponse = aiResponse.replaceAll("(?s)```json\\s*", "").replaceAll("(?s)```\\s*", "");

        Pattern jsonPattern = Pattern.compile("(\\[\\s*\\{[\\s\\S]*?\\}\\s*\\])");
        Matcher matcher = jsonPattern.matcher(aiResponse);
        System.out.println("🧠 Full AI Response:\n" + aiResponse);

        String jsonPart = null;
        if (matcher.find()) {
            jsonPart = matcher.group();  // 🎯 phần chỉ chứa JSON nội bộ
        }

        List<Action> actions = tryParseActions(jsonPart);  // ✅ truyền JSON thuần vào

        // ✂️ 2. Gỡ phần JSON khỏi aiResponse để chỉ hiển thị phần văn bản cho người dùng
        String userVisibleText = jsonPart != null
                ? aiResponse.replace(jsonPart, "").trim()
                : aiResponse.trim();

        if (actions != null && !actions.isEmpty()) {
            int added = 0, updated = 0, deleted = 0;

            for (Action action : actions) {
                String tool = action.getToolName();

                try {
                    switch (tool) {
                        case "ADD_EVENT" -> {
                            if (!action.getArgs().containsKey("title")
                                    || !action.getArgs().containsKey("start_time")
                                    || !action.getArgs().containsKey("end_time")) {
                                systemResult.append("📝 Thiếu thông tin sự kiện (tiêu đề hoặc thời gian).\n");
                                continue;
                            }

                            String title = (String) action.getArgs().get("title");
                            String rawStart = (String) action.getArgs().get("start_time");
                            String rawEnd = (String) action.getArgs().get("end_time");

                            LocalDateTime start = tryParseDateTime(rawStart);
                            LocalDateTime end = tryParseDateTime(rawEnd);

                            List<UserEvents> conflicted = eventService.isTimeConflict(start, end);
                            if (!conflicted.isEmpty()) {
                                systemResult.append("⚠️ Sự kiện bị trùng thời gian với các sự kiện sau:\n");
                                for (UserEvents conflict : conflicted) {
                                    systemResult.append(" - ").append(conflict.getName())
                                            .append(" (").append(conflict.getStartDate())
                                            .append(" - ").append(conflict.getDueDate()).append(")\n");
                                }
                                continue;
                            }

                            UserEvents event = new UserEvents();
                            event.setName(title);
                            event.setStartDate(Timestamp.valueOf(start));
                            event.setDueDate(Timestamp.valueOf(end));
                            event.setCreatedAt(new Date());
                            event.setUpdatedAt(new Date());
                            event.setIsAllDay(false);
                            event.setIsRecurring(false);
                            event.setColor("#2196f3");
                            event.setRemindMethod(true);
                            event.setRemindBefore(30);
                            event.setRemindUnit("minutes");

                            if (action.getArgs().containsKey("location")) {
                                event.setLocation((String) action.getArgs().get("location"));
                            }
                            if (action.getArgs().containsKey("description")) {
                                event.setDescription((String) action.getArgs().get("description"));
                            }
                            Calendar calendar = calendarDAO.selectCalendarById(1);
                            event.setIdCalendar(calendar);

                            String intentWheather = classifier.classifyWeather(userInput);
                            if (intentWheather.equals("outdoor_activities")) {
                                String forecastNote = wheatherService.getForecastNote(start, "Da Nang");
                                if (forecastNote != null && !forecastNote.isEmpty()) {
                                    pendingEvents.put("default", new PendingEvent(event));
                                    systemResult.append("🌦 ").append(forecastNote).append("\n").
                                            append("❓Bạn có muốn tiếp tục tạo sự kiện ngoài trời này không?").
                                            append("\n");
                                    return systemResult.toString(); // Dừng ở đây
                                } else {
                                    
                                    System.out.println("⛅ Thời tiết tốt, tự động thêm sự kiện.");
                                }

                            }

                            agentEventService.saveUserEvent(event);
                            systemResult.append("✅ Đã thêm sự kiện: ").append(title).append(" vào lịch trình.\n");
                            recentEvent = event;
                            added++;

                        }

                        case "UPDATE_EVENT" -> {
                            UserEvents existing = null;

                            if (action.getArgs().containsKey("event_id")) {
                                int eventId = (int) action.getArgs().get("event_id");
                                existing = eventService.getEventById(eventId);
                            } else if (action.getArgs().containsKey("original_title")) {
                                String ori_title = (String) action.getArgs().get("original_title");
                                existing = eventService.getFirstEventByTitle(ori_title);
                                System.out.println(ori_title);
                            }

                            if (existing == null) {
                                systemResult.append("❌ Không tìm thấy sự kiện để cập nhật.\n");
                                continue;
                            }

                            if (action.getArgs().containsKey("title")) {
                                existing.setName((String) action.getArgs().get("title"));
                            }
                            if (action.getArgs().containsKey("start_time")) {
                                existing.setStartDate(Timestamp.valueOf(tryParseDateTime((String) action.getArgs().get("start_time"))));
                            }
                            if (action.getArgs().containsKey("end_time")) {
                                existing.setDueDate(Timestamp.valueOf(tryParseDateTime((String) action.getArgs().get("end_time"))));
                            }
                            if (action.getArgs().containsKey("location")) {
                                existing.setLocation((String) action.getArgs().get("location"));
                            }
                            if (action.getArgs().containsKey("description")) {
                                existing.setDescription((String) action.getArgs().get("description"));
                            }

                            existing.setUpdatedAt(new Date());
                            eventService.updateEvent(existing);
                            updated++;
                        }

                        case "DELETE_EVENT" -> {
                            boolean deletedOne = false;
                            if (action.getArgs().containsKey("event_id")) {
                                int id = (int) action.getArgs().get("event_id");
                                deletedOne = eventService.removeEvent(id);
                            } else if (action.getArgs().containsKey("title")) {
                                String title = (String) action.getArgs().get("title");
                                deletedOne = eventService.deleteByTitle(title);
                            }

                            if (deletedOne) {
                                deleted++;
                            } else {
                                systemResult.append("⚠️ Không tìm thấy sự kiện để xoá.\n");
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    systemResult.append("❌ Lỗi khi xử lý hành động: ").append(tool).append("\n");
                }
            }
        } else {
            System.out.println("Khong co hanh dong nao. Dang phan loai y dinh bang vector ...");

            ActionType intent = classifier.classifyIntent(userInput);

            switch (intent) {
                case PROMPT_FREE_TIME -> {
                    TimeContext context = TimeSlotUnit.extracTimeContext(userInput);
                    List<UserEvents> busytimes = eventService.getAllEvent();

                    List<UserEvents> filteredEvents;
                    switch (context) {
                        case TODAY ->
                            filteredEvents = TimeSlotUnit.filterEventsToday(busytimes);
                        case TOMORROW ->
                            filteredEvents = TimeSlotUnit.filterEventsTomorrow(busytimes);
                        case THIS_WEEK ->
                            filteredEvents = TimeSlotUnit.filterEventsThisWeek(busytimes);
                        case NEXT_WEEK ->
                            filteredEvents = TimeSlotUnit.filterEventsNextWeek(busytimes);
                        default ->
                            filteredEvents = busytimes;
                    }

                    List<TimeSlot> freeSlots = TimeSlotUnit.findFreeTime(filteredEvents);
                    systemResult.append("📆 Các khoảng thời gian rảnh nè hihi :\n");
                    for (TimeSlot slot : freeSlots) {
                        systemResult.append(" - ").append(slot.toString()).append("\n");
                    }
                }
                case PROMPT_SUMMARY_TIME -> {
                    try {
                        String summary = handleSummaryRequest(
                                userInput, // prompt người dùng nhập
                                embeddingService, // service để lấy vector embedding
                                eventService // service để truy vấn sự kiện trong khoảng thời gian
                        );
                        if (summary != null) {
                            return summary;
                        } else {
                            return "📝 Mình không hiểu khoảng thời gian bạn muốn tổng hợp. Bạn có thể hỏi kiểu như: \"Lịch hôm nay\", \"Sự kiện tuần sau\"...";
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        return "⚠️ Đã xảy ra lỗi khi xử lý yêu cầu tổng hợp lịch.";
                    }
                }
                case PROMPT_SEND_EMAIL -> {
                    Pattern pattern = Pattern.compile("trước (\\d{1,3}) ?(phút|giờ)");
                    matcher = pattern.matcher(userInput.toLowerCase());
                    if (matcher.find()) {
                        int value = Integer.parseInt(matcher.group(1));
                        String unit = matcher.group(2);

                        int remindMinutes = unit.equals("giờ") ? value * 60 : value;
                        // Tạo nhắc nhở
                        UserEvents upcoming = emailReminderDAO.getNextUpcomingEventByEventId(recentEvent.getIdEvent());
                        if (upcoming != null) {
                            emailReminderDAO.saveEmailReminder(upcoming.getIdEvent(), remindMinutes);
                            return "✅ Tôi sẽ gửi email nhắc bạn trước " + remindMinutes + " phút khi sự kiện bắt đầu.";
                        }
                    }
                }

            } // ✅ Trả kết quả đầy đủ: phản hồi của AI + kết quả hệ thốn
        }
        if (!systemResult.isEmpty()) {
            conversationHistory.add(new Message("system", systemResult.toString()));

            // ⛳️ PHA 2: Gọi lại AI để phản hồi phù hợp với trạng thái hệ thống
            String clarifiedResponse = llm.generateResponse(conversationHistory);
            conversationHistory.add(new Message("assistant", clarifiedResponse));
            return clarifiedResponse + "\n\n" + systemResult.toString().trim();
        }

// ✅ Nếu mọi thứ OK, trả về phản hồi ban đầu + kết quả xử lý
        conversationHistory.add(new Message("assistant", userVisibleText));
        return userVisibleText;
    }

    public static List<Action> tryParseActions(String jsonPart) {
        try {
            if (jsonPart == null || jsonPart.isEmpty()) {
                return Collections.emptyList();
            }
            ObjectMapper objectMapper = new ObjectMapper();
            List<Action> list = Arrays.asList(objectMapper.readValue(jsonPart, Action[].class));
            System.out.println("✅ Parsed " + list.size() + " action(s).");
            return list;
        } catch (Exception e) {
            System.out.println("❌ Không thể parse Action(s): " + e.getMessage());
            System.out.println("📄 JSON:\n" + jsonPart);
            return Collections.emptyList();
        }
    }

    public String getGreeting() {
        List<Message> greetingMessages = new ArrayList<>();
        greetingMessages.add(conversationHistory.get(0));
        greetingMessages.add(new Message("user", "Xin chào, tôi cần tư vấn quản lý lịch trình"));

        try {
            return llm.generateResponse(greetingMessages);
        } catch (Exception e) {
            return "🤖 Xin chào! Tôi là AI Assistant quản lý lịch trình thông minh.\n"
                    + "Tôi có thể giúp bạn:\n"
                    + "✅ Tạo lịch học tập, công việc, sự kiện\n"
                    + "✅ Tối ưu hóa thời gian\n"
                    + "✅ Đưa ra lời khuyên quản lý thời gian\n\n"
                    + "Hãy chia sẻ kế hoạch của bạn để bắt đầu!";
        }
    }

    public boolean shouldEndConversation(String userInput) {
        String input = userInput.toLowerCase().trim();
        return input.equals("bye") || input.equals("tạm biệt")
                || input.equals("kết thúc") || input.equals("quit")
                || input.equals("exit") || input.equals("end");
    }

    public String getConversationSummary() {
        if (conversationHistory.size() <= 1) {
            return "Không có cuộc trò chuyện nào được ghi nhận.";
        }

        StringBuilder summary = new StringBuilder("📌 TÓM TẮT CUỘC TRÒ CHUYỆN:\n");
        for (Message msg : conversationHistory) {
            summary.append(msg.getRole().equals("user") ? "🧑‍💻 Bạn: " : "🤖 AI: ")
                    .append(msg.getContent()).append("\n");
        }
        return summary.toString();
    }

    public List<ScheduleItem> getCurrentSchedule() {

        EventService eventService = new EventService();
        List<UserEvents> userEvents = eventService.getAllEvent();
        List<ScheduleItem> schedules = new ArrayList<>();

        for (UserEvents event : userEvents) {
            String name = event.getName();
            LocalDateTime start = event.getStartDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
            LocalDateTime end = event.getDueDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();

            ScheduleItem item = new ScheduleItem(name, start, end, null);

            // Ưu tiên hoặc màu có thể xác định priority
            item.setPriority("Normal");

            // Nếu bạn dùng Enum ScheduleType thì gán luôn:
            item.setScheduleType(ScheduleItem.ScheduleType.EVENT);

            schedules.add(item);
        }

        return schedules;
    }

    private LocalDateTime tryParseDateTime(String input) {
        List<String> patterns = List.of(
                "yyyy-MM-dd'T'HH:mm",
                "yyyy-MM-dd HH:mm",
                "dd/MM/yyyy HH:mm",
                "dd-MM-yyyy HH:mm"
        );

        for (String pattern : patterns) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
                return LocalDateTime.parse(input, formatter);
            } catch (Exception ignored) {
            }
        }

        throw new IllegalArgumentException("❌ Không thể parse ngày giờ: " + input);
    }

    public String checkFreeTimes(String userInputs, EmbeddingService embeddingService) throws Exception {
        EventService eventService = new EventService();
        List<String> freeTimeIntents = Arrays.asList(
                "Gợi ý khung giờ học môn Toán",
                "Tôi muốn biết lúc nào rảnh để học",
                "Bạn có thể cho tôi biết thời gian trống để lên lịch?",
                "Tìm khoảng thời gian rảnh trong tuần",
                "Lên lịch học phù hợp giúp tôi",
                "Hãy đề xuất giờ học hợp lý"
        );
        float[] inputVec = embeddingService.getEmbedding(userInputs);
        boolean isGetFreeTimeIntent = false;
        for (String example : freeTimeIntents) {
            float[] refVec = embeddingService.getEmbedding(example);
            if (embeddingService.cosineSimilarity(inputVec, refVec) > 0.82f) {
                isGetFreeTimeIntent = true;
                break;
            }
        }
        if (isGetFreeTimeIntent) {
            List<UserEvents> events = eventService.getAllEvent(); // Tim bang user_ID
            List<TimeSlot> freeSlots = TimeSlotUnit.findFreeTime(events);

            if (freeSlots.isEmpty()) {
                return "⛔ Hiện bạn không có khoảng thời gian trống nào trong tuần.";
            }
            StringBuilder response = new StringBuilder("📅 Các khoảng thời gian trống gợi ý:\n");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE - dd/MM/yyyy HH:mm");

            for (TimeSlot slot : freeSlots) {
                response.append("• ").append(slot.getStart().format(formatter))
                        .append(" → ").append(slot.getEnd().format(formatter))
                        .append("\n");
            }
            return response.toString();
        }

        return null;
    }

    public String handleSummaryRequest(String userInputs, EmbeddingService embeddingService, EventService eventService) throws Exception {
        // Xác định khoảng thời gian
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime start = now;
        LocalDateTime end = now;
        String range = null;

        if (userInputs.contains("hôm nay")) {
            start = now.toLocalDate().atStartOfDay();
            end = start.plusDays(1);
            range = "hôm nay";
        } else if (userInputs.contains("ngày mai")) {
            start = now.plusDays(1).toLocalDate().atStartOfDay();
            end = start.plusDays(1);
            range = "ngày mai";
        } else if (userInputs.contains("tuần này")) {
            DayOfWeek dow = now.getDayOfWeek();
            start = now.minusDays(dow.getValue() - 1).toLocalDate().atStartOfDay(); // Monday
            end = start.plusDays(7);
            range = "tuần này";
        } else if (userInputs.contains("tuần sau")) {
            DayOfWeek dow = now.getDayOfWeek();
            start = now.minusDays(dow.getValue() - 1).toLocalDate().atStartOfDay().plusWeeks(1);
            end = start.plusDays(7);
            range = "tuần sau";
        }

        if (range == null) {
            return null;
        }

        List<UserEvents> events = eventService.getEventsBetween(start, end);
        if (events.isEmpty()) {
            return "📭 Không có sự kiện nào trong " + range + ".";
        }

        StringBuilder sb = new StringBuilder();
        sb.append("📆 Sự kiện ").append(range).append(":\n");
        for (UserEvents e : events) {
            sb.append("• ").append(e.getName())
                    .append(" 🕒 ").append(e.getStartDate()).append(" - ").append(e.getDueDate());
            if (e.getLocation() != null) {
                sb.append(" 📍 ").append(e.getLocation());
            }
            sb.append("\n");
        }
        return sb.toString();
    }

}
