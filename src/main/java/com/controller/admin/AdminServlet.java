/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.admin;

import com.model.User;
import com.model.Calendar;
import com.model.UserEvents;
import com.model.Course;
import com.service.User.UserService;
import com.service.Calendar.CalendarService;
import com.service.Event.EventService;
import com.service.Course.CourseService;
import com.service.Order.OrderService;
import com.model.Orders;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

/**
 *
 * @author ACER
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    private UserService userService = new UserService();
    private CalendarService calendarService = new CalendarService();
    private EventService eventService = new EventService();
    private CourseService courseService = new CourseService();
    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Lấy dữ liệu tổng quan
            int userCount = userService.countUsers();
            int calendarCount = calendarService.countCalendar();
            int eventCount = eventService.countEvent();
            int courseCount = courseService.countCourses();
            
            // 2. Tính toán phần trăm tăng trưởng so với tháng trước
            double userPercentChange = calculatePercentChange("user");
            double calendarPercentChange = calculatePercentChange("calendar");
            double eventPercentChange = calculatePercentChange("event");
            double coursePercentChange = calculatePercentChange("course");
            
            // 3. Lấy danh sách cho bảng (giới hạn 10 record để tối ưu hiệu suất)
            List<User> userList = userService.getAllUsers();
            List<Calendar> calendarList = calendarService.getAllCalendar();
            List<UserEvents> eventList = eventService.getAllEvent();
            List<Course> courseList = courseService.getAllCourses();
            List<Orders> allOrders = orderService.getAllOrder();
            
            // 4. Lấy số sự kiện hôm nay (tạm thời tính từ danh sách)
            int todayEventCount = 0;
            Date today = new Date();
            java.util.Calendar todayCal = java.util.Calendar.getInstance();
            todayCal.setTime(today);
            int todayDay = todayCal.get(java.util.Calendar.DAY_OF_YEAR);
            int todayYear = todayCal.get(java.util.Calendar.YEAR);
            
            for (UserEvents e : eventList) {
                if (e.getStartDate() != null) {
                    java.util.Calendar eventCal = java.util.Calendar.getInstance();
                    eventCal.setTime(e.getStartDate());
                    if (eventCal.get(java.util.Calendar.DAY_OF_YEAR) == todayDay && 
                        eventCal.get(java.util.Calendar.YEAR) == todayYear) {
                        todayEventCount++;
                    }
                }
            }

            // 5. Dữ liệu cho biểu đồ sự kiện theo ngày trong tuần
            Map<String, Integer> eventByDay = new LinkedHashMap<>();
            eventByDay.put("T2", 0); 
            eventByDay.put("T3", 0); 
            eventByDay.put("T4", 0);
            eventByDay.put("T5", 0); 
            eventByDay.put("T6", 0); 
            eventByDay.put("T7", 0); 
            eventByDay.put("CN", 0);
            
            java.util.Calendar cal = java.util.Calendar.getInstance();
            for (UserEvents e : eventList) {
                if (e.getStartDate() != null) {
                    cal.setTime(e.getStartDate());
                    int dayOfWeek = cal.get(java.util.Calendar.DAY_OF_WEEK);
                    String label = switch (dayOfWeek) {
                        case java.util.Calendar.MONDAY -> "T2";
                        case java.util.Calendar.TUESDAY -> "T3";
                        case java.util.Calendar.WEDNESDAY -> "T4";
                        case java.util.Calendar.THURSDAY -> "T5";
                        case java.util.Calendar.FRIDAY -> "T6";
                        case java.util.Calendar.SATURDAY -> "T7";
                        default -> "CN";
                    };
                    eventByDay.put(label, eventByDay.get(label) + 1);
                }
            }

            // 6. Dữ liệu cho biểu đồ trạng thái sự kiện
            Map<String, Integer> eventStatusCount = new LinkedHashMap<>();
            eventStatusCount.put("Đã hoàn thành", 0);
            eventStatusCount.put("Đang diễn ra", 0);
            eventStatusCount.put("Sắp tới", 0);
            
            Date now = new Date();
            for (UserEvents e : eventList) {
                if (e.getDueDate() != null && e.getDueDate().before(now)) {
                    eventStatusCount.put("Đã hoàn thành", eventStatusCount.get("Đã hoàn thành") + 1);
                } else if (e.getStartDate() != null && e.getStartDate().before(now) && 
                          e.getDueDate() != null && e.getDueDate().after(now)) {
                    eventStatusCount.put("Đang diễn ra", eventStatusCount.get("Đang diễn ra") + 1);
                } else {
                    eventStatusCount.put("Sắp tới", eventStatusCount.get("Sắp tới") + 1);
                }
            }

            // 7. Dữ liệu cho biểu đồ khóa học theo category
            Map<String, Integer> courseByCategory = new LinkedHashMap<>();
            courseByCategory.put("Chưa phân loại", 0);
            
            for (Course c : courseList) {
                String category = c.getCategory() != null ? c.getCategory() : "Chưa phân loại";
                courseByCategory.put(category, courseByCategory.getOrDefault(category, 0) + 1);
            }

            // 7. Dữ liệu cho biểu đồ doanh thu theo tháng (chỉ từ đơn hàng đã hoàn thành)
            Map<String, Double> revenueByMonth = new LinkedHashMap<>();
            java.text.DateFormat monthFormat = new java.text.SimpleDateFormat("MM/yyyy");
            java.util.Calendar calRevenue = java.util.Calendar.getInstance();
            int currentYear = calRevenue.get(java.util.Calendar.YEAR);
            // Khởi tạo 12 tháng
            for (int m = 1; m <= 12; m++) {
                String label = String.format("%02d/%d", m, currentYear);
                revenueByMonth.put(label, 0.0);
            }
            for (Orders order : allOrders) {
                // Chỉ tính doanh thu từ đơn hàng đã hoàn thành
                if (order.getPaymentTime() != null && "Completed".equals(order.getStatus())) {
                    calRevenue.setTime(order.getPaymentTime());
                    int year = calRevenue.get(java.util.Calendar.YEAR);
                    int month = calRevenue.get(java.util.Calendar.MONTH) + 1;
                    if (year == currentYear) {
                        String label = String.format("%02d/%d", month, year);
                        revenueByMonth.put(label, revenueByMonth.get(label) + order.getTotalAmount());
                    }
                }
            }

            // 8. Chuyển đổi dữ liệu sang JSON cho Chart.js
            Gson gson = new Gson();
            request.setAttribute("eventByDayLabels", gson.toJson(new ArrayList<>(eventByDay.keySet())));
            request.setAttribute("eventByDayData", gson.toJson(new ArrayList<>(eventByDay.values())));
            request.setAttribute("eventStatusLabels", gson.toJson(new ArrayList<>(eventStatusCount.keySet())));
            request.setAttribute("eventStatusData", gson.toJson(new ArrayList<>(eventStatusCount.values())));
            request.setAttribute("courseByCategoryLabels", gson.toJson(new ArrayList<>(courseByCategory.keySet())));
            request.setAttribute("courseByCategoryData", gson.toJson(new ArrayList<>(courseByCategory.values())));
            // Thêm dữ liệu revenue cho biểu đồ doanh thu
            request.setAttribute("revenueLabels", gson.toJson(new ArrayList<>(revenueByMonth.keySet())));
            request.setAttribute("revenueData", gson.toJson(new ArrayList<>(revenueByMonth.values())));

            // Dữ liệu cho Grouped Bar Chart (theo tháng)
            String[] monthLabels = {"JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"};
            List<String> groupedLabels = Arrays.asList(monthLabels);
            int[] userCounts = new int[12];
            int[] calendarCounts = new int[12];
            int[] courseCounts = new int[12];
            // Đếm user theo tháng tạo
            for (User u : userList) {
                if (u.getCreatedAt() != null) {
                    java.util.Calendar calUser = java.util.Calendar.getInstance();
                    calUser.setTime(u.getCreatedAt());
                    int y = calUser.get(java.util.Calendar.YEAR);
                    int m = calUser.get(java.util.Calendar.MONTH); // 0-based
                    if (y == currentYear) userCounts[m]++;
                }
            }
            // Đếm calendar theo tháng tạo
            for (Calendar c : calendarList) {
                if (c.getCreatedAt() != null) {
                    java.util.Calendar calCalendar = java.util.Calendar.getInstance();
                    calCalendar.setTime(c.getCreatedAt());
                    int y = calCalendar.get(java.util.Calendar.YEAR);
                    int m = calCalendar.get(java.util.Calendar.MONTH);
                    if (y == currentYear) calendarCounts[m]++;
                }
            }
            // Đếm course theo tháng tạo
            for (Course c : courseList) {
                if (c.getCreatedAt() != null) {
                    java.util.Calendar calCourse = java.util.Calendar.getInstance();
                    calCourse.setTime(c.getCreatedAt());
                    int y = calCourse.get(java.util.Calendar.YEAR);
                    int m = calCourse.get(java.util.Calendar.MONTH);
                    if (y == currentYear) courseCounts[m]++;
                }
            }
            request.setAttribute("groupedLabels", gson.toJson(groupedLabels));
            request.setAttribute("userCountsByTime", gson.toJson(Arrays.stream(userCounts).boxed().toList()));
            request.setAttribute("calendarCountsByTime", gson.toJson(Arrays.stream(calendarCounts).boxed().toList()));
            request.setAttribute("courseCountsByTime", gson.toJson(Arrays.stream(courseCounts).boxed().toList()));

            // 9. Truyền dữ liệu lên JSP
            request.setAttribute("userCount", userCount);
            request.setAttribute("calendarCount", calendarCount);
            request.setAttribute("eventCount", eventCount);
            request.setAttribute("courseCount", courseCount);
            request.setAttribute("todayEventCount", todayEventCount);
            
            // Truyền phần trăm tăng trưởng
            request.setAttribute("userPercentChange", userPercentChange);
            request.setAttribute("calendarPercentChange", calendarPercentChange);
            request.setAttribute("eventPercentChange", eventPercentChange);
            request.setAttribute("coursePercentChange", coursePercentChange);
            
            request.setAttribute("userList", userList);
            request.setAttribute("calendarList", calendarList);
            request.setAttribute("eventList", eventList);
            request.setAttribute("courseList", courseList);

            // Số sự kiện hôm nay đã có: todayEventCount

            // Tính tổng doanh thu từ đơn hàng đã hoàn thành
            double totalRevenue = 0.0;
            for (Orders order : allOrders) {
                if ("Completed".equals(order.getStatus())) {
                    totalRevenue += order.getTotalAmount();
                }
            }
            request.setAttribute("totalRevenue", String.format("%,.0f VND", totalRevenue));

            // Tính % tăng trưởng doanh thu tháng này so với tháng trước
            java.util.Calendar calNow = java.util.Calendar.getInstance();
            int currentMonth = calNow.get(java.util.Calendar.MONTH) + 1;
            int lastMonth = currentMonth - 1;
            int lastYear = currentYear;
            if (lastMonth == 0) {
                lastMonth = 12;
                lastYear = currentYear - 1;
            }
            double revenueThisMonth = 0.0;
            double revenueLastMonth = 0.0;
            for (Orders order : allOrders) {
                if (order.getPaymentTime() != null && "Completed".equals(order.getStatus())) {
                    calNow.setTime(order.getPaymentTime());
                    int y = calNow.get(java.util.Calendar.YEAR);
                    int m = calNow.get(java.util.Calendar.MONTH) + 1;
                    if (y == currentYear && m == currentMonth) revenueThisMonth += order.getTotalAmount();
                    if (y == lastYear && m == lastMonth) revenueLastMonth += order.getTotalAmount();
                }
            }
            double revenuePercentChange = 0.0;
            if (revenueLastMonth > 0) {
                revenuePercentChange = ((revenueThisMonth - revenueLastMonth) / revenueLastMonth) * 100.0;
            } else {
                revenuePercentChange = revenueThisMonth > 0 ? 100.0 : 0.0;
            }
            request.setAttribute("revenuePercentChange", revenuePercentChange);

            // Lấy 5 người dùng mới nhất (an toàn null)
            List<User> newUserList = new ArrayList<>(userList);
            newUserList.sort((a, b) -> {
                Date d1 = a.getCreatedAt();
                Date d2 = b.getCreatedAt();
                if (d1 == null && d2 == null) return 0;
                if (d1 == null) return 1;
                if (d2 == null) return -1;
                return d2.compareTo(d1);
            });
            if (newUserList.size() > 5) newUserList = newUserList.subList(0, 5);
            request.setAttribute("newUserList", newUserList);

            // Lấy 5 lịch mới nhất (an toàn null)
            List<Calendar> newCalendarList = new ArrayList<>(calendarList);
            newCalendarList.sort((a, b) -> {
                Date d1 = a.getCreatedAt();
                Date d2 = b.getCreatedAt();
                if (d1 == null && d2 == null) return 0;
                if (d1 == null) return 1;
                if (d2 == null) return -1;
                return d2.compareTo(d1);
            });
            if (newCalendarList.size() > 5) newCalendarList = newCalendarList.subList(0, 5);
            request.setAttribute("newCalendarList", newCalendarList);

            // Lấy 5 khóa học mới nhất (an toàn null)
            List<Course> newCourseList = new ArrayList<>(courseList);
            newCourseList.sort((a, b) -> {
                Date d1 = a.getCreatedAt();
                Date d2 = b.getCreatedAt();
                if (d1 == null && d2 == null) return 0;
                if (d1 == null) return 1;
                if (d2 == null) return -1;
                return d2.compareTo(d1);
            });
            if (newCourseList.size() > 5) newCourseList = newCourseList.subList(0, 5);
            request.setAttribute("newCourseList", newCourseList);

            // 10. Forward đến trang admin
            request.getRequestDispatcher("/views/admin/base/admin.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log lỗi
            System.err.println("Error in AdminServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Redirect đến trang lỗi hoặc hiển thị thông báo
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu dashboard: " + e.getMessage());
            request.getRequestDispatcher("/views/error/error.jsp").forward(request, response);
        }
    }

    /**
     * Tính toán phần trăm tăng trưởng so với tháng trước
     */
    private double calculatePercentChange(String type) {
        try {
            // Lấy tháng hiện tại và tháng trước
            java.util.Calendar cal = java.util.Calendar.getInstance();
            int currentYear = cal.get(java.util.Calendar.YEAR);
            int currentMonth = cal.get(java.util.Calendar.MONTH) + 1; // Tháng hiện tại

            // Tháng trước
            int lastMonth = currentMonth - 1;
            int lastYear = currentYear;
            if (lastMonth == 0) {
                lastMonth = 12;
                lastYear = currentYear - 1;
            }

            int countThisMonth = 0;
            int countLastMonth = 0;

            switch (type) {
                case "user":
                    countThisMonth = userService.countUsersByMonth(currentYear, currentMonth);
                    countLastMonth = userService.countUsersByMonth(lastYear, lastMonth);
                    break;
                case "calendar":
                    countThisMonth = calendarService.countCalendarsByMonth(currentYear, currentMonth);
                    countLastMonth = calendarService.countCalendarsByMonth(lastYear, lastMonth);
                    break;
                case "event":
                    countThisMonth = eventService.countEventsByMonth(currentYear, currentMonth);
                    countLastMonth = eventService.countEventsByMonth(lastYear, lastMonth);
                    break;
                case "course":
                    countThisMonth = courseService.countCoursesByMonth(currentYear, currentMonth);
                    countLastMonth = courseService.countCoursesByMonth(lastYear, lastMonth);
                    break;
            }

            // Tính phần trăm
            if (countLastMonth > 0) {
                return ((double) (countThisMonth - countLastMonth) / countLastMonth) * 100;
            } else {
                return countThisMonth > 0 ? 100.0 : 0.0; // Nếu tháng trước = 0, tháng này > 0 thì tăng 100%
            }
        } catch (Exception e) {
            System.err.println("Error calculating percent change for " + type + ": " + e.getMessage());
            return 0.0;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}