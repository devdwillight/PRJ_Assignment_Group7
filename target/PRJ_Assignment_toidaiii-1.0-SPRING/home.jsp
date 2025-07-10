<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Calendar - Employee Portal</title>
        <link rel="stylesheet" href="css/calendar.css">
        <link rel="stylesheet" href="css/chatBot.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    </head>
    <body>
        <div class="calendar-container">
            <!-- Header -->
            <header class="calendar-header">
                <div class="header-left">
                    <div class="logo">
                        <i class="fas fa-calendar-alt"></i>
                        <span>Calendar</span>
                    </div>
                    <div class="date-navigation">
                        <button class="nav-btn" id="prevMonth">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <button class="nav-btn" id="nextMonth">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                        <h1 id="currentMonth">Tháng 12, 2024</h1>
                    </div>
                </div>
                <div class="header-right">
                    <div class="user-info">
                        <span class="user-name">
                            <i class="fas fa-user"></i>
                            <%= session.getAttribute("googleName") != null ? session.getAttribute("googleName") : (session.getAttribute("user_email") != null ? session.getAttribute("user_email") : "Guest")%>
                        </span>
                        <form action="logout" method="POST" style="display: inline;">
                            <input type="hidden" name="action" value="logout" />
                            <button type="submit" class="btn-logout" title="Đăng xuất">
                                <i class="fas fa-sign-out-alt"></i>
                            </button>
                        </form>
                    </div>
                    <button class="btn-primary" id="addEvent">
                        <i class="fas fa-plus"></i>
                        Tạo sự kiện
                    </button>
                    <div class="view-options">
                        <button class="view-btn active" data-view="month">Tháng</button>
                        <button class="view-btn" data-view="week">Tuần</button>
                        <button class="view-btn" data-view="day">Ngày</button>
                    </div>
                </div>
            </header>

            <!-- Main Calendar -->
            <div class="calendar-main">
                <!-- Sidebar -->
                <aside class="calendar-sidebar">
                    <div class="sidebar-section">
                        <h3>Lịch</h3>
                        <div class="calendar-list">
                            <div class="calendar-item active">
                                <div class="calendar-color" style="background-color: #4285f4;"></div>
                                <span>Lịch chính</span>
                            </div>
                            <div class="calendar-item">
                                <div class="calendar-color" style="background-color: #ea4335;"></div>
                                <span>Công việc</span>
                            </div>
                            <div class="calendar-item">
                                <div class="calendar-color" style="background-color: #34a853;"></div>
                                <span>Cá nhân</span>
                            </div>
                            <div class="calendar-item">
                                <div class="calendar-color" style="background-color: #fbbc04;"></div>
                                <span>Gia đình</span>
                            </div>
                        </div>
                        <button class="btn-add-calendar">
                            <i class="fas fa-plus"></i>
                            Thêm lịch
                        </button>
                    </div>

                    <!-- Todo List Section -->
                    <div class="sidebar-section">
                        <h3>
                            <i class="fas fa-tasks"></i>
                            Todo List
                            <button class="btn-add-todo" id="addTodoBtn">
                                <i class="fas fa-plus"></i>
                            </button>
                        </h3>
                        <div class="todo-container">
                            <div class="todo-input-container" id="todoInputContainer" style="display: none;">
                                <input type="text" id="todoInput" placeholder="Thêm công việc mới...">
                                <div class="todo-input-actions">
                                    <button class="btn-save-todo" id="saveTodo">
                                        <i class="fas fa-check"></i>
                                    </button>
                                    <button class="btn-cancel-todo" id="cancelTodo">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="todo-list" id="todoList">
                                <!-- Todo items will be generated by JavaScript -->
                            </div>
                        </div>
                    </div>

                    <div class="sidebar-section">
                        <h3>Mini Calendar</h3>
                        <div class="mini-calendar" id="miniCalendar">
                            <!-- Mini calendar will be generated by JavaScript -->
                        </div>
                    </div>
                </aside>

                <!-- Calendar Grid -->
                <main class="calendar-grid">
                    <!-- Weekday Headers -->
                    <div class="weekday-headers">
                        <div class="weekday">CN</div>
                        <div class="weekday">T2</div>
                        <div class="weekday">T3</div>
                        <div class="weekday">T4</div>
                        <div class="weekday">T5</div>
                        <div class="weekday">T6</div>
                        <div class="weekday">T7</div>
                    </div>

                    <!-- Calendar Days -->
                    <div class="calendar-days" id="calendarDays">
                        <!-- Days will be generated by JavaScript -->
                    </div>
                </main>
            </div>
        </div>

        <!-- Chatbot -->
        <div class="chatbot-container" id="chatbotContainer">
            <div class="chatbot-header" id="chatbotToggle">
                <div class="chatbot-avatar">
                    <i class="fas fa-robot"></i>
                </div>
                <div class="chatbot-info">
                    <h4 style="font-size:1.2rem; font-weight:700; margin-bottom:2px;">Calendar Assistant</h4>
                    <span class="chatbot-status" style="color:#4ade80; font-weight:600; font-size:0.95rem;">
                        <i class="fas fa-circle" style="font-size:0.7em; vertical-align:middle;"></i> Online
                    </span>
                </div>
                <button class="chatbot-minimize" id="chatbotMinimize" title="Thu nhỏ">
                    <i class="fas fa-minus"></i>
                </button>
            </div>
            <div class="chatbot-body" id="chatbotBody">
                <div class="chat-messages" id="chatMessages">
                    <div class="message bot-message">
                        <div class="message-avatar">
                            <i class="fas fa-robot"></i>
                        </div>
                        <div class="message-content">
                            <p>Xin chào! Tôi là trợ lý lịch của bạn. Tôi có thể giúp bạn:</p>
                            <ul>
                                <li>Tạo sự kiện mới</li>
                                <li>Xem lịch trình</li>
                                <li>Quản lý todo list</li>
                                <li>Trả lời câu hỏi về lịch</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="chat-input-container">
                    <input type="text" id="chatInput" placeholder="Nhập tin nhắn...">
                    <button class="chat-send-btn" id="chatSendBtn">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Event Modal -->
        <div class="modal" id="eventModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Tạo sự kiện mới</h2>
                    <button class="close-btn" id="closeModal">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="eventTitle">Tiêu đề</label>
                        <input type="text" id="eventTitle" placeholder="Nhập tiêu đề sự kiện">
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="eventDate">Ngày</label>
                            <input type="date" id="eventDate">
                        </div>
                        <div class="form-group">
                            <label for="eventTime">Thời gian</label>
                            <input type="time" id="eventTime">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="eventDescription">Mô tả</label>
                        <input type="text" id="eventDescription" placeholder="Mô tả sự kiện (tùy chọn)">
                    </div>
                    <div class="form-group">
                        <label for="eventCalendar">Lịch</label>
                        <select id="eventCalendar">
                            <option value="main">Lịch chính</option>
                            <option value="work">Công việc</option>
                            <option value="personal">Cá nhân</option>
                            <option value="family">Gia đình</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn-secondary" id="cancelEvent">Hủy</button>
                    <button class="btn-primary" id="saveEvent">Lưu</button>
                </div>
            </div>
        </div>

        <script src="js/calendar.js"></script>
        <script>
            // Initialize calendar when page loads
            document.addEventListener('DOMContentLoaded', function () {
                window.calendar = new Calendar();
            });
        </script>
    </body>
</html>
