<%-- 
    Document   : siderAgent
    Created on : Jul 21, 2025, 1:18:19 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Sidebar Chatbox Agent -->
<div class="flex flex-col h-full">
    <!-- Header -->
    <div class="flex items-center justify-between px-4 py-3 border-b bg-blue-500 text-white">
        <span class="font-semibold text-lg">Chat với Agent</span>
        <!-- Nút đóng, bạn có thể điều khiển bằng JS nếu muốn -->
        <button id="closeChatboxBtn" class="text-white hover:text-gray-200 text-xl focus:outline-none" title="Đóng">
            <i class="fas fa-times"></i>
        </button>
    </div>
    <!-- Nội dung chat -->
    <div class="flex-1 overflow-y-auto p-4 bg-gray-50" id="chatContent">
        <!-- Tin nhắn sẽ được render ở đây -->
        <div class="text-gray-400 text-center mt-8">Chào bạn! Hãy bắt đầu trò chuyện với Agent.</div>
    </div>
    <!-- Ô nhập tin nhắn -->
    <form class="flex items-center border-t p-2 bg-white" id="chatForm" autocomplete="off">
        <input
            type="text"
            id="chatInput"
            class="flex-1 px-3 py-2 border rounded-full focus:outline-none focus:ring-2 focus:ring-blue-400"
            placeholder="Nhập tin nhắn..."
        />
        <button
            type="submit"
            class="ml-2 px-4 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600 transition-colors"
        >
            <i class="fas fa-paper-plane"></i>
        </button>
    </form>
</div>
