/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.service;

import com.agent.model.Action;
import static com.agent.service.ScheduleAIAgent.tryParseActions;
import com.dao.Calendar.CalendarDAO;
import com.dao.Reminder.EmailReminderDAO;
import com.model.Calendar;
import com.model.User;
import com.model.UserEvents;
import com.service.Event.EventService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author Admin
 */
public class AgentEventService {

    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("CLDPU");

    public void saveEventFromAction(Action action, Calendar calendar) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Map<String, Object> args = action.getArgs();

            UserEvents event = new UserEvents();
            event.setName((String) args.get("title"));
            event.setDescription((String) args.getOrDefault("description", ""));
            event.setLocation((String) args.getOrDefault("location", ""));
            event.setStartDate(Timestamp.valueOf((String) args.get("start_time")));
            event.setDueDate(Timestamp.valueOf((String) args.get("end_time")));
            event.setIsAllDay((Boolean) args.getOrDefault("is_all_day", false));
            event.setIsRecurring((Boolean) args.getOrDefault("is_recurring", false));
            event.setRecurrenceRule((String) args.getOrDefault("recurrence_rule", null));
            event.setColor((String) args.getOrDefault("color", "#2196f3"));
            event.setRemindMethod((Boolean) args.getOrDefault("remind_method", true));
            event.setRemindBefore((Integer) args.getOrDefault("remind_before", 30));
            event.setRemindUnit((String) args.getOrDefault("remind_unit", "minutes"));
            event.setCreatedAt(new Date());
            event.setUpdatedAt(new Date());
            event.setIdCalendar(calendar);

            em.persist(event);
            tx.commit();

        } catch (Exception e) {
            e.printStackTrace();
            if (tx.isActive()) {
                tx.rollback();
            }
        } finally {
            em.close();
        }
    }

    public Calendar getCurrentCalendar(User user) {
        EntityManager em = emf.createEntityManager();

        try {
            // 1. Kiểm tra xem user đã có calendar chưa
            TypedQuery<Calendar> query = em.createQuery(
                    "SELECT c FROM Calendar c WHERE c.idUser = :user", Calendar.class);
            query.setParameter("user", user);

            List<Calendar> results = query.getResultList();
            if (!results.isEmpty()) {
                return results.get(0);
            }

            // 2. Nếu chưa có, tạo mới một calendar cho user
            Calendar newCalendar = new Calendar();
            newCalendar.setIdUser(user); // gán user cho calendar
            newCalendar.setName("Lịch của " + user.getFirstName());
            newCalendar.setCreatedAt(new Date());
            newCalendar.setUpdatedAt(new Date());

            em.getTransaction().begin();
            em.persist(newCalendar);
            em.getTransaction().commit();

            return newCalendar;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public void saveUserEvent(UserEvents event) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(event);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    private static LocalDateTime tryParseDateTime(String input) {
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

    public static void main(String[] args) {
        EmbeddingService embeddingService = new EmbeddingService();
        EmailReminderDAO emailReminderDAO = new EmailReminderDAO();
        CalendarDAO calendarDAO = new CalendarDAO();
        EventService eventService = new EventService();
        AgentEventService agentEventService = new AgentEventService();
        String aiResponse = "Đã ghi nhận yêu cầu cập nhật sự kiện \"Đi bơi\". Dưới đây là thông tin cập nhật:\n"
                + "\n"
                + "[\n"
                + "  {\n"
                + "    \"toolName\": \"UPDATE_EVENT\",\n"
                + "    \"args\": {\n"
                + "     \"original_title\": \"Đi bơi\",\n"
                + "      \"title\": \"Họp nhóm\",\n"
                + "      \"start_time\": \"2025-07-16T09:00\",\n"
                + "      \"description\": \"Chuẩn bị slide thuyết trình\",\n"
                + "      \"location\": \"Phòng A301\"\n"
                + "    }\n"
                + "  }\n"
                + "]";

        Pattern jsonPattern = Pattern.compile("(\\[\\s*\\{[\\s\\S]*?\\}\\s*\\])");
        Matcher matcher = jsonPattern.matcher(aiResponse);
        System.out.println("🧠 Full AI Response:\n" + aiResponse);

        String jsonPart = null;
        if (matcher.find()) {
            jsonPart = matcher.group();  // 🎯 phần chỉ chứa JSON nội bộ
        }

        List<Action> actions = tryParseActions(jsonPart);  // ✅ truyền JSON thuần vào

        System.out.println("🎯 Actions parsed: " + actions);

        // ✂️ 2. Gỡ phần JSON khỏi aiResponse để chỉ hiển thị phần văn bản cho người dùng
        String userVisibleText = jsonPart != null
                ? aiResponse.replace(jsonPart, "").trim()
                : aiResponse.trim();
        System.out.println(actions);
        StringBuilder systemResult = new StringBuilder();
        UserEvents event = null;

        System.out.println(actions);
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

                            event = new UserEvents();
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

                            agentEventService.saveUserEvent(event);
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

                        // Có thể thêm các case khác như ADD_EVENT, DELETE_EVENT nếu cần
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

                        default ->
                            systemResult.append("⚠️ Hành động không được hỗ trợ: ").append(tool).append("\n");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    systemResult.append("❌ Lỗi khi xử lý hành động: ").append(tool).append("\n");
                }
            }
            if (added > 0) {
                systemResult.append("✅ Đã thêm ").append(added).append(" sự kiện.\n");
            }
            if (updated > 0) {
                systemResult.append("🔄 Đã cập nhật ").append(updated).append(" sự kiện.\n");
            }
            if (deleted > 0) {
                systemResult.append("🗑️ Đã xoá ").append(deleted).append(" sự kiện.\n");
            }
        } else {
            System.out.println("Khong co hanh dong nao");
        }
    }

}
