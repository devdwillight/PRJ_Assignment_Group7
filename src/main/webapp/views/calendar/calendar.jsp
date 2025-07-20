<%-- 
    Document   : calendar
    Created on : Jul 12, 2025, 8:38:24 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Calendar" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            <!-- Debug: Hidden input để kiểm tra dữ liệu -->
            <input type="hidden" id="debugEventsJson" value='<%= request.getAttribute("eventsJson") != null ? request.getAttribute("eventsJson") : "[]"%>' />

            <!-- Debug: Hiển thị dữ liệu trực tiếp -->
            <div style="display: none;">
                <p>Debug - Events JSON: <%= request.getAttribute("eventsJson") != null ? request.getAttribute("eventsJson") : "NULL"%></p>
                <p>Debug - Events JSON length: <%= request.getAttribute("eventsJson") != null ? ((String) request.getAttribute("eventsJson")).length() : "0"%></p>
                <p>Debug - Calendars count: <c:out value="${calendars != null ? calendars.size() : 0}"/></p>
                <c:if test="${not empty calendars}">
                    <p>Debug - Calendar names:</p>
                    <ul>
                        <c:forEach var="calendar" items="${calendars}">
                            <li><c:out value="${calendar.name}"/> (ID: <c:out value="${calendar.idCalendar}"/>)</li>
                        </c:forEach>
                    </ul>
                </c:if>
            </div>

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

            <!-- Create Event Modal -->
            <div id="createEventModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden z-50">
                <div class="flex items-center justify-center min-h-screen p-4">
                    <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
                        <div class="flex justify-between items-center p-6 border-b">
                            <h3 class="text-lg font-semibold text-gray-900">Tạo Event Mới</h3>
                            <button id="closeCreateModal" class="text-gray-400 hover:text-gray-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                                </svg>
                            </button>
                        </div>
                        <form id="createEventForm" class="p-6">
                            <div class="mb-4">
                                <label for="eventTitle" class="block text-sm font-medium text-gray-700 mb-1">Tiêu đề *</label>
                                <input type="text" id="eventTitle" name="title" required 
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                            </div>

                            <div class="mb-4">
                                <label for="eventDescription" class="block text-sm font-medium text-gray-700 mb-1">Mô tả</label>
                                <textarea id="eventDescription" name="description" rows="3"
                                          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                            </div>

                            <div class="mb-4">
                                <label for="eventLocation" class="block text-sm font-medium text-gray-700 mb-1">Địa điểm</label>
                                <input type="text" id="eventLocation" name="location"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                            </div>

                            <div class="grid grid-cols-2 gap-4 mb-4">
                                <div>
                                    <label for="eventStartDate" class="block text-sm font-medium text-gray-700 mb-1">Ngày bắt đầu *</label>
                                    <input type="date" id="eventStartDate" name="startDate" required
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                </div>
                                <div>
                                    <label for="eventStartTime" class="block text-sm font-medium text-gray-700 mb-1">Giờ bắt đầu</label>
                                    <input type="time" id="eventStartTime" name="startTime"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                </div>
                            </div>

                            <div class="grid grid-cols-2 gap-4 mb-4">
                                <div>
                                    <label for="eventEndDate" class="block text-sm font-medium text-gray-700 mb-1">Ngày kết thúc</label>
                                    <input type="date" id="eventEndDate" name="endDate"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                </div>
                                <div>
                                    <label for="eventEndTime" class="block text-sm font-medium text-gray-700 mb-1">Giờ kết thúc</label>
                                    <input type="time" id="eventEndTime" name="endTime"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="flex items-center">
                                    <input type="checkbox" id="eventAllDay" name="allDay" class="mr-2">
                                    <span class="text-sm text-gray-700">Cả ngày</span>
                                </label>
                            </div>

                            <div class="mb-4">
                                <label for="eventColor" class="block text-sm font-medium text-gray-700 mb-1">Màu sắc</label>
                                <select id="eventColor" name="color" 
                                        class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                    <option value="#3b82f6">Xanh dương</option>
                                    <option value="#ef4444">Đỏ</option>
                                    <option value="#10b981">Xanh lá</option>
                                    <option value="#f59e0b">Cam</option>
                                    <option value="#8b5cf6">Tím</option>
                                    <option value="#ec4899">Hồng</option>
                                </select>
                            </div>

                            <div class="mb-4">
                                <label for="eventCalendar" class="block text-sm font-medium text-gray-700 mb-1">Calendar</label>
                                <select id="eventCalendar" name="calendarId" required
                                        class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                    <!-- Sẽ được populate bằng JavaScript -->
                                </select>
                            </div>
                        </form>
                        <div class="flex justify-end p-6 border-t">
                            <button id="cancelCreateEvent" class="bg-gray-300 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-400 mr-2">
                                Hủy
                            </button>
                            <button id="saveEvent" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                                Tạo Event
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- FullCalendar JS -->
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.2/main.min.js"></script>

        <script>

            // Debug: Kiểm tra dữ liệu từ server
            var eventsJsonFromServer = document.getElementById('debugEventsJson').value;
            console.log('Events JSON from server:', eventsJsonFromServer);

            // Lấy dữ liệu events từ server
            var events = [];
            try {
                events = JSON.parse(eventsJsonFromServer);
                console.log('Parsed events successfully:', events);
            } catch (e) {
                console.error('Error parsing events JSON:', e);
                console.log('Raw JSON string:', eventsJsonFromServer);
                events = [];
            }

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
                businessHours: false,
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

            // Function để load events động
            function loadEvents(calendarId) {
                console.log('Loading events for calendar ID:', calendarId);
                fetch('calendar?action=getEvents&calendarId=' + calendarId)
                        .then(response => {
                            console.log('Response status:', response.status);
                            return response.json();
                        })
                        .then(data => {
                            console.log('Loaded events from server:', data);
                            events = data;
                            calendar.refetchEvents();
                        })
                        .catch(error => {
                            console.error('Error loading events:', error);
                        });
            }

            // Make calendar accessible globally
            window.calendar = calendar;
            window.loadEvents = loadEvents;

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

            // Create Event Modal Functions
            function showCreateEventModal() {
                // Set default date to today
                const today = new Date().toISOString().split('T')[0];
                $('#eventStartDate').val(today);
                $('#eventEndDate').val(today);

                // Populate calendar dropdown
                populateCalendarDropdown();

                // Show modal
                $('#createEventModal').removeClass('hidden');
            }

            function populateCalendarDropdown() {
                const calendarSelect = $('#eventCalendar');
                calendarSelect.empty();
                
                // Use JSTL to populate calendar options
                <c:choose>
                    <c:when test="${not empty calendars}">
                        <c:forEach var="calendar" items="${calendars}">
                            calendarSelect.append('<option value="${calendar.idCalendar}">${calendar.name}</option>');
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        calendarSelect.append('<option value="">Không có calendar</option>');
                    </c:otherwise>
                </c:choose>
                
                console.log('Calendar dropdown populated using JSTL');
            }

            function hideCreateEventModal() {
                $('#createEventModal').addClass('hidden');
                $('#createEventForm')[0].reset();
            }

            // Event handlers for create modal
            $('#closeCreateModal, #cancelCreateEvent').on('click', function () {
                hideCreateEventModal();
            });

            $('#createEventModal').on('click', function (e) {
                if (e.target === this) {
                    hideCreateEventModal();
                }
            });

            // Handle all-day checkbox
            $('#eventAllDay').on('change', function () {
                const isAllDay = $(this).is(':checked');
                if (isAllDay) {
                    $('#eventStartTime, #eventEndTime').prop('disabled', true).val('');
                } else {
                    $('#eventStartTime, #eventEndTime').prop('disabled', false);
                }
            });

            // Handle end date auto-fill
            $('#eventStartDate').on('change', function () {
                const startDate = $(this).val();
                if (startDate && !$('#eventEndDate').val()) {
                    $('#eventEndDate').val(startDate);
                }
            });

            // Save event
            $('#saveEvent').on('click', function () {
                const formData = new FormData($('#createEventForm')[0]);

                // Validate required fields
                if (!formData.get('title') || !formData.get('startDate') || !formData.get('calendarId')) {
                    alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                    return;
                }

                // Prepare event data
                const eventData = {
                    title: formData.get('title'),
                    description: formData.get('description'),
                    location: formData.get('location'),
                    startDate: formData.get('startDate'),
                    startTime: formData.get('startTime'),
                    endDate: formData.get('endDate'),
                    endTime: formData.get('endTime'),
                    allDay: formData.get('allDay') === 'on',
                    color: formData.get('color'),
                    calendarId: formData.get('calendarId')
                };

                // Create start and end datetime
                let startDateTime = eventData.startDate;
                let endDateTime = eventData.endDate || eventData.startDate;

                if (!eventData.allDay && eventData.startTime) {
                    startDateTime += 'T' + eventData.startTime;
                }
                if (!eventData.allDay && eventData.endTime) {
                    endDateTime += 'T' + eventData.endTime;
                }

                // Create new event object for FullCalendar
                const newEvent = {
                    id: Date.now(), // Temporary ID
                    title: eventData.title,
                    start: startDateTime,
                    end: endDateTime,
                    color: eventData.color,
                    allDay: eventData.allDay,
                    description: eventData.description,
                    location: eventData.location
                };

                // Send to server via AJAX
                $.ajax({
                    url: 'event',
                    type: 'POST',
                    data: {
                        action: 'create',
                        title: eventData.title,
                        description: eventData.description,
                        location: eventData.location,
                        startDate: eventData.startDate,
                        startTime: eventData.startTime,
                        endDate: eventData.endDate,
                        endTime: eventData.endTime,
                        allDay: eventData.allDay ? 'on' : 'off',
                        color: eventData.color,
                        calendarId: eventData.calendarId
                    },
                    success: function (response) {
                        try {
                            const result = JSON.parse(response);
                            if (result.success) {
                                // Hide modal and show success message
                                hideCreateEventModal();
                                alert('Event đã được tạo thành công!');
                                
                                // Load fresh events from server instead of adding to local array
                                const currentCalendarId = $('#eventCalendar').val() || '${calendarId}';
                                loadEvents(currentCalendarId);
                            } else {
                                alert('Lỗi: ' + (result.error || 'Không thể tạo event'));
                            }
                        } catch (e) {
                            console.error('Error parsing response:', e);
                            alert('Lỗi khi xử lý phản hồi từ server');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('AJAX Error:', error);
                        alert('Lỗi khi gửi dữ liệu đến server');
                    }
                });
            });

            // Make functions globally accessible
            window.showCreateEventModal = showCreateEventModal;
            window.hideCreateEventModal = hideCreateEventModal;
        </script>
    </body>
</html>
