package com.controller.admin;

import com.service.Order.OrderService;
import com.service.Course.CourseService;
import com.model.Orders;
import com.model.Course;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.math.BigDecimal;
import java.util.Calendar;

@WebServlet(name = "RevenueServlet", urlPatterns = {"/admin/revenue"})
public class RevenueServlet extends HttpServlet {

    private final OrderService orderService;
    private final CourseService courseService;

    public RevenueServlet() {
        this.orderService = new OrderService();
        this.courseService = new CourseService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy tham số tìm kiếm
            String period = request.getParameter("period"); // daily, weekly, monthly, yearly
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");
            
            if (period == null) {
                period = "monthly"; // Mặc định hiển thị theo tháng
            }
            
            // Tính toán doanh thu
            Map<String, Object> revenueData = calculateRevenue(period, dateFrom, dateTo);
            
            // Đặt dữ liệu vào request
            request.setAttribute("revenueData", revenueData);
            request.setAttribute("period", period);
            request.setAttribute("dateFrom", dateFrom);
            request.setAttribute("dateTo", dateTo);
            
            // Forward đến trang revenue.jsp
            request.getRequestDispatcher("/views/admin/revenue/revenue.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu doanh thu: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/revenue/revenue.jsp").forward(request, response);
        }
    }

    private Map<String, Object> calculateRevenue(String period, String dateFrom, String dateTo) {
        Map<String, Object> data = new HashMap<>();
        
        try {
            List<Orders> allOrders = orderService.getAllOrder();
            List<Course> allCourses = courseService.getAllCourses();
            

            
            // Tính tổng doanh thu
            BigDecimal totalRevenue = BigDecimal.ZERO;
            int totalOrders = 0;
            int completedOrders = 0;
            int processingOrders = 0;
            int failedOrders = 0;
            
            // Lọc đơn hàng theo thời gian nếu có
            List<Orders> filteredOrders = filterOrdersByDate(allOrders, dateFrom, dateTo);
            
            // Tạo danh sách đơn hàng đã hoàn thành để tính doanh thu
            List<Orders> completedOrdersList = new ArrayList<>();
            
            for (Orders order : filteredOrders) {
                totalOrders++;
                
                String status = order.getStatus();
                if (status != null) {
                    switch (status) {
                        case "Completed":
                            completedOrders++;
                            // Chỉ tính doanh thu từ đơn hàng đã hoàn thành
                            totalRevenue = totalRevenue.add(BigDecimal.valueOf(order.getTotalAmount()));
                            completedOrdersList.add(order);
                            break;
                        case "Processing":
                            processingOrders++;
                            break;
                        case "Failed":
                            failedOrders++;
                            break;
                    }
                }
            }
            

            
            // Tính doanh thu theo thời gian (chỉ từ đơn hàng đã hoàn thành)
            Map<String, BigDecimal> revenueByTime = calculateRevenueByTime(completedOrdersList, period);
            
            // Tính doanh thu theo phương thức thanh toán (chỉ từ đơn hàng đã hoàn thành)
            Map<String, BigDecimal> revenueByPaymentMethod = calculateRevenueByPaymentMethod(completedOrdersList);
            
            // Tính doanh thu theo khóa học (chỉ từ đơn hàng đã hoàn thành)
            Map<String, BigDecimal> revenueByCourse = calculateRevenueByCourse(completedOrdersList, allCourses);
            
            // Thống kê khóa học
            Map<String, Integer> courseStats = calculateCourseStats(allCourses);
            
            // Đặt dữ liệu vào map
            data.put("totalRevenue", totalRevenue);
            data.put("totalOrders", totalOrders);
            data.put("completedOrders", completedOrders);
            data.put("processingOrders", processingOrders);
            data.put("failedOrders", failedOrders);
            data.put("revenueByTime", revenueByTime);
            data.put("revenueByPaymentMethod", revenueByPaymentMethod);
            data.put("revenueByCourse", revenueByCourse);
            data.put("courseStats", courseStats);
            
            // Tính tỷ lệ hoàn thành
            double completionRate = totalOrders > 0 ? (double) completedOrders / totalOrders * 100 : 0;
            data.put("completionRate", completionRate);
            
            // Tính doanh thu trung bình mỗi đơn hàng
            BigDecimal avgOrderValue = totalOrders > 0 ? totalRevenue.divide(BigDecimal.valueOf(totalOrders), 2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO;
            data.put("avgOrderValue", avgOrderValue);
            
        } catch (Exception e) {
            e.printStackTrace();
            data.put("error", "Lỗi tính toán doanh thu: " + e.getMessage());
        }
        
        return data;
    }
    
    private List<Orders> filterOrdersByDate(List<Orders> orders, String dateFrom, String dateTo) {
        if (dateFrom == null && dateTo == null) {
            return orders;
        }
        
        List<Orders> filtered = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        try {
            Date fromDate = dateFrom != null ? sdf.parse(dateFrom) : null;
            Date toDate = dateTo != null ? sdf.parse(dateTo) : null;
            
            for (Orders order : orders) {
                if (order.getPaymentTime() != null) {
                    boolean include = true;
                    
                    if (fromDate != null && order.getPaymentTime().before(fromDate)) {
                        include = false;
                    }
                    
                    if (toDate != null && order.getPaymentTime().after(toDate)) {
                        include = false;
                    }
                    
                    if (include) {
                        filtered.add(order);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return filtered;
    }
    
    private Map<String, BigDecimal> calculateRevenueByTime(List<Orders> orders, String period) {
        Map<String, BigDecimal> revenueByTime = new LinkedHashMap<>();
        Calendar calendar = Calendar.getInstance();
        

        
        // Tạo khoảng thời gian đều đặn với format thống nhất
        switch (period) {
            case "daily":
                // Tạo 7 ngày gần nhất
                for (int i = 6; i >= 0; i--) {
                    calendar.add(Calendar.DAY_OF_YEAR, -i);
                    String timeKey = String.format("%02d/%02d", 
                        calendar.get(Calendar.DAY_OF_MONTH), 
                        calendar.get(Calendar.MONTH) + 1);
                    revenueByTime.put(timeKey, BigDecimal.ZERO);
                    calendar.add(Calendar.DAY_OF_YEAR, i); // Reset về ngày hiện tại
                }
                break;
            case "weekly":
                // Tạo 4 tuần gần nhất
                for (int i = 3; i >= 0; i--) {
                    calendar.add(Calendar.WEEK_OF_YEAR, -i);
                    int weekOfYear = calendar.get(Calendar.WEEK_OF_YEAR);
                    String timeKey = "Tuần " + weekOfYear;
                    revenueByTime.put(timeKey, BigDecimal.ZERO);
                    calendar.add(Calendar.WEEK_OF_YEAR, i); // Reset về tuần hiện tại
                }
                break;
            case "monthly":
                // Tạo 12 tháng gần nhất
                for (int i = 11; i >= 0; i--) {
                    calendar.add(Calendar.MONTH, -i);
                    String timeKey = String.format("%02d/%d", 
                        calendar.get(Calendar.MONTH) + 1, 
                        calendar.get(Calendar.YEAR));
                    revenueByTime.put(timeKey, BigDecimal.ZERO);
                    calendar.add(Calendar.MONTH, i); // Reset về tháng hiện tại
                }
                break;
            case "yearly":
                // Tạo 5 năm gần nhất
                for (int i = 4; i >= 0; i--) {
                    calendar.add(Calendar.YEAR, -i);
                    String timeKey = String.valueOf(calendar.get(Calendar.YEAR));
                    revenueByTime.put(timeKey, BigDecimal.ZERO);
                    calendar.add(Calendar.YEAR, i); // Reset về năm hiện tại
                }
                break;
            default:
                // Mặc định 12 tháng
                for (int i = 11; i >= 0; i--) {
                    calendar.add(Calendar.MONTH, -i);
                    String timeKey = String.format("%02d/%d", 
                        calendar.get(Calendar.MONTH) + 1, 
                        calendar.get(Calendar.YEAR));
                    revenueByTime.put(timeKey, BigDecimal.ZERO);
                    calendar.add(Calendar.MONTH, i);
                }
        }
        
        // Tính doanh thu theo thời gian với format tương ứng
        for (Orders order : orders) {
            if (order.getPaymentTime() != null) {
                Calendar orderCal = Calendar.getInstance();
                orderCal.setTime(order.getPaymentTime());
                String timeKey;
                
                switch (period) {
                    case "daily":
                        timeKey = String.format("%02d/%02d", 
                            orderCal.get(Calendar.DAY_OF_MONTH), 
                            orderCal.get(Calendar.MONTH) + 1);
                        break;
                    case "weekly":
                        timeKey = "Tuần " + orderCal.get(Calendar.WEEK_OF_YEAR);
                        break;
                    case "monthly":
                        timeKey = String.format("%02d/%d", 
                            orderCal.get(Calendar.MONTH) + 1, 
                            orderCal.get(Calendar.YEAR));
                        break;
                    case "yearly":
                        timeKey = String.valueOf(orderCal.get(Calendar.YEAR));
                        break;
                    default:
                        timeKey = String.format("%02d/%d", 
                            orderCal.get(Calendar.MONTH) + 1, 
                            orderCal.get(Calendar.YEAR));
                }
                
                if (revenueByTime.containsKey(timeKey)) {
                    revenueByTime.merge(timeKey, BigDecimal.valueOf(order.getTotalAmount()), BigDecimal::add);
                }
            }
        }
        
        return revenueByTime;
    }
    
    private Map<String, BigDecimal> calculateRevenueByPaymentMethod(List<Orders> orders) {
        Map<String, BigDecimal> revenueByPaymentMethod = new LinkedHashMap<>();
        
        for (Orders order : orders) {
            if (order.getPaymentMethod() != null) {
                String paymentMethod = order.getPaymentMethod();
                revenueByPaymentMethod.merge(paymentMethod, BigDecimal.valueOf(order.getTotalAmount()), BigDecimal::add);
            }
        }
        
        return revenueByPaymentMethod;
    }
    
    private Map<String, BigDecimal> calculateRevenueByCourse(List<Orders> orders, List<Course> courses) {
        Map<String, BigDecimal> revenueByCourse = new LinkedHashMap<>();
        
        // Tạo map course ID -> course name
        Map<Integer, String> courseMap = new HashMap<>();
        for (Course course : courses) {
            courseMap.put(course.getIdCourse(), course.getName());
        }
        
        // Tính doanh thu theo khóa học (giả sử mỗi order là 1 khóa học)
        for (Orders order : orders) {
            // Lấy tên khóa học từ user ID (giả sử)
            String courseName = "Khóa học #" + order.getIdOrder();
            revenueByCourse.merge(courseName, BigDecimal.valueOf(order.getTotalAmount()), BigDecimal::add);
        }
        
        // Sắp xếp theo doanh thu giảm dần và lấy top 10
        return revenueByCourse.entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByValue().reversed())
                .limit(10)
                .collect(LinkedHashMap::new, (map, entry) -> map.put(entry.getKey(), entry.getValue()), LinkedHashMap::putAll);
    }
    
    private Map<String, Integer> calculateCourseStats(List<Course> courses) {
        Map<String, Integer> stats = new LinkedHashMap<>();
        
        // Đếm khóa học theo category
        Map<String, Integer> categoryCount = new HashMap<>();
        for (Course course : courses) {
            String category = course.getCategory() != null ? course.getCategory() : "Chưa phân loại";
            categoryCount.merge(category, 1, Integer::sum);
        }
        
        // Sắp xếp theo số lượng giảm dần
        categoryCount.entrySet().stream()
                .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .forEach(entry -> stats.put(entry.getKey(), entry.getValue()));
        
        return stats;
    }
} 