<%-- 
    Document   : calendarMonth
    Created on : Jul 11, 2025, 10:04:30 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="bg-white rounded-lg shadow overflow-hidden">
    <!-- Month Header -->
    <div class="grid grid-cols-7 bg-gray-50 border-b">
        <div class="py-3 text-center text-sm font-medium text-gray-500">Chủ nhật</div>
        <div class="py-3 text-center text-sm font-medium text-gray-500">Thứ 2</div>
        <div class="py-3 text-center text-sm font-medium text-gray-500">Thứ 3</div>
        <div class="py-3 text-center text-sm font-medium text-gray-500">Thứ 4</div>
        <div class="py-3 text-center text-sm font-medium text-gray-500">Thứ 5</div>
        <div class="py-3 text-center text-sm font-medium text-gray-500">Thứ 6</div>
        <div class="py-3 text-center text-sm font-medium text-gray-500">Thứ 7</div>
    </div>
    
    <!-- Month Grid -->
    <div id="monthGrid" class="grid grid-cols-7">
        <!-- Days will be populated by JavaScript -->
    </div>
</div>

<script>
// Render month view
function renderMonthView(data) {
    const monthGrid = document.getElementById('monthGrid');
    if (!monthGrid || !data || !data.days) return;
    
    monthGrid.innerHTML = '';
    
    data.days.forEach(day => {
        const dayElement = document.createElement('div');
        dayElement.className = `min-h-[120px] p-2 border-r border-b relative ${
            day.isCurrentMonth ? 'bg-white' : 'bg-gray-50'
        } ${day.isToday ? 'bg-blue-50 border-blue-200' : ''}`;
        
        dayElement.innerHTML = `
            <div class="flex justify-between items-start mb-1">
                <span class="text-sm font-medium ${
                    day.isToday ? 'text-blue-600 bg-blue-100 rounded-full w-6 h-6 flex items-center justify-center' : 
                    day.isCurrentMonth ? 'text-gray-900' : 'text-gray-400'
                }">${day.dayOfMonth}</span>
                ${day.isCurrentMonth ? '<button class="text-gray-400 hover:text-gray-600 text-xs" onclick="addEventToDay(\'' + day.date + '\')"><i class="fas fa-plus"></i></button>' : ''}
            </div>
            <div class="space-y-1" id="events-${day.date}">
                <!-- Events will be populated here -->
            </div>
        `;
        
        monthGrid.appendChild(dayElement);
    });
}

// Add event to specific day
function addEventToDay(date) {
    const startTime = new Date(date);
    startTime.setHours(9, 0, 0, 0);
    
    const endTime = new Date(startTime);
    endTime.setHours(10, 0, 0, 0);
    
    const eventData = {
        title: '',
        start: startTime.toISOString(),
        end: endTime.toISOString(),
        color: '#4285f4'
    };
    
    showEventModal(eventData);
}

// Fetch month data
function fetchMonthData(date) {
    showLoading(true);
    
    fetch(`/Calendar?date=${date.toISOString()}&view=month`)
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                renderMonthView(data);
                fetchEvents(date, 'month');
            } else {
                throw new Error(data.message || 'Failed to load month data');
            }
        })
        .catch(error => {
            console.error('Error fetching month data:', error);
            showNotification('Không thể tải dữ liệu tháng');
        })
        .finally(() => {
            showLoading(false);
        });
}

// Render events for month view
function renderMonthEvents() {
    events.forEach(event => {
        const eventDate = new Date(event.start).toISOString().split('T')[0];
        const eventContainer = document.getElementById(`events-${eventDate}`);
        
        if (eventContainer) {
            const eventElement = document.createElement('div');
            eventElement.className = 'text-xs p-1 rounded cursor-pointer truncate';
            eventElement.style.backgroundColor = event.color + '20';
            eventElement.style.color = event.color;
            eventElement.style.borderLeft = `3px solid ${event.color}`;
            eventElement.textContent = event.title;
            
            eventElement.addEventListener('click', (e) => {
                e.stopPropagation();
                showEventModal(event);
            });
            
            eventContainer.appendChild(eventElement);
        }
    });
}

// Override renderEvents for month view
const originalRenderEvents = renderEvents;
renderEvents = function() {
    if (currentView === 'month') {
        renderMonthEvents();
    } else {
        originalRenderEvents();
    }
};
</script>