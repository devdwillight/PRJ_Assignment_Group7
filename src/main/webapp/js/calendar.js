class Calendar {
    constructor() {
        this.currentDate = new Date();
        this.events = this.loadEvents();
        this.selectedDate = null;
        this.init();
    }

    init() {
        this.renderCalendar();
        this.bindEvents();
        this.renderMiniCalendar();
        this.addSampleEvents();
    }

    bindEvents() {
        // Navigation buttons
        document.getElementById('prevMonth').addEventListener('click', () => {
            this.navigateMonth(-1);
        });

        document.getElementById('nextMonth').addEventListener('click', () => {
            this.navigateMonth(1);
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
                this.changeView(e.target.dataset.view);
            });
        });

        // Calendar item clicks
        document.querySelectorAll('.calendar-item').forEach(item => {
            item.addEventListener('click', (e) => {
                this.toggleCalendarVisibility(e.currentTarget);
            });
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
            }
        });
    }

    navigateMonth(direction) {
        this.currentDate.setMonth(this.currentDate.getMonth() + direction);
        this.renderCalendar();
        this.renderMiniCalendar();
        
        // Add animation
        const calendarDays = document.getElementById('calendarDays');
        calendarDays.style.animation = 'none';
        calendarDays.offsetHeight; // Trigger reflow
        calendarDays.style.animation = direction > 0 ? 'slideInRight 0.3s ease' : 'slideInLeft 0.3s ease';
    }

    renderCalendar() {
        const year = this.currentDate.getFullYear();
        const month = this.currentDate.getMonth();
        
        // Update header
        const monthNames = [
            'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
            'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
        ];
        document.getElementById('currentMonth').textContent = `${monthNames[month]}, ${year}`;

        // Get first day of month and number of days
        const firstDay = new Date(year, month, 1);
        const lastDay = new Date(year, month + 1, 0);
        const startDate = new Date(firstDay);
        startDate.setDate(startDate.getDate() - firstDay.getDay());

        const calendarDays = document.getElementById('calendarDays');
        calendarDays.innerHTML = '';

        // Generate calendar days
        for (let i = 0; i < 42; i++) {
            const currentDate = new Date(startDate);
            currentDate.setDate(startDate.getDate() + i);

            const dayElement = document.createElement('div');
            dayElement.className = 'calendar-day';
            
            const isCurrentMonth = currentDate.getMonth() === month;
            const isToday = this.isToday(currentDate);
            
            if (!isCurrentMonth) {
                dayElement.classList.add('other-month');
            }
            
            if (isToday) {
                dayElement.classList.add('today');
            }

            dayElement.innerHTML = `
                <div class="day-number">${currentDate.getDate()}</div>
                <div class="events-container">
                    ${this.renderEventsForDate(currentDate)}
                </div>
            `;

            dayElement.addEventListener('click', () => {
                this.selectDate(currentDate);
            });

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
        this.renderCalendar();
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

    changeView(view) {
        // Remove active class from all buttons
        document.querySelectorAll('.view-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        
        // Add active class to clicked button
        event.target.classList.add('active');
        
        // Add animation
        const calendarGrid = document.querySelector('.calendar-grid');
        calendarGrid.style.animation = 'none';
        calendarGrid.offsetHeight;
        calendarGrid.style.animation = 'fadeIn 0.3s ease';
        
        // Here you would implement different view logic
        console.log(`Switched to ${view} view`);
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

    getMonthName(month) {
        const names = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];
        return names[month];
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
            this.renderCalendar();
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