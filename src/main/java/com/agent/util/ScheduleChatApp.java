/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.util;

import com.agent.service.ScheduleAIAgent;
import java.util.Scanner;

/**
 *
 * @author Admin
 */
public class ScheduleChatApp {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        ScheduleAIAgent agent = new ScheduleAIAgent();

        System.out.println("=== AI QUẢN LÝ LỊCH TRÌNH THÔNG MINH ===");
        System.out.println("Nhập 'bye', 'tạm biệt', 'kết thúc' để kết thúc cuộc trò chuyện\n");

        System.out.println("AI Agent: " + agent.getGreeting());
        System.out.println();

        while (true) {
            System.out.print("Bạn: ");
            String userInput = scanner.nextLine().trim();

            if (agent.shouldEndConversation(userInput)) {
                System.out.println("\nAI Agent: Cảm ơn bạn đã sử dụng dịch vụ quản lý lịch trình. Chúc bạn có một ngày hiệu quả!");

                System.out.println("\n=== TÓM TẮT CUỘC TRÒ CHUYỆN ===");
                System.out.println(agent.getConversationSummary());
                break;
            }

            if (userInput.isEmpty()) {
                continue;
            }

            System.out.print("AI Agent đang phân tích");
            for (int i = 0; i < 3; i++) {
                try {
                    Thread.sleep(500);
                    System.out.print(".");
                } catch (InterruptedException e) {
                    break;
                }
            }
            System.out.println();

            String aiResponse = agent.processUserInput(userInput);
            System.out.println("AI Agent: " + aiResponse);
            System.out.println();
        }

        scanner.close();
        System.out.println("Cuộc trò chuyện đã được lưu vào file schedule_responses.xlsx");
    }
}

/**
 * Example usage class demonstrating the programmatic approach
 */
class ProgrammaticScheduleConsultation {

    public static void demonstrateUsage() {
        System.out.println("=== DEMO SỬ DỤNG LỊCH TRÌNH PROGRAMMATIC ===\n");

        ScheduleAIAgent agent = new ScheduleAIAgent();

        String[] customerQuestions = {
                "Tôi cần lập lịch học tiếng Anh",
                "Thời gian từ 8h đến 10h sáng thứ 2 hàng tuần",
                "Tôi cũng có họp với team vào chiều thứ 3",
                "Bạn có thể tối ưu lịch trình cho tôi không?"
        };

        System.out.println("AI Agent: " + agent.getGreeting());
        System.out.println();

        for (String question : customerQuestions) {
            System.out.println("Người dùng: " + question);
            String response = agent.processUserInput(question);
            System.out.println("AI Agent: " + response);
            System.out.println();
        }

        System.out.println("=== TÓM TẮT ===");
        System.out.println(agent.getConversationSummary());
    }

    public static void main(String[] args) {

        demonstrateUsage();
    }
}