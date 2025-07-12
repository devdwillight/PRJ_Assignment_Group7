<%-- 
    Document   : calendar
    Created on : Jul 12, 2025, 8:38:24 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Calendar</title>

        <!-- FullCalendar CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.2/main.min.css">

        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


    </head>
    <body class="bg-gray-50">
        <div >


            <!-- Calendar Container -->
            <div class=" rounded-lg shadow-md">
                <div id="calendar" ></div>
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
                    start: '2025-07-12T10:00:00',
                    end: '2024-07-12T11:30:00',
                    color: '#3b82f6'
                },
                {
                    id: 2,
                    title: 'Lễ hội mùa xuân',
                    start: '2025-07-13',
                    end: '2024-07-13',
                    color: '#ef4444'
                },
                {
                    id: 3,
                    title: 'Deadline báo cáo',
                    start: '2025-07-25T14:00:00',
                    end: '2025-07-25T16:00:00',
                    color: '#10b981'
                }
            ];

            // Calendar configuration
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                headerToolbar: false,
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
                eventClick: function (info) {
                    showEventModal(info.event);
                },

                // Event drop handler
                eventDrop: function (info) {
                    console.log('Event dropped:', info.event.title);
                    // Có thể thêm AJAX call để cập nhật database
                },

                // Event resize handler
                eventResize: function (info) {
                    console.log('Event resized:', info.event.title);
                    // Có thể thêm AJAX call để cập nhật database
                },

                // Date click handler
                dateClick: function (info) {
                    console.log('Date clicked:', info.dateStr);
                    // Có thể mở form thêm event mới
                },

                // Events source
                events: function (info, successCallback, failureCallback) {
                    successCallback(events);
                }
            });

            calendar.setOption('height', 860);

            // Render calendar
            calendar.render();

            // Make calendar accessible globally
            window.calendar = calendar;

            // Initialize view button state and title
            if (window.updateViewButtons) {
                window.updateViewButtons('month');
            }
            if (window.updateCalendarTitle) {
                window.updateCalendarTitle();
            }

            // Add event listeners for calendar navigation
            calendar.on('datesSet', function () {
                if (window.updateCalendarTitle) {
                    window.updateCalendarTitle();
                }
            });

            // Add event form handler
            $('#addEventForm').on('submit', function (e) {
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
            $('#closeModal, #closeModalBtn').on('click', function () {
                $('#eventModal').addClass('hidden');
            });

            // Delete event
            $('#deleteEvent').on('click', function () {
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
            $('#eventModal').on('click', function (e) {
                if (e.target === this) {
                    $(this).addClass('hidden');
                }
            });
        </script>
    </body>
</html>
