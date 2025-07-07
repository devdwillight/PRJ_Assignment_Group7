class Calendar {
    constructor() {
        this.currentDate = new Date();
        this.events = this.loadEvents();
        this.todos = this.loadTodos();
        this.selectedDate = null;
        this.currentView = 'month';
        this.init();
    }

    init() {
        this.renderCurrentView();
        this.bindEvents();
        this.renderMiniCalendar();
        this.renderTodoList();
        this.addSampleEvents();
        this.addSampleTodos();
    }

    bindEvents() {
        // Navigation buttons
        document.getElementById('prevMonth').addEventListener('click', () => {
            this.navigate(-1);
        });

        document.getElementById('nextMonth').addEventListener('click', () => {
            this.navigate(1);
        });

        // Add event button
        document.getElementById('addEvent').addEventListener('click', () => {
            this.showEventModal();
        });

        // Modal events
        document.getElementById('closeModal').addEventListener('click', () => {
            this.hideEventModal();
        });

        document.getElementById('cancelEvent').addEventListener('click', () => {
            this.hideEventModal();
        });

        document.getElementById('saveEvent').addEventListener('click', () => {
            this.saveEvent();
        });

        // View options
        document.querySelectorAll('.view-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.changeView(e.target.dataset.view, e.target);
            });
        });

        // Calendar item clicks
        document.querySelectorAll('.calendar-item').forEach(item => {
            item.addEventListener('click', (e) => {
                this.toggleCalendarVisibility(e.currentTarget);
            });
        });

        // Todo List events
        document.getElementById('addTodoBtn').addEventListener('click', () => {
            this.showTodoInput();
        });

        document.getElementById('saveTodo').addEventListener('click', () => {
            this.saveTodo();
        });

        document.getElementById('cancelTodo').addEventListener('click', () => {
            this.hideTodoInput();
        });

        document.getElementById('todoInput').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.saveTodo();
            }
        });

        // Chatbot events
        document.getElementById('chatbotToggle').addEventListener('click', () => {
            this.toggleChatbot();
        });

        document.getElementById('chatbotMinimize').addEventListener('click', (e) => {
            e.stopPropagation();
            this.minimizeChatbot();
        });

        document.getElementById('chatSendBtn').addEventListener('click', () => {
            this.sendChatMessage();
        });

        document.getElementById('chatInput').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.sendChatMessage();
            }
        });

        // Close modal when clicking outside
        document.getElementById('eventModal').addEventListener('click', (e) => {
            if (e.target.id === 'eventModal') {
                this.hideEventModal();
            }
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.hideEventModal();
                this.hideTodoInput();
            }
        });
    }

    navigate(direction) {
        if (this.currentView === 'month') {
            this.currentDate.setMonth(this.currentDate.getMonth() + direction);
        } else if (this.currentView === 'week') {
            this.currentDate.setDate(this.currentDate.getDate() + direction * 7);
        } else if (this.currentView === 'day') {
            this.currentDate.setDate(this.currentDate.getDate() + direction);
        }

        this.renderCurrentView();
        this.renderMiniCalendar();
        
        const calendarDays = document.getElementById('calendarDays');
        calendarDays.style.animation = 'none';
        calendarDays.offsetHeight; // Trigger reflow
        calendarDays.style.animation = direction > 0 ? 'slideInRight 0.3s ease' : 'slideInLeft 0.3s ease';
    }

    renderCurrentView() {
        const weekdayHeaders = document.querySelector('.weekday-headers');
        if (this.currentView === 'month') {
            weekdayHeaders.style.display = 'grid';
            this.renderCalendar();
        } else if (this.currentView === 'week') {
            weekdayHeaders.style.display = 'grid';
            this.renderWeekView();
        } else if (this.currentView === 'day') {
            weekdayHeaders.style.display = 'none';
            this.renderDayView();
        }
    }

    renderCalendar() {
        const calendarDays = document.getElementById('calendarDays');
        calendarDays.style.gridTemplateColumns = 'repeat(7, 1fr)';
        
        const year = this.currentDate.getFullYear();
        const month = this.currentDate.getMonth();
        
        const monthNames = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
        document.getElementById('currentMonth').textContent = `${monthNames[month]}, ${year}`;

        const firstDay = new Date(year, month, 1);
        const startDate = new Date(firstDay);
        startDate.setDate(startDate.getDate() - firstDay.getDay());

        calendarDays.innerHTML = '';

        for (let i = 0; i < 42; i++) {
            const currentDate = new Date(startDate);
            currentDate.setDate(startDate.getDate() + i);

            const dayElement = document.createElement('div');
            dayElement.className = 'calendar-day';
            
            if (currentDate.getMonth() !== month) {
                dayElement.classList.add('other-month');
            }
            if (this.isToday(currentDate)) {
                dayElement.classList.add('today');
            }

            dayElement.innerHTML = `
                <div class="day-number">${currentDate.getDate()}</div>
                <div class="events-container">
                    ${this.renderEventsForDate(currentDate)}
                </div>
            `;
            dayElement.addEventListener('click', () => { this.selectDate(currentDate); });
            calendarDays.appendChild(dayElement);
        }
    }

    renderEventsForDate(date) {
        const dateString = this.formatDate(date);
        const dayEvents = this.events.filter(event => event.date === dateString);
        
        return dayEvents.map(event => `
            <div class="event ${event.calendar}" 
                 title="${event.title}"
                 onclick="calendar.showEventDetails('${event.id}')">
                ${event.title}
            </div>
        `).join('');
    }

    renderMiniCalendar() {
        const miniCalendar = document.getElementById('miniCalendar');
        const year = this.currentDate.getFullYear();
        const month = this.currentDate.getMonth();
        
        const firstDay = new Date(year, month, 1);
        const lastDay = new Date(year, month + 1, 0);
        const startDate = new Date(firstDay);
        startDate.setDate(startDate.getDate() - firstDay.getDay());

        let html = `
            <div class="mini-calendar-header">
                <div class="mini-month">${this.getMonthName(month)} ${year}</div>
            </div>
            <div class="mini-weekdays">
                <span>CN</span><span>T2</span><span>T3</span><span>T4</span><span>T5</span><span>T6</span><span>T7</span>
            </div>
            <div class="mini-days">
        `;

        for (let i = 0; i < 35; i++) {
            const currentDate = new Date(startDate);
            currentDate.setDate(startDate.getDate() + i);
            
            const isCurrentMonth = currentDate.getMonth() === month;
            const isToday = this.isToday(currentDate);
            
            let dayClass = 'mini-day';
            if (!isCurrentMonth) dayClass += ' other-month';
            if (isToday) dayClass += ' today';
            
            html += `<span class="${dayClass}">${currentDate.getDate()}</span>`;
        }

        html += '</div>';
        miniCalendar.innerHTML = html;
    }

    // Todo List Methods
    renderTodoList() {
        const todoList = document.getElementById('todoList');
        todoList.innerHTML = '';

        this.todos.forEach(todo => {
            const todoItem = document.createElement('div');
            todoItem.className = 'todo-item';
            todoItem.innerHTML = `
                <div class="todo-checkbox ${todo.completed ? 'checked' : ''}" onclick="calendar.toggleTodo('${todo.id}')">
                    ${todo.completed ? '<i class="fas fa-check"></i>' : ''}
                </div>
                <span class="todo-text ${todo.completed ? 'completed' : ''}">${todo.text}</span>
                <button class="todo-delete" onclick="calendar.deleteTodo('${todo.id}')">
                    <i class="fas fa-trash"></i>
                </button>
            `;
            todoList.appendChild(todoItem);
        });
    }

    showTodoInput() {
        const inputContainer = document.getElementById('todoInputContainer');
        const input = document.getElementById('todoInput');
        inputContainer.style.display = 'block';
        input.focus();
        
        // Add animation
        inputContainer.style.animation = 'none';
        inputContainer.offsetHeight;
        inputContainer.style.animation = 'slideInDown 0.3s ease';
    }

    hideTodoInput() {
        const inputContainer = document.getElementById('todoInputContainer');
        const input = document.getElementById('todoInput');
        inputContainer.style.display = 'none';
        input.value = '';
    }

    saveTodo() {
        const input = document.getElementById('todoInput');
        const text = input.value.trim();

        if (!text) {
            this.showNotification('Vui lòng nhập nội dung công việc', 'error');
            return;
        }

        const todo = {
            id: this.generateId(),
            text: text,
            completed: false,
            createdAt: new Date().toISOString()
        };

        this.todos.push(todo);
        this.saveTodos();
        this.renderTodoList();
        this.hideTodoInput();
        
        this.showNotification('Công việc đã được thêm!', 'success');
    }

    toggleTodo(todoId) {
        const todo = this.todos.find(t => t.id === todoId);
        if (todo) {
            todo.completed = !todo.completed;
            this.saveTodos();
            this.renderTodoList();
            
            const message = todo.completed ? 'Hoàn thành công việc!' : 'Đã bỏ hoàn thành';
            this.showNotification(message, 'success');
        }
    }

    deleteTodo(todoId) {
        const index = this.todos.findIndex(t => t.id === todoId);
        if (index > -1) {
            this.todos.splice(index, 1);
            this.saveTodos();
            this.renderTodoList();
            this.showNotification('Đã xóa công việc!', 'success');
        }
    }

    addSampleTodos() {
        if (this.todos.length === 0) {
            const sampleTodos = [
                {
                    id: 'todo1',
                    text: 'Hoàn thành báo cáo dự án',
                    completed: false,
                    createdAt: new Date().toISOString()
                },
                {
                    id: 'todo2',
                    text: 'Gọi điện cho khách hàng',
                    completed: true,
                    createdAt: new Date().toISOString()
                },
                {
                    id: 'todo3',
                    text: 'Chuẩn bị cho cuộc họp ngày mai',
                    completed: false,
                    createdAt: new Date().toISOString()
                }
            ];

            this.todos = sampleTodos;
            this.saveTodos();
            this.renderTodoList();
        }
    }

    // Chatbot Methods
    toggleChatbot() {
        const chatbot = document.getElementById('chatbotContainer');
        chatbot.classList.toggle('minimized');
    }

    minimizeChatbot() {
        const chatbot = document.getElementById('chatbotContainer');
        chatbot.classList.add('minimized');
    }

    sendChatMessage() {
        const input = document.getElementById('chatInput');
        const message = input.value.trim();

        if (!message) return;

        // Add user message
        this.addChatMessage(message, 'user');
        input.value = '';

        // Simulate bot response
        setTimeout(() => {
            this.handleBotResponse(message);
        }, 1000);
    }

    addChatMessage(text, sender) {
        const messagesContainer = document.getElementById('chatMessages');
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${sender}-message`;
        
        const avatar = sender === 'user' ? '<i class="fas fa-user"></i>' : '<i class="fas fa-robot"></i>';
        
        messageDiv.innerHTML = `
            <div class="message-avatar">
                ${avatar}
            </div>
            <div class="message-content">
                <p>${text}</p>
            </div>
        `;

        messagesContainer.appendChild(messageDiv);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }

    handleBotResponse(userMessage) {
        const lowerMessage = userMessage.toLowerCase();
        let response = '';

        if (lowerMessage.includes('tạo sự kiện') || lowerMessage.includes('thêm sự kiện')) {
            response = 'Tôi sẽ giúp bạn tạo sự kiện mới. Hãy click vào nút "Tạo sự kiện" hoặc click vào ngày bất kỳ trên calendar.';
        } else if (lowerMessage.includes('todo') || lowerMessage.includes('công việc')) {
            response = 'Bạn có thể quản lý todo list trong sidebar bên trái. Click vào nút "+" để thêm công việc mới.';
        } else if (lowerMessage.includes('lịch') || lowerMessage.includes('calendar')) {
            response = 'Bạn có thể xem lịch trình trong phần chính. Sử dụng nút mũi tên để chuyển tháng.';
        } else if (lowerMessage.includes('xin chào') || lowerMessage.includes('hello')) {
            response = 'Xin chào! Tôi là trợ lý calendar của bạn. Tôi có thể giúp bạn quản lý lịch trình và công việc.';
        } else if (lowerMessage.includes('cảm ơn') || lowerMessage.includes('thanks')) {
            response = 'Rất vui được giúp bạn! Nếu cần thêm gì, hãy hỏi tôi nhé.';
        } else {
            response = 'Tôi hiểu bạn đang hỏi về "' + userMessage + '". Bạn có thể hỏi tôi về cách tạo sự kiện, quản lý todo list, hoặc xem lịch trình.';
        }

        this.addChatMessage(response, 'bot');
    }

    showEventModal(date = null) {
        const modal = document.getElementById('eventModal');
        const form = document.getElementById('eventForm');
        
        if (date) {
            document.getElementById('eventDate').value = this.formatDate(date);
        } else {
            document.getElementById('eventDate').value = this.formatDate(new Date());
        }
        
        document.getElementById('eventTime').value = '';
        document.getElementById('eventTitle').value = '';
        document.getElementById('eventDescription').value = '';
        document.getElementById('eventCalendar').value = 'main';
        
        modal.classList.add('show');
        document.getElementById('eventTitle').focus();
    }

    hideEventModal() {
        const modal = document.getElementById('eventModal');
        modal.classList.remove('show');
    }

    saveEvent() {
        const title = document.getElementById('eventTitle').value.trim();
        const date = document.getElementById('eventDate').value;
        const time = document.getElementById('eventTime').value;
        const description = document.getElementById('eventDescription').value.trim();
        const calendar = document.getElementById('eventCalendar').value;

        if (!title || !date) {
            this.showNotification('Vui lòng nhập tiêu đề và ngày', 'error');
            return;
        }

        const event = {
            id: this.generateId(),
            title,
            date,
            time,
            description,
            calendar,
            createdAt: new Date().toISOString()
        };

        this.events.push(event);
        this.saveEvents();
        this.renderCurrentView();
        this.hideEventModal();
        
        this.showNotification('Sự kiện đã được tạo thành công!', 'success');
        
        // Add success animation to the day
        const dayElement = this.findDayElement(date);
        if (dayElement) {
            dayElement.classList.add('success');
            setTimeout(() => dayElement.classList.remove('success'), 600);
        }
    }

    selectDate(date) {
        this.selectedDate = date;
        this.showEventModal(date);
    }

    changeView(view, targetElement) {
        document.querySelectorAll('.view-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        targetElement.classList.add('active');
        this.currentView = view;
        
        this.renderCurrentView();
        
        const calendarGrid = document.querySelector('.calendar-grid');
        calendarGrid.style.animation = 'none';
        calendarGrid.offsetHeight;
        calendarGrid.style.animation = 'fadeIn 0.3s ease';
    }

    toggleCalendarVisibility(calendarItem) {
        calendarItem.classList.toggle('active');
        
        // Add bounce animation
        calendarItem.style.animation = 'none';
        calendarItem.offsetHeight;
        calendarItem.style.animation = 'bounce 0.6s ease';
    }

    showEventDetails(eventId) {
        const event = this.events.find(e => e.id === eventId);
        if (event) {
            alert(`Sự kiện: ${event.title}\nNgày: ${event.date}\nThời gian: ${event.time || 'Không có'}\nMô tả: ${event.description || 'Không có'}`);
        }
    }

    // Utility methods
    isToday(date) {
        const today = new Date();
        return date.toDateString() === today.toDateString();
    }

    formatDate(date) {
        return date.toISOString().split('T')[0];
    }

    getMonthName(month, full = false) {
        const shortNames = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];
        const longNames = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
        return full ? longNames[month] : shortNames[month];
    }

    generateId() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2);
    }

    findDayElement(dateString) {
        const days = document.querySelectorAll('.calendar-day');
        for (let day of days) {
            const dayNumber = day.querySelector('.day-number').textContent;
            const currentMonth = this.currentDate.getMonth();
            const currentYear = this.currentDate.getFullYear();
            const dayDate = new Date(currentYear, currentMonth, parseInt(dayNumber));
            if (this.formatDate(dayDate) === dateString) {
                return day;
            }
        }
        return null;
    }

    showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.textContent = message;
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            z-index: 10000;
            animation: slideInRight 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        `;

        if (type === 'success') {
            notification.style.background = 'linear-gradient(135deg, #34a853, #28a745)';
        } else if (type === 'error') {
            notification.style.background = 'linear-gradient(135deg, #ea4335, #dc3545)';
        } else {
            notification.style.background = 'linear-gradient(135deg, #4285f4, #007bff)';
        }

        document.body.appendChild(notification);

        // Remove notification after 3 seconds
        setTimeout(() => {
            notification.style.animation = 'slideOutRight 0.3s ease';
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 300);
        }, 3000);
    }

    // Sample events for demonstration
    addSampleEvents() {
        const today = new Date();
        const tomorrow = new Date(today);
        tomorrow.setDate(today.getDate() + 1);
        
        const sampleEvents = [
            {
                id: 'sample1',
                title: 'Họp nhóm dự án',
                date: this.formatDate(today),
                time: '09:00',
                description: 'Thảo luận về tiến độ dự án',
                calendar: 'work',
                createdAt: new Date().toISOString()
            },
            {
                id: 'sample2',
                title: 'Sinh nhật bạn',
                date: this.formatDate(tomorrow),
                time: '19:00',
                description: 'Tiệc sinh nhật tại nhà hàng',
                calendar: 'personal',
                createdAt: new Date().toISOString()
            },
            {
                id: 'sample3',
                title: 'Đi chơi gia đình',
                date: this.formatDate(today),
                time: '14:00',
                description: 'Đi công viên với gia đình',
                calendar: 'family',
                createdAt: new Date().toISOString()
            }
        ];

        // Only add sample events if no events exist
        if (this.events.length === 0) {
            this.events = sampleEvents;
            this.saveEvents();
            this.renderCurrentView();
        }
    }

    // Local storage methods
    saveEvents() {
        localStorage.setItem('calendarEvents', JSON.stringify(this.events));
    }

    loadEvents() {
        const saved = localStorage.getItem('calendarEvents');
        return saved ? JSON.parse(saved) : [];
    }

    saveTodos() {
        localStorage.setItem('calendarTodos', JSON.stringify(this.todos));
    }

    loadTodos() {
        const saved = localStorage.getItem('calendarTodos');
        return saved ? JSON.parse(saved) : [];
    }

    renderWeekView() {
        const weekStart = new Date(this.currentDate);
        weekStart.setDate(this.currentDate.getDate() - this.currentDate.getDay());
        
        const weekEnd = new Date(weekStart);
        weekEnd.setDate(weekStart.getDate() + 6);

        const startMonthName = this.getMonthName(weekStart.getMonth(), true);
        const endMonthName = this.getMonthName(weekEnd.getMonth(), true);
        
        let headerText = `${weekStart.getDate()} ${startMonthName} - ${weekEnd.getDate()} ${endMonthName}, ${weekEnd.getFullYear()}`;
        if (weekStart.getFullYear() !== weekEnd.getFullYear()) {
             headerText = `${weekStart.getDate()} ${startMonthName} ${weekStart.getFullYear()} - ${weekEnd.getDate()} ${endMonthName} ${weekEnd.getFullYear()}`;
        }
        
        document.getElementById('currentMonth').textContent = headerText;

        const calendarDays = document.getElementById('calendarDays');
        calendarDays.innerHTML = '';
        calendarDays.style.gridTemplateColumns = 'repeat(7, 1fr)';
        
        for (let i = 0; i < 7; i++) {
            const date = new Date(weekStart);
            date.setDate(weekStart.getDate() + i);
            const dayElement = document.createElement('div');
            dayElement.className = 'calendar-day';
            if (this.isToday(date)) dayElement.classList.add('today');
            
            dayElement.innerHTML = `
                <div class="day-number">${date.getDate()}</div>
                <div class="events-container">
                    ${this.renderEventsForDate(date)}
                </div>
            `;
            dayElement.addEventListener('click', () => { this.selectDate(date); });
            calendarDays.appendChild(dayElement);
        }
    }

    renderDayView() {
        const year = this.currentDate.getFullYear();
        const month = this.currentDate.getMonth();
        const day = this.currentDate.getDate();
        const date = new Date(year, month, day);

        const monthNames = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
        document.getElementById('currentMonth').textContent = `Ngày ${day}, ${monthNames[month]}, ${year}`;
        
        const calendarDays = document.getElementById('calendarDays');
        calendarDays.innerHTML = '';
        calendarDays.style.gridTemplateColumns = '1fr';

        const dayElement = document.createElement('div');
        dayElement.className = 'calendar-day single-day-view';
        if (this.isToday(date)) dayElement.classList.add('today');

        dayElement.innerHTML = `
            <div class="day-number">${date.getDate()}</div>
            <div class="events-container">
                ${this.renderEventsForDate(date)}
            </div>
        `;
        dayElement.addEventListener('click', () => this.selectDate(date));
        calendarDays.appendChild(dayElement);
    }
}

// Initialize calendar when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.calendar = new Calendar();
});

// Add additional CSS for notifications
const style = document.createElement('style');
style.textContent = `
    @keyframes slideOutRight {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(100%);
        }
    }
    
    .mini-calendar-header {
        text-align: center;
        font-weight: 600;
        margin-bottom: 10px;
        color: #495057;
    }
    
    .mini-weekdays {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        text-align: center;
        font-size: 10px;
        font-weight: 600;
        color: #6c757d;
        margin-bottom: 5px;
    }
    
    .mini-days {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 2px;
    }
    
    .mini-day {
        text-align: center;
        padding: 4px;
        font-size: 12px;
        cursor: pointer;
        border-radius: 4px;
        transition: all 0.2s ease;
    }
    
    .mini-day:hover {
        background: rgba(66, 133, 244, 0.1);
    }
    
    .mini-day.today {
        background: #4285f4;
        color: white;
        font-weight: 600;
    }
    
    .mini-day.other-month {
        color: #adb5bd;
    }
`;
document.head.appendChild(style); 