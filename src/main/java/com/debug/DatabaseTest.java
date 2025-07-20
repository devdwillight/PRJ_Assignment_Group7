package com.debug;

import com.dao.User.UserDAO;
import com.model.User;
import com.service.User.UserService;
import java.util.List;

/**
 * Debug class to test database connection and search functionality
 */
public class DatabaseTest {
    
    public static void main(String[] args) {
        System.out.println("=== Database Connection Test ===");
        
        try {
            // Test UserService
            UserService userService = new UserService();
            
            // Test 1: Get all users
            System.out.println("\n1. Testing getAllUsers()...");
            List<User> allUsers = userService.getAllUsers();
            System.out.println("Total users found: " + (allUsers != null ? allUsers.size() : "null"));
            
            if (allUsers != null && !allUsers.isEmpty()) {
                System.out.println("First user: " + allUsers.get(0).getFirstName() + " " + allUsers.get(0).getLastName());
            }
            
            // Test 2: Search by name
            System.out.println("\n2. Testing searchUsers() with name...");
            List<User> nameResults = userService.searchUsers("Nguyen", null, null);
            System.out.println("Users with 'Nguyen' in name: " + (nameResults != null ? nameResults.size() : "null"));
            
            // Test 3: Search by email
            System.out.println("\n3. Testing searchUsers() with email...");
            List<User> emailResults = userService.searchUsers(null, "gmail.com", null);
            System.out.println("Users with 'gmail.com' in email: " + (emailResults != null ? emailResults.size() : "null"));
            
            // Test 4: Search by status
            System.out.println("\n4. Testing searchUsers() with status...");
            List<User> activeResults = userService.searchUsers(null, null, "active");
            System.out.println("Active users: " + (activeResults != null ? activeResults.size() : "null"));
            
            List<User> inactiveResults = userService.searchUsers(null, null, "inactive");
            System.out.println("Inactive users: " + (inactiveResults != null ? inactiveResults.size() : "null"));
            
            // Test 4.1: Search with "all" status (empty string)
            System.out.println("\n4.1. Testing searchUsers() with 'all' status (empty string)...");
            List<User> allStatusResults = userService.searchUsers(null, null, "");
            System.out.println("All users (empty status): " + (allStatusResults != null ? allStatusResults.size() : "null"));
            
            // Test 4.2: Search with null status
            System.out.println("\n4.2. Testing searchUsers() with null status...");
            List<User> nullStatusResults = userService.searchUsers(null, null, null);
            System.out.println("All users (null status): " + (nullStatusResults != null ? nullStatusResults.size() : "null"));
            
            // Test 5: Combined search
            System.out.println("\n5. Testing combined search...");
            List<User> combinedResults = userService.searchUsers("Nguyen", "gmail.com", "active");
            System.out.println("Combined search results: " + (combinedResults != null ? combinedResults.size() : "null"));
            
            System.out.println("\n=== Test completed successfully ===");
            
        } catch (Exception e) {
            System.err.println("=== Error occurred ===");
            e.printStackTrace();
        }
    }
} 