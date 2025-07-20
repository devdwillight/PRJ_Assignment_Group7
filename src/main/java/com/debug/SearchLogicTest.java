package com.debug;

import com.dao.User.UserDAO;
import com.model.User;
import java.util.List;

/**
 * Test class để kiểm tra logic search
 */
public class SearchLogicTest {
    
    public static void main(String[] args) {
        System.out.println("=== Testing Search Logic ===");
        
        UserDAO userDAO = new UserDAO();
        
        try {
            // Test 1: Tất cả users
            System.out.println("\n1. Testing: All users (no filters)");
            List<User> allUsers = userDAO.searchUsers(null, null, null);
            System.out.println("Result: " + (allUsers != null ? allUsers.size() : "null") + " users");
            
            // Test 2: Chỉ active users
            System.out.println("\n2. Testing: Only active users");
            List<User> activeUsers = userDAO.searchUsers(null, null, "active");
            System.out.println("Result: " + (activeUsers != null ? activeUsers.size() : "null") + " users");
            
            // Test 3: Chỉ inactive users
            System.out.println("\n3. Testing: Only inactive users");
            List<User> inactiveUsers = userDAO.searchUsers(null, null, "inactive");
            System.out.println("Result: " + (inactiveUsers != null ? inactiveUsers.size() : "null") + " users");
            
            // Test 4: Status = "" (empty string - should show all)
            System.out.println("\n4. Testing: Status = empty string (should show all)");
            List<User> emptyStatusUsers = userDAO.searchUsers(null, null, "");
            System.out.println("Result: " + (emptyStatusUsers != null ? emptyStatusUsers.size() : "null") + " users");
            
            // Test 5: Verify logic
            System.out.println("\n5. Logic verification:");
            System.out.println("All users count: " + (allUsers != null ? allUsers.size() : 0));
            System.out.println("Active users count: " + (activeUsers != null ? activeUsers.size() : 0));
            System.out.println("Inactive users count: " + (inactiveUsers != null ? inactiveUsers.size() : 0));
            System.out.println("Empty status count: " + (emptyStatusUsers != null ? emptyStatusUsers.size() : 0));
            
            if (allUsers != null && activeUsers != null && inactiveUsers != null && emptyStatusUsers != null) {
                boolean logicCorrect = (allUsers.size() == activeUsers.size() + inactiveUsers.size()) &&
                                      (allUsers.size() == emptyStatusUsers.size());
                System.out.println("Logic correct: " + logicCorrect);
                System.out.println("All = Active + Inactive: " + (allUsers.size() == activeUsers.size() + inactiveUsers.size()));
                System.out.println("All = Empty Status: " + (allUsers.size() == emptyStatusUsers.size()));
            }
            
        } catch (Exception e) {
            System.err.println("Error occurred:");
            e.printStackTrace();
        }
    }
} 