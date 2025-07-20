package com.debug;

import com.dao.User.UserDAO;
import com.model.User;
import java.util.List;

/**
 * Test class để kiểm tra tìm kiếm full name
 */
public class FullNameSearchTest {
    
    public static void main(String[] args) {
        System.out.println("=== Testing Full Name Search ===");
        
        UserDAO userDAO = new UserDAO();
        
        try {
            // Test 1: Tìm theo firstName
            System.out.println("\n1. Testing: Search by firstName only");
            List<User> firstNameResults = userDAO.searchUsers("Nguyen", null, null);
            System.out.println("Results for 'Nguyen': " + (firstNameResults != null ? firstNameResults.size() : "null") + " users");
            if (firstNameResults != null && !firstNameResults.isEmpty()) {
                for (User user : firstNameResults) {
                    System.out.println("  - " + user.getFirstName() + " " + user.getLastName());
                }
            }
            
            // Test 2: Tìm theo lastName
            System.out.println("\n2. Testing: Search by lastName only");
            List<User> lastNameResults = userDAO.searchUsers("Van", null, null);
            System.out.println("Results for 'Van': " + (lastNameResults != null ? lastNameResults.size() : "null") + " users");
            if (lastNameResults != null && !lastNameResults.isEmpty()) {
                for (User user : lastNameResults) {
                    System.out.println("  - " + user.getFirstName() + " " + user.getLastName());
                }
            }
            
            // Test 3: Tìm theo full name (firstName + lastName)
            System.out.println("\n3. Testing: Search by full name (firstName + lastName)");
            List<User> fullNameResults = userDAO.searchUsers("Nguyen Van", null, null);
            System.out.println("Results for 'Nguyen Van': " + (fullNameResults != null ? fullNameResults.size() : "null") + " users");
            if (fullNameResults != null && !fullNameResults.isEmpty()) {
                for (User user : fullNameResults) {
                    System.out.println("  - " + user.getFirstName() + " " + user.getLastName());
                }
            }
            
            // Test 4: Tìm theo full name (lastName + firstName)
            System.out.println("\n4. Testing: Search by full name (lastName + firstName)");
            List<User> reverseNameResults = userDAO.searchUsers("Van Nguyen", null, null);
            System.out.println("Results for 'Van Nguyen': " + (reverseNameResults != null ? reverseNameResults.size() : "null") + " users");
            if (reverseNameResults != null && !reverseNameResults.isEmpty()) {
                for (User user : reverseNameResults) {
                    System.out.println("  - " + user.getFirstName() + " " + user.getLastName());
                }
            }
            
            // Test 5: Tìm theo username
            System.out.println("\n5. Testing: Search by username");
            List<User> usernameResults = userDAO.searchUsers("admin", null, null);
            System.out.println("Results for 'admin': " + (usernameResults != null ? usernameResults.size() : "null") + " users");
            if (usernameResults != null && !usernameResults.isEmpty()) {
                for (User user : usernameResults) {
                    System.out.println("  - " + user.getUsername() + " (" + user.getFirstName() + " " + user.getLastName() + ")");
                }
            }
            
            // Test 6: Tìm theo partial name
            System.out.println("\n6. Testing: Search by partial name");
            List<User> partialResults = userDAO.searchUsers("Ng", null, null);
            System.out.println("Results for 'Ng': " + (partialResults != null ? partialResults.size() : "null") + " users");
            if (partialResults != null && !partialResults.isEmpty()) {
                for (User user : partialResults) {
                    System.out.println("  - " + user.getFirstName() + " " + user.getLastName());
                }
            }
            
            // Test 7: Hiển thị tất cả users để so sánh
            System.out.println("\n7. All users in database:");
            List<User> allUsers = userDAO.selectAllUsers();
            if (allUsers != null && !allUsers.isEmpty()) {
                for (User user : allUsers) {
                    System.out.println("  - ID: " + user.getIdUser() + 
                                     ", Username: " + user.getUsername() + 
                                     ", Name: " + user.getFirstName() + " " + user.getLastName() + 
                                     ", Email: " + user.getEmail());
                }
            } else {
                System.out.println("  No users found in database");
            }
            
        } catch (Exception e) {
            System.err.println("Error occurred:");
            e.printStackTrace();
        }
    }
} 