<%-- 
    Document   : siderAgent
    Created on : Jul 21, 2025, 1:18:19 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;600&family=Montserrat:wght@500;700&display=swap" rel="stylesheet">
<style>
    html, body {
        height: 100%;
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    #chatbotContainer, .chatbot-container, .modern-chatbot {
        position: fixed;
        right: 0;
        bottom: 0;
        top: auto;
        width: 340px;
        max-width: 98vw;
        height: 100vh;
        max-height: 100vh;
        margin: 0;
        z-index: 1000;
        box-sizing: border-box;
        background: #f6f8fc;
        border-radius: 0;
        border: none;
        display: flex;
        flex-direction: column;
    }
    body, .modern-chatbot {
        font-family: 'Quicksand', 'Montserrat', Arial, sans-serif;
        background: #f6f8fc;
    }
    .flex-between {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .gradient-avatar {
        background: linear-gradient(135deg, #ffb86c 0%, #8be9fd 100%);
        color: #fff;
        box-shadow: 0 2px 8px rgba(139,233,253,0.10);
        border: 2px solid #fff;
        transition: transform 0.2s;
        width: 38px;
        height: 38px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        font-size: 1.3rem;
    }
    .gradient-avatar:hover {
        transform: scale(1.07) rotate(-6deg);
    }
    .chatbot-title {
        font-size: 1.08rem;
        font-weight: 700;
        margin-bottom: 0;
        letter-spacing: 0.2px;
        color: #6c63ff;
        text-shadow: 0 1px 4px rgba(60,60,120,0.10);
        font-family: 'Montserrat', Arial, sans-serif;
    }
    .chatbot-status.online {
        color: #00e676;
        font-weight: 600;
        font-size: 0.92rem;
    }
    .chatbot-header {
        background: #fff;
        padding: 8px 12px 6px 10px;
        border-bottom: 1px solid #e0e0e0;
        min-height: 38px;
    }
    .modern-welcome {
        background: linear-gradient(90deg, #e0c3fc 0%, #8ec5fc 100%);
        border-radius: 12px;
        margin: 8px 6px 6px 6px;
        padding: 8px 6px 6px 6px;
        box-shadow: 0 1px 4px rgba(139,233,253,0.07);
        font-size: 0.97rem;
        text-align: center;
        transition: max-height 0.3s, opacity 0.3s;
    }
    .welcome-title {
        font-size: 1rem;
        color: #6c63ff;
        font-weight: 700;
        margin-bottom: 2px;
        font-family: 'Montserrat', Arial, sans-serif;
    }
    .welcome-desc {
        font-size: 0.89rem;
        color: #444;
        margin-bottom: 4px;
    }
    .schedule-types {
        gap: 2px;
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
    }
    .schedule-type {
        font-size: 0.85rem;
        padding: 2px 8px;
        border-radius: 8px;
        background: linear-gradient(90deg, #fcb69f 0%, #a1c4fd 100%);
        color: #fff;
        font-weight: 600;
        margin: 1px 1px;
        box-shadow: 0 1px 2px rgba(139,233,253,0.07);
        font-family: 'Quicksand', Arial, sans-serif;
    }
    .chatbot-body {
        background: #f6f8fc;
        display: flex;
        flex-direction: column;
        flex: 1 1 0;
        height: 100%;
        max-height: 100%;
        overflow: hidden;
        padding: 0;
    }
    .modern-messages {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 1px 4px rgba(139,233,253,0.07);
        margin: 0 6px 6px 6px;
        padding: 8px 6px 6px 6px;
        flex: 1 1 0;
        min-height: 0;
        max-height: 100%;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        gap: 7px;
        scrollbar-width: thin;
    }
    .message {
        display: flex;
        align-items: flex-end;
        margin-bottom: 2px;
        animation: fadeIn 0.3s;
    }
    .message.user {
        justify-content: flex-end;
    }
    .message.bot {
        justify-content: flex-start;
    }
    .message-content {
        max-width: 75%;
        padding: 8px 13px;
        border-radius: 16px 16px 5px 16px;
        font-size: 0.97rem;
        line-height: 1.5;
        box-shadow: 0 1px 3px rgba(139,233,253,0.07);
        word-break: break-word;
        font-family: 'Quicksand', Arial, sans-serif;
        transition: background 0.2s;
    }
    .message.user .message-content {
        background: linear-gradient(90deg, #a1c4fd 0%, #c2e9fb 100%);
        color: #222;
        border-bottom-right-radius: 4px;
    }
    .message.bot .message-content {
        background: linear-gradient(90deg, #fcb69f 0%, #ffdde1 100%);
        color: #6c63ff;
        border-bottom-left-radius: 4px;
    }
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    .modern-typing {
        margin: 0 6px 6px 6px;
    }
    .typing-dot {
        background: #6c63ff;
        animation: blink 1s infinite alternate;
    }
    @keyframes blink {
        from {
            opacity: 0.2;
        }
        to {
            opacity: 1;
        }
    }
    .modern-actions {
        margin: 0 6px 6px 6px;
        display: flex;
        gap: 6px;
    }
    .action-button {
        background: linear-gradient(90deg, #a1c4fd 0%, #fcb69f 100%);
        color: #fff;
        border-radius: 9px;
        font-size: 0.97rem;
        font-weight: 700;
        padding: 7px 0;
        border: none;
        box-shadow: 0 1px 2px rgba(139,233,253,0.07);
        transition: background 0.2s, color 0.2s, box-shadow 0.2s;
        cursor: pointer;
        font-family: 'Montserrat', Arial, sans-serif;
    }
    .action-button.primary {
        background: linear-gradient(90deg, #ffb86c 0%, #6c63ff 100%);
        color: #fff;
    }
    .action-button:hover {
        background: linear-gradient(90deg, #fcb69f 0%, #a1c4fd 100%);
        color: #fff;
        box-shadow: 0 2px 6px rgba(139,233,253,0.13);
    }
    .action-button.primary:hover {
        background: linear-gradient(90deg, #6c63ff 0%, #ffb86c 100%);
        color: #fff;
    }
    .modern-input {
        background: #f8fafc;
        border-top: 1px solid #e0e0e0;
        padding: 7px 10px;
        display: flex;
        align-items: center;
        gap: 7px;
    }
    .chat-input {
        background: #fff;
        border-radius: 18px;
        border: 1.5px solid #a1c4fd;
        padding: 8px 12px;
        font-size: 0.97rem;
        flex: 1;
        outline: none;
        transition: border-color 0.2s;
        font-family: 'Quicksand', Arial, sans-serif;
    }
    .chat-input:focus {
        border-color: #6c63ff;
    }
    .chat-send-btn {
        background: linear-gradient(135deg, #ffb86c 0%, #6c63ff 100%);
        color: #fff;
        border: none;
        border-radius: 50%;
        width: 36px;
        height: 36px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.1rem;
        cursor: pointer;
        box-shadow: 0 2px 6px rgba(139,233,253,0.10);
        transition: background 0.2s, box-shadow 0.2s;
    }
    .chat-send-btn:hover {
        background: linear-gradient(135deg, #6c63ff 0%, #ffb86c 100%);
        box-shadow: 0 4px 12px rgba(139,233,253,0.13);
    }
    @media (max-width: 600px) {
        #chatbotContainer, .chatbot-container, .modern-chatbot {
            right: 0;
            left: 0;
            bottom: 0;
            width: 100vw;
            border-radius: 0;
            max-width: 100vw;
            height: 100vh;
            max-height: 100vh;
        }
        .chatbot-body {
            height: 100%;
            max-height: 100%;
        }
        .modern-input {
            padding: 6px;
            border-top: 1px solid #ddd;
            background-color: #fff;
        }
    }
</style>
<!-- Sidebar Chatbox Agent -->
<div class="chatbot-container modern-chatbot" id="chatbotContainer">
    <div class="chatbot-header flex-between" id="chatbotToggle">
        <div class="chatbot-avatar gradient-avatar">
            <i class="fas fa-robot"></i>
        </div>
        <div class="chatbot-info">
            <h4 class="chatbot-title">Calendar Assistant</h4>
            <span class="chatbot-status online">
                <i class="fas fa-circle"></i> Online
            </span>
        </div>
    </div>
    <div class="chatbot-body" id="chatbotBody">
        <!-- Welcome/Intro -->
        <div class="chat-welcome modern-welcome">
            <h2 class="welcome-title">📅 AI Quản lý Lịch trình Thông minh</h2>
            <p class="welcome-desc">Tư vấn & tối ưu lịch cá nhân</p>
            <div class="schedule-types">
                <span class="schedule-type">📚 Học tập</span>
                <span class="schedule-type">💼 Công việc</span>
                <span class="schedule-type">🎉 Sự kiện</span>
                <span class="schedule-type">✈️ Du lịch</span>
                <span class="schedule-type">👤 Cá nhân</span>
            </div>
        </div>
        <!-- Chat messages -->
        <div class="chat-messages modern-messages scrollbar" id="chatMessages">
            <!-- Tin nhắn sẽ hiển thị ở đây -->
        </div>
        <!-- Typing indicator -->
        <div class="typing-indicator modern-typing" id="typingIndicator">
            <div class="typing-dots">
                <div class="typing-dot"></div>
                <div class="typing-dot"></div>
                <div class="typing-dot"></div>
            </div>
        </div>
        <!-- Action buttons -->
        <div class="action-buttons modern-actions">
            <button class="action-button primary" onclick="getCurrentSchedule()">📋 Xem lịch</button>
            <button class="action-button" onclick="getSummary()">📊 Tóm tắt</button>
            <button class="action-button" onclick="clearChat()">🔄 Mới</button>
        </div>
    </div>
    <div class="chat-input-container modern-input">
        <input type="text" id="chatInput" class="chat-input" placeholder="Nhập tin nhắn...">
        <button class="chat-send-btn" id="chatSendBtn" title="Gửi">
            <i class="fas fa-paper-plane"></i>
        </button>
    </div>
    <script>
        let sessionId = localStorage.getItem("sessionId");
        if (!sessionId) {
            sessionId = 'SCHEDULE_SESSION_' + Date.now();
            localStorage.setItem("sessionId", sessionId);
        }

        document.addEventListener('DOMContentLoaded', function () {
            // Gọi lời chào khi load xong
            getGreeting();

            const sendButton = document.getElementById('chatSendBtn');
            const input = document.getElementById('chatInput');

            // Gửi khi bấm nút
            sendButton.addEventListener('click', sendMessage);

            // Gửi khi nhấn Enter
            input.addEventListener('keypress', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    sendMessage();
                }
            });
            loadChatHistory(sessionId);
        });
        async function loadChatHistory(sessionId) {
            const container = document.getElementById('chatMessages');
            container.innerHTML = '';

            try {
                const basePath = window.location.pathname.replace(/\/[^/]*$/, '');
                const url = basePath + "/api/chat_history?sessionId=" + encodeURIComponent(sessionId);

                const response = await fetch(url);
                const messages = await response.json();

                messages.forEach(msg => {
                    if (msg.userMessage)
                        displayMessage('user', msg.userMessage);
                    if (msg.aiResponse)
                        displayMessage('bot', msg.aiResponse);
                });
            } catch (error) {
                console.error("Lỗi khi tải lịch sử chat:", error);
                container.innerHTML = '<p class="error">Không thể tải lịch sử trò chuyện.</p>';
            }
        }
        async function getGreeting() {
            try {
                const response = await fetch(window.location.pathname.replace(/\/[^/]*$/, '') + '/api/greeting', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({sessionId: sessionId})
                });

                const data = await response.json();
                displayMessage('bot', data.message);
            } catch (error) {
                displayMessage('bot', '🤖 Xin chào! Tôi là AI Assistant quản lý lịch trình thông minh.\n\nTôi có thể giúp bạn:\n✅ Tạo lịch học tập, công việc, sự kiện\n✅ Tối ưu hóa thời gian\n✅ Đưa ra lời khuyên quản lý thời gian\n\nHãy chia sẻ kế hoạch của bạn để bắt đầu!');
            }
        }

        async function sendMessage() {
            const input = document.getElementById('chatInput');
            const sendButton = document.getElementById('chatSendBtn');
            const message = input.value.trim();

            if (!message)
                return;

            displayMessage('user', message);
            input.value = '';
            showTyping(true);
            sendButton.disabled = true;

            try {
                const basePath = window.location.origin + window.location.pathname.split("/").slice(0, 2).join("/");
                const response = await fetch(basePath + '/api/chat', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({
                        message: message,
                        sessionId: sessionId
                    })
                });

                const data = await response.json();

                setTimeout(() => {
                    showTyping(false);
                    displayMessage('bot', data.response);
                    sendButton.disabled = false;
                }, 1200);

            } catch (error) {
                showTyping(false);
                displayMessage('bot', 'Xin lỗi, tôi gặp sự cố kỹ thuật. Bạn có thể thử lại không?');
                sendButton.disabled = false;
            }
        }

        async function getCurrentSchedule() {
            showTyping(true);
            try {
                const response = await fetch(window.location.pathname.replace(/\/[^/]*$/, '') + '/api/schedule', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({sessionId: sessionId})
                });

                const data = await response.json();
                showTyping(false);
                displayMessage('bot', data.schedule);
            } catch (error) {
                showTyping(false);
                displayMessage('bot', 'Không thể tải lịch trình hiện tại.');
            }
        }

        async function getSummary() {
            showTyping(true);
            try {
                const response = await fetch(window.location.pathname.replace(/\/[^/]*$/, '') + '/api/summary', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({sessionId: sessionId})
                });

                const data = await response.json();
                showTyping(false);
                displayMessage('bot', '📋 <strong>Tóm tắt cuộc trò chuyện:</strong><br><br>' + data.summary);
            } catch (error) {
                showTyping(false);
                displayMessage('bot', 'Không thể tạo tóm tắt cuộc trò chuyện.');
            }
        }

        async function clearChat() {
            const oldSessionId = sessionId;

            // Gửi request xóa lịch sử trên server
            const basePath = window.location.pathname.replace(/\/[^/]*$/, '');
            const url = basePath + "/api/delete_chat_history?sessionId=" + encodeURIComponent(oldSessionId);
            await fetch(url, {method: 'POST'});

            // Reset giao diện và tạo session mới
            document.getElementById('chatMessages').innerHTML = '';
            sessionId = 'SCHEDULE_SESSION_' + Date.now();
            localStorage.setItem("sessionId", sessionId); // cập nhật lại sessionId
            getGreeting();
        }


        function displayMessage(sender, message) {
            const chatMessages = document.getElementById('chatMessages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${sender}`;

            const avatar = document.createElement('div');
            avatar.className = 'message-avatar';
            avatar.textContent = sender === 'user' ? 'U' : 'AI';

            const content = document.createElement('div');
            content.className = 'message-content';
            content.innerHTML = formatMessage(message);

            if (sender === 'user') {
                messageDiv.appendChild(content);
                messageDiv.appendChild(avatar);
            } else {
                messageDiv.appendChild(avatar);
                messageDiv.appendChild(content);
            }

            chatMessages.appendChild(messageDiv);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }



        function formatMessage(message) {
            return message
                    .replace(/\\n/g, '\n')
                    .replace(/\n/g, '<br>')
                    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
                    .replace(/\*(.*?)\*/g, '<em>$1</em>')
                    .replace(/✅(.*?)(?=\n|$)/g, '<div class="schedule-item">✅$1</div>')
                    .replace(/📅(.*?)(?=\n|$)/g, '<div class="schedule-item">📅$1</div>')
                    .replace(/\[(.*?)\]/g, '<span class="schedule-type-badge">$1</span>');
        }

        function showTyping(show) {
            const typingIndicator = document.getElementById('typingIndicator');
            typingIndicator.style.display = show ? 'flex' : 'none';

            if (show) {
                const chatMessages = document.getElementById('chatMessages');
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }
        }
    </script>
</div>