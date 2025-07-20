package com.util;

public class StatusUtil {
    
    /**
     * Lấy CSS class cho trạng thái đơn hàng
     * @param status Trạng thái đơn hàng
     * @return CSS class tương ứng
     */
    public static String getStatusClass(String status) {
        if (status == null || status.trim().isEmpty()) {
            return "status-pending";
        }
        
        switch (status.trim()) {
            case "Processing":
                return "status-processing";
            case "Completed":
                return "status-delivered";
            case "Failed":
                return "status-cancelled";
            default:
                return "status-pending";
        }
    }
    
    /**
     * Lấy tên hiển thị cho trạng thái
     * @param status Trạng thái đơn hàng
     * @return Tên hiển thị
     */
    public static String getStatusDisplayName(String status) {
        if (status == null || status.trim().isEmpty()) {
            return "Chưa xác định";
        }
        
        switch (status.trim()) {
            case "Processing":
                return "Đang xử lý";
            case "Completed":
                return "Đã hoàn thành";
            case "Failed":
                return "Đã hủy";
            default:
                return "Chưa xác định";
        }
    }
} 