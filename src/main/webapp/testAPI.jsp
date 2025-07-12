<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>FullCalendar Demo</title>
        
        <!-- FullCalendar CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.2/main.min.css">
        
        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
        
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        
        <style>
            .fc-button-primary{
                background-color: #3b82f6!important;
                border-color: #3b82f6!important;
                color: white!important;
                padding: 8px 12px!important;
                border-radius: 6px!important;
            }
            .fc-button-primary:hover{
                background-color: #2563eb!important;
                border-color: #2563eb!important;
            }
            .fc-button-primary:focus{
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.5)!important;
            }
            .fc-button-group .fc-button{
                margin: 0 2px!important;
                border-radius: 6px!important;
            }
            .fc-view .fc-col-header-cell{
                padding: 10px 0!important;
                background-color: #f8fafc!important;
            }
            .fc-theme-standard td, .fc-theme-standard th{
                border: 1px solid #e2e8f0!important;
            }
            .fc-daygrid-event{
                border-radius: 4px!important;
                margin: 1px 0!important;
            }
            .fc-daygrid-day-top{
                font-size: 16px;
                font-weight: 500;
            }
            .fc-col-header-cell-cushion {
                font-size: 18px;
                font-weight: 600!important;
                color: #374151!important;
            }
            .fc-event-time{
                font-size: 14px;
            }
            .fc-event-title{
                font-size: 14px;
                font-weight: 500;
            }
        </style>
    </head>
    <body class="bg-gray-50">
        <div class="container mx-auto px-4 py-8">
            <!-- Header -->
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-gray-800 mb-2">FullCalendar Demo</h1>
                <p class="text-gray-600">Demo sử dụng FullCalendar với các tính năng cơ bản</p>
            </div>
            
            <!-- Control Panel -->
            <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                <h2 class="text-xl font-semibold mb-4">Thêm Event Mới</h2>
                <form id="addEventForm" class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Tiêu đề</label>
                        <input type="text" id="eventTitle" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Nhập tiêu đề event">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Ngày bắt đầu</label>
                        <input type="date" id="eventStart" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Màu sắc</label>
                        <select id="eventColor" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="#3b82f6">Xanh dương</option>
                            <option value="#ef4444">Đỏ</option>
                            <option value="#10b981">Xanh lá</option>
                            <option value="#f59e0b">Vàng</option>
                            <option value="#8b5cf6">Tím</option>
                            <option value="#ec4899">Hồng</option>
                        </select>
                    </div>
                    <div class="md:col-span-3">
                        <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            Thêm Event
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Calendar Container -->
            <div class="bg-white rounded-lg shadow-md p-6">
                <div id="calendar"></div>
            </div>
            
            <!-- Event Details Modal -->
            <div id="eventModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden z-50">
                <div class="flex items-center justify-center min-h-screen p-4">
                    <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
                        <div class="flex justify-between items-center p-6 border-b">
                            <h3 class="text-lg font-semibold text-gray-900">Chi tiết Event</h3>
                            <button id="closeModal" class="text-gray-400 hover:text-gray-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                                </svg>
                            </button>
                        </div>
                        <div class="p-6">
                            <div class="mb-4">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Tiêu đề:</label>
                                <p id="modalTitle" class="text-gray-900 font-medium"></p>
                            </div>
                            <div class="mb-4">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Thời gian:</label>
                                <p id="modalTime" class="text-gray-900"></p>
                            </div>
                            <div class="mb-4">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Màu sắc:</label>
                                <div id="modalColor" class="w-6 h-6 rounded border border-gray-300"></div>
                            </div>
                        </div>
                        <div class="flex justify-end p-6 border-t">
                            <button id="deleteEvent" class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 mr-2">
                                Xóa Event
                            </button>
                            <button id="closeModalBtn" class="bg-gray-300 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-400">
                                Đóng
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- FullCalendar JS -->
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.2/main.min.js"></script>
        
        <script>
            // Sample events data
            var events = [
                {
                    id: 1,
                    title: 'Họp dự án',
                    start: '2024-01-15T10:00:00',
                    end: '2024-01-15T11:30:00',
                    color: '#3b82f6'
                },
                {
                    id: 2,
                    title: 'Lễ hội mùa xuân',
                    start: '2024-01-20',
                    end: '2024-01-22',
                    color: '#ef4444'
                },
                {
                    id: 3,
                    title: 'Deadline báo cáo',
                    start: '2024-01-25T14:00:00',
                    end: '2024-01-25T16:00:00',
                    color: '#10b981'
                }
            ];

            // Calendar configuration
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
                },
                locale: 'vi',
                buttonText: {
                    today: 'Hôm nay',
                    month: 'Tháng',
                    week: 'Tuần',
                    day: 'Ngày',
                    list: 'Danh sách'
                },
                titleFormat: {year: 'numeric', month: 'long'},
                initialDate: new Date(),
                navLinks: true,
                businessHours: true,
                editable: true,
                selectable: true,
                droppable: true,
                dayMaxEventRows: true,
                
                // Event click handler
                eventClick: function(info) {
                    showEventModal(info.event);
                },
                
                // Event drop handler
                eventDrop: function(info) {
                    console.log('Event dropped:', info.event.title);
                    // Có thể thêm AJAX call để cập nhật database
                },
                
                // Event resize handler
                eventResize: function(info) {
                    console.log('Event resized:', info.event.title);
                    // Có thể thêm AJAX call để cập nhật database
                },
                
                // Date click handler
                dateClick: function(info) {
                    console.log('Date clicked:', info.dateStr);
                    // Có thể mở form thêm event mới
                },
                
                // Events source
                events: function(info, successCallback, failureCallback) {
                    successCallback(events);
                }
            });

            // Render calendar
            calendar.render();

            // Add event form handler
            $('#addEventForm').on('submit', function(e) {
                e.preventDefault();
                
                var title = $('#eventTitle').val();
                var start = $('#eventStart').val();
                var color = $('#eventColor').val();
                
                if (!title || !start) {
                    alert('Vui lòng nhập đầy đủ thông tin!');
                    return;
                }
                
                var newEvent = {
                    id: Date.now(), // Simple ID generation
                    title: title,
                    start: start,
                    color: color
                };
                
                events.push(newEvent);
                calendar.refetchEvents();
                
                // Reset form
                $('#addEventForm')[0].reset();
                
                alert('Event đã được thêm thành công!');
            });

            // Modal functions
            function showEventModal(event) {
                $('#modalTitle').text(event.title);
                $('#modalTime').text(formatEventTime(event));
                $('#modalColor').css('background-color', event.backgroundColor || event.color);
                $('#eventModal').removeClass('hidden');
                
                // Store event for deletion
                $('#deleteEvent').data('eventId', event.id);
            }

            function formatEventTime(event) {
                if (event.allDay) {
                    return 'Cả ngày';
                }
                
                var start = new Date(event.start);
                var end = event.end ? new Date(event.end) : null;
                
                var startStr = start.toLocaleDateString('vi-VN') + ' ' + start.toLocaleTimeString('vi-VN', {hour: '2-digit', minute: '2-digit'});
                
                if (end) {
                    var endStr = end.toLocaleDateString('vi-VN') + ' ' + end.toLocaleTimeString('vi-VN', {hour: '2-digit', minute: '2-digit'});
                    return startStr + ' - ' + endStr;
                }
                
                return startStr;
            }

            // Close modal
            $('#closeModal, #closeModalBtn').on('click', function() {
                $('#eventModal').addClass('hidden');
            });

            // Delete event
            $('#deleteEvent').on('click', function() {
                var eventId = $(this).data('eventId');
                var index = events.findIndex(e => e.id == eventId);
                
                if (index > -1) {
                    events.splice(index, 1);
                    calendar.refetchEvents();
                    $('#eventModal').addClass('hidden');
                    alert('Event đã được xóa!');
                }
            });

            // Close modal when clicking outside
            $('#eventModal').on('click', function(e) {
                if (e.target === this) {
                    $(this).addClass('hidden');
                }
            });
        </script>
    </body>
</html> 