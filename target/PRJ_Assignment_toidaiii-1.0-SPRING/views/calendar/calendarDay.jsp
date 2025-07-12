<%-- 
    Document   : calendarDay
    Created on : Jul 11, 2025, 10:04:30 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="bg-white rounded-lg shadow overflow-hidden">
    <!-- Day Header -->
    <div class="bg-gray-50 border-b p-4">
        <h2 class="text-xl font-semibold text-gray-800" id="dayHeader">Hôm nay</h2>
        <p class="text-sm text-gray-600" id="daySubheader">Thứ 2, 15 tháng 1, 2025</p>
    </div>
    
    <!-- Day Timeline -->
    <div class="relative overflow-y-scroll h-[600px]">
        <div id="dayTimeline" class="relative">
            <!-- Hours will be populated by JavaScript -->
        </div>
    </div>
</div>

<script type="text/javascript">
// Render day view
function renderDayView(data) {
    const dayTimeline = document.getElementById('dayTimeline');
    const dayHeader = document.getElementById('dayHeader');
    const daySubheader = document.getElementById('daySubheader');
    
    if (!dayTimeline || !data) return;
    
    // Update header
    const date = new Date(data.date);
    const dayNames = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
    const monthNames = [
        'tháng 1', 'tháng 2', 'tháng 3', 'tháng 4', 'tháng 5', 'tháng 6',
        'tháng 7', 'tháng 8', 'tháng 9', 'tháng 10', 'tháng 11', 'tháng 12'
    ];
    
    dayHeader.textContent = dayNames[date.getDay()];
    daySubheader.textContent = date.getDate() + ' ' + monthNames[date.getMonth()] + ', ' + date.getFullYear();
    
    // Render timeline
    dayTimeline.innerHTML = '';
    
    data.hours.forEach(function(hour) {
        const hourElement = document.createElement('div');
        hourElement.className = 'flex border-b min-h-[60px] relative';
        hourElement.innerHTML = 
            '<div class="w-20 p-2 text-right text-sm text-gray-500 border-r bg-gray-50 sticky left-0 z-10">' +
            (hour < 10 ? '0' + hour : hour) + ':00' +
            '</div>' +
            '<div class="flex-1 p-2 relative cursor-pointer hover:bg-blue-50" ' +
            'id="day-cell-' + hour + '" ' +
            'onclick="handleDayCellClick(' + hour + ', \'' + data.date + '\')">' +
            '<!-- Events will be populated here -->' +
            '</div>';
        dayTimeline.appendChild(hourElement);
    });
}

// Handle click on day cell
function handleDayCellClick(hour, date) {
    const startTime = new Date(date);
    startTime.setHours(hour, 0, 0, 0);
    
    const endTime = new Date(startTime);
    endTime.setHours(hour + 1, 0, 0, 0);
    
    const eventData = {
        title: '',
        start: startTime.toISOString(),
        end: endTime.toISOString(),
        color: '#4285f4'
    };
    
    showEventModal(eventData);
}

// Render events for day view
function renderDayEvents() {
    events.forEach(function(event) {
        const eventStart = new Date(event.start);
        const eventEnd = new Date(event.end);
        const startHour = eventStart.getHours();
        const endHour = eventEnd.getHours();
        
        // Calculate position and height
        const startMinutes = eventStart.getMinutes();
        const duration = (eventEnd - eventStart) / (1000 * 60); // duration in minutes
        
        const cell = document.getElementById('day-cell-' + startHour);
        if (cell) {
            const eventElement = document.createElement('div');
            eventElement.className = 'absolute left-0 right-0 mx-1 px-2 py-1 text-xs text-white rounded cursor-pointer hover:opacity-80 transition-opacity';
            eventElement.style.backgroundColor = event.color || '#4285f4';
            eventElement.style.top = ((startMinutes / 60) * 100) + '%';
            eventElement.style.height = Math.max((duration / 60) * 100, 20) + '%';
            eventElement.style.zIndex = '20';
            eventElement.textContent = event.title;
            
            eventElement.addEventListener('click', function(e) {
                e.stopPropagation();
                showEventModal(event);
            });
            
            cell.appendChild(eventElement);
        }
    });
}

// Override renderEvents for day view
if (typeof renderEvents !== 'undefined') {
    const originalRenderEvents = renderEvents;
    renderEvents = function() {
        if (currentView === 'day') {
            renderDayEvents();
        } else if (currentView === 'month') {
            if (typeof renderMonthEvents === 'function') {
                renderMonthEvents();
            }
        } else {
            originalRenderEvents();
        }
    };
}
</script>
