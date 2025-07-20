package com.debug;

import com.service.Order.OrderService;
import com.model.Orders;
import java.util.List;

public class OrderStatusTest {
    
    public static void main(String[] args) {
        System.out.println("=== 🧪 TEST ORDER STATUS ===");
        
        OrderService orderService = new OrderService();
        
        // Test 1: Kiểm tra tất cả đơn hàng
        List<Orders> allOrders = orderService.getAllOrder();
        System.out.println("📊 Tổng số đơn hàng: " + allOrders.size());
        
        // Test 2: Phân tích trạng thái
        int processingCount = 0;
        int completedCount = 0;
        int failedCount = 0;
        int nullCount = 0;
        
        for (Orders order : allOrders) {
            String status = order.getStatus();
            if (status == null) {
                nullCount++;
                System.out.println("❌ Order ID " + order.getIdOrder() + ": status = NULL");
            } else if (status.trim().isEmpty()) {
                nullCount++;
                System.out.println("❌ Order ID " + order.getIdOrder() + ": status = EMPTY");
            } else {
                switch (status.trim()) {
                    case "Processing":
                        processingCount++;
                        break;
                    case "Completed":
                        completedCount++;
                        break;
                    case "Failed":
                        failedCount++;
                        break;
                    default:
                        System.out.println("⚠️ Order ID " + order.getIdOrder() + ": status = '" + status + "' (UNKNOWN)");
                        break;
                }
            }
        }
        
        System.out.println("\n📈 Thống kê trạng thái:");
        System.out.println("  - Processing: " + processingCount);
        System.out.println("  - Completed: " + completedCount);
        System.out.println("  - Failed: " + failedCount);
        System.out.println("  - NULL/Empty: " + nullCount);
        
        // Test 3: Test lọc theo trạng thái
        System.out.println("\n🔍 Test lọc theo trạng thái:");
        testFilterByStatus(orderService, "Processing");
        testFilterByStatus(orderService, "Completed");
        testFilterByStatus(orderService, "Failed");
        
        System.out.println("\n=== ✅ TEST COMPLETED ===");
    }
    
    private static void testFilterByStatus(OrderService orderService, String status) {
        List<Orders> orders = orderService.getByStatus(status);
        System.out.println("  - Status '" + status + "': " + 
                         (orders != null ? orders.size() : "NULL") + " đơn hàng");
        
        if (orders != null && !orders.isEmpty()) {
            for (Orders order : orders) {
                System.out.println("    * Order ID: " + order.getIdOrder() + 
                                 ", Status: '" + order.getStatus() + "'");
            }
        }
    }
} 