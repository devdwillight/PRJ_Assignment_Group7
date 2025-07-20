package com.debug;

import com.service.Order.OrderService;
import com.model.Orders;
import java.util.List;

public class PaymentMethodTest {
    
    public static void main(String[] args) {
        System.out.println("=== 🧪 TEST PAYMENT METHOD SEARCH ===");
        
        OrderService orderService = new OrderService();
        
        // Test 1: Lấy tất cả đơn hàng
        List<Orders> allOrders = orderService.getAllOrder();
        System.out.println("📊 Tổng số đơn hàng: " + allOrders.size());
        
        // Test 2: Phân tích payment methods
        System.out.println("\n💳 Phân tích phương thức thanh toán:");
        for (Orders order : allOrders) {
            System.out.println("  - Order ID: " + order.getIdOrder() + 
                             ", Payment Method: '" + order.getPaymentMethod() + "'");
        }
        
        // Test 3: Test tìm kiếm theo từng payment method
        System.out.println("\n🔍 Test tìm kiếm theo payment method:");
        
        String[] paymentMethods = {"Credit Card", "PayPal", "Bank Transfer"};
        for (String method : paymentMethods) {
            List<Orders> orders = orderService.getByPaymentMethod(method);
            System.out.println("  - '" + method + "': " + 
                             (orders != null ? orders.size() : "NULL") + " đơn hàng");
            
            if (orders != null && !orders.isEmpty()) {
                for (Orders order : orders) {
                    System.out.println("    * Order ID: " + order.getIdOrder() + 
                                     ", Payment: '" + order.getPaymentMethod() + "'");
                }
            }
        }
        
        // Test 4: Test với giá trị không tồn tại
        System.out.println("\n❌ Test với giá trị không tồn tại:");
        List<Orders> nonExistent = orderService.getByPaymentMethod("NonExistent");
        System.out.println("  - 'NonExistent': " + 
                         (nonExistent != null ? nonExistent.size() : "NULL") + " đơn hàng");
        
        // Test 5: Test với null
        System.out.println("\n⚠️ Test với null:");
        List<Orders> nullTest = orderService.getByPaymentMethod(null);
        System.out.println("  - null: " + 
                         (nullTest != null ? nullTest.size() : "NULL") + " đơn hàng");
        
        System.out.println("\n=== ✅ TEST COMPLETED ===");
    }
} 