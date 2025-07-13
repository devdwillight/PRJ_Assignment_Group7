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
                            <button id="editEvent" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 mr-2">
                                Sửa Event
                            </button>
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

            <!-- Edit Event Modal -->
            <div id="editEventModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden z-50">
                <div class="flex items-center justify-center min-h-screen p-4">
                    <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
                        <div class="flex justify-between items-center p-6 border-b">
                            <h3 class="text-lg font-semibold text-gray-900">Sửa Event</h3>
                            <button id="closeEditModal" class="text-gray-400 hover:text-gray-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                                </svg>
                            </button>
                        </div>
                        <form id="editEventForm" class="p-6">
                            <input type="hidden" id="editEventId" name="eventId">
                            <div class="mb-4">
                                <label for="editEventTitle" class="block text-sm font-medium text-gray-700 mb-1">Tiêu đề *</label>
                                <input type="text" id="editEventTitle" name="title" required 
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                            </div>

                            <div class="mb-4">
                                <label for="editEventDescription" class="block text-sm font-medium text-gray-700 mb-1">Mô tả</label>
                                <textarea id="editEventDescription" name="description" rows="3"
                                          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                            </div>

                            <div class="mb-4">
                                <label for="editEventLocation" class="block text-sm font-medium text-gray-700 mb-1">Địa điểm</label>
                                <input type="text" id="editEventLocation" name="location"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                            </div>

                            <div class="grid grid-cols-2 gap-4 mb-4">
                                <div>
                                    <label for="editEventStartDate" class="block text-sm font-medium text-gray-700 mb-1">Ngày bắt đầu *</label>
                                    <input type="date" id="editEventStartDate" name="startDate" required
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                </div>
                                <div>
                                    <label for="editEventStartTime" class="block text-sm font-medium text-gray-700 mb-1">Giờ bắt đầu</label>
                                    <input type="time" id="editEventStartTime" name="startTime"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                </div>
                            </div>

                            <div class="grid grid-cols-2 gap-4 mb-4">
                                <div>
                                    <label for="editEventEndDate" class="block text-sm font-medium text-gray-700 mb-1">Ngày kết thúc</label>
                                    <input type="date" id="editEventEndDate" name="endDate"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                </div>
                                <div>
                                    <label for="editEventEndTime" class="block text-sm font-medium text-gray-700 mb-1">Giờ kết thúc</label>
                                    <input type="time" id="editEventEndTime" name="endTime"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="flex items-center">
                                    <input type="checkbox" id="editEventAllDay" name="allDay" class="mr-2">
                                    <span class="text-sm text-gray-700">Cả ngày</span>
                                </label>
                            </div>

                            <div class="mb-4">
                                <label for="editEventColor" class="block text-sm font-medium text-gray-700 mb-1">Màu sắc</label>
                                <select id="editEventColor" name="color" 
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
                                <label for="editEventCalendar" class="block text-sm font-medium text-gray-700 mb-1">Calendar</label>
                                <select id="editEventCalendar" name="calendarId" required
                                        class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                    <!-- Sẽ được populate bằng JavaScript -->
                                </select>
                            </div>
                        </form>
                        <div class="flex justify-end p-6 border-t">
                            <button id="cancelEditEvent" class="bg-gray-300 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-400 mr-2">
                                Hủy
                            </button>
                            <button id="updateEvent" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                                Cập nhật Event
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
                    // Open create event modal with selected date
                    showCreateEventModalWithDate(info.dateStr);
                },

                // Events source
                events: function (info, successCallback, failureCallback) {
                    successCallback(events);
                }
            });

            calendar.setOption('height', 860);

            // Render calendar
            calendar.render();

            // Load all events from server on page load
            console.log('Loading all events for user on page load');
            loadAllEvents();

            // Function để load tất cả events của user
            function loadAllEvents() {
                console.log('Loading all events for user');
                fetch('calendar?action=getAllEvents')
                        .then(response => {
                            console.log('Response status:', response.status);
                            return response.json();
                        })
                        .then(data => {
                            console.log('Loaded all events from server:', data);
                            
                            // Ensure events have proper ID field
                            events = data.map(event => {
                                // If server returns idEvent, map it to id for FullCalendar
                                if (event.idEvent && !event.id) {
                                    event.id = event.idEvent;
                                }
                                console.log('Mapped event:', event);
                                return event;
                            });
                            
                            // Apply current filter after loading events
                            if (window.filterCalendarEvents) {
                                // Re-apply current filter
                                const filteredEvents = events.filter(function(event) {
                                    // If no calendars are visible, show all events
                                    if (visibleCalendars.size === 0) {
                                        return true;
                                    }
                                    
                                    // Check if event belongs to a visible calendar
                                    const eventCalendarId = event.calendarId || event.idCalendar;
                                    return visibleCalendars.has(eventCalendarId.toString());
                                });
                                
                                calendar.removeAllEvents();
                                calendar.addEventSource(filteredEvents);
                            } else {
                                calendar.refetchEvents();
                            }
                            
                            console.log('Calendar refreshed with', events.length, 'events');
                        })
                        .catch(error => {
                            console.error('Error loading all events:', error);
                        });
            }

            // Function để load events động theo calendar
            function loadEvents(calendarId) {
                console.log('Loading events for calendar ID:', calendarId);
                fetch('calendar?action=getEvents&calendarId=' + calendarId)
                        .then(response => {
                            console.log('Response status:', response.status);
                            return response.json();
                        })
                        .then(data => {
                            console.log('Loaded events from server:', data);
                            
                            // Ensure events have proper ID field
                            events = data.map(event => {
                                // If server returns idEvent, map it to id for FullCalendar
                                if (event.idEvent && !event.id) {
                                    event.id = event.idEvent;
                                }
                                console.log('Mapped event:', event);
                                return event;
                            });
                            
                            // Apply current filter after loading events
                            if (window.filterCalendarEvents) {
                                // Re-apply current filter
                                const filteredEvents = events.filter(function(event) {
                                    // If no calendars are visible, show all events
                                    if (visibleCalendars.size === 0) {
                                        return true;
                                    }
                                    
                                    // Check if event belongs to a visible calendar
                                    const eventCalendarId = event.calendarId || event.idCalendar;
                                    return visibleCalendars.has(eventCalendarId.toString());
                                });
                                
                                calendar.removeAllEvents();
                                calendar.addEventSource(filteredEvents);
                            } else {
                                calendar.refetchEvents();
                            }
                            
                            console.log('Calendar refreshed with', events.length, 'events');
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

                // Store event ID for both delete and edit
                $('#deleteEvent').data('eventId', event.id);
                $('#editEvent').data('eventId', event.id);
                
                console.log('Event modal opened for event:', event);
                console.log('Event ID stored:', event.id);
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
                
                console.log('Attempting to delete event with ID:', eventId);
                console.log('Event ID type:', typeof eventId);
                
                if (confirm('Bạn có chắc chắn muốn xóa event này?')) {
                    // Send delete request to server
                    const deleteData = {
                        action: 'delete',
                        eventId: eventId
                    };
                    
                    console.log('Delete request data:', deleteData);
                    console.log('Delete request URL:', 'event');
                    
                    $.ajax({
                        url: 'event',
                        type: 'POST',
                        dataType: 'json',
                        data: deleteData,
                        success: function (response) {
                            console.log('Delete response:', response);
                            if (response.success) {
                                // Remove from local events array
                                var index = events.findIndex(e => e.id == eventId);
                                if (index > -1) {
                                    events.splice(index, 1);
                                    calendar.refetchEvents();
                                }
                                $('#eventModal').addClass('hidden');
                                alert('Event đã được xóa thành công!');
                            } else {
                                alert('Lỗi: ' + (response.error || 'Không thể xóa event'));
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error('Delete AJAX Error:', error);
                            console.error('Status:', status);
                            console.error('Response Text:', xhr.responseText);
                            
                            let errorMessage = 'Lỗi khi xóa event';
                            try {
                                const response = JSON.parse(xhr.responseText);
                                if (response.error) {
                                    errorMessage = 'Lỗi: ' + response.error;
                                }
                            } catch (e) {
                                console.error('Could not parse error response:', e);
                            }
                            
                            alert(errorMessage);
                        }
                    });
                }
            });

            // Edit event
            $('#editEvent').on('click', function () {
                var eventId = $(this).data('eventId');
                var event = events.find(e => e.id == eventId);
                
                if (event) {
                    showEditEventModal(event);
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

                // Auto-fill default times
                autoFillDefaultTimes();

                // Populate calendar dropdown
                populateCalendarDropdown();

                // Show modal
                $('#createEventModal').removeClass('hidden');
            }

            // Auto-fill default times function
            function autoFillDefaultTimes() {
                const now = new Date();
                const currentHour = now.getHours().toString().padStart(2, '0');
                const currentMinute = now.getMinutes().toString().padStart(2, '0');
                const defaultStartTime = currentHour + ':' + currentMinute;
                
                // Calculate end time (1 hour later)
                const endTime = new Date(now.getTime() + 60 * 60 * 1000); // 1 hour later
                const endHour = endTime.getHours().toString().padStart(2, '0');
                const endMinute = endTime.getMinutes().toString().padStart(2, '0');
                const defaultEndTime = endHour + ':' + endMinute;
                
                $('#eventStartTime').val(defaultStartTime);
                $('#eventEndTime').val(defaultEndTime);
                
                console.log('Auto-filled times:', defaultStartTime, 'to', defaultEndTime);
            }

            // Show create event modal with specific date
            function showCreateEventModalWithDate(selectedDate) {
                // Set the selected date
                $('#eventStartDate').val(selectedDate);
                $('#eventEndDate').val(selectedDate);

                // Auto-fill default times
                autoFillDefaultTimes();

                // Populate calendar dropdown
                populateCalendarDropdown();

                // Show modal
                $('#createEventModal').removeClass('hidden');
            }

            // Show edit event modal
            function showEditEventModal(event) {
                // Set event ID
                $('#editEventId').val(event.id);
                
                // Fill form with event data
                $('#editEventTitle').val(event.title);
                $('#editEventDescription').val(event.description || '');
                $('#editEventLocation').val(event.location || '');
                $('#editEventColor').val(event.color || '#3b82f6');
                
                // Parse dates
                const startDate = new Date(event.start);
                const endDate = event.end ? new Date(event.end) : startDate;
                
                // Set dates
                $('#editEventStartDate').val(startDate.toISOString().split('T')[0]);
                $('#editEventEndDate').val(endDate.toISOString().split('T')[0]);
                
                // Set times (only if not all-day)
                if (!event.allDay) {
                    $('#editEventStartTime').val(startDate.toTimeString().slice(0, 5));
                    if (event.end) {
                        $('#editEventEndTime').val(endDate.toTimeString().slice(0, 5));
                    }
                }
                
                // Set all-day checkbox
                $('#editEventAllDay').prop('checked', event.allDay);
                
                // Set calendar
                $('#editEventCalendar').val(event.calendarId || '');
                
                // Populate calendar dropdown for edit
                populateEditCalendarDropdown();
                
                // Show modal
                $('#editEventModal').removeClass('hidden');
                $('#eventModal').addClass('hidden'); // Hide detail modal
                
                console.log('Edit modal opened for event:', event);
            }

            function populateCalendarDropdown() {
                const calendarSelect = $('#eventCalendar');
                calendarSelect.empty();

                console.log('Populating calendar dropdown...');
                console.log('Calendars from JSTL: ${calendars}');

                // Use JSTL to populate calendar options
            <c:choose>
                <c:when test="${not empty calendars}">
                console.log('Found ${calendars.size()} calendars');
                    <c:forEach var="calendar" items="${calendars}">
                console.log('Adding calendar: ${calendar.name} (ID: ${calendar.idCalendar})');
                calendarSelect.append('<option value="${calendar.idCalendar}">${calendar.name}</option>');
                    </c:forEach>
                </c:when>
                <c:otherwise>
                console.log('No calendars found');
                calendarSelect.append('<option value="">Không có calendar</option>');
                </c:otherwise>
            </c:choose>

                console.log('Calendar dropdown populated. Options count:', calendarSelect.find('option').length);
                console.log('Selected value:', calendarSelect.val());
            }

            function populateEditCalendarDropdown() {
                const calendarSelect = $('#editEventCalendar');
                calendarSelect.empty();

                console.log('Populating edit calendar dropdown...');

                // Use JSTL to populate calendar options
            <c:choose>
                <c:when test="${not empty calendars}">
                console.log('Found ${calendars.size()} calendars for edit');
                    <c:forEach var="calendar" items="${calendars}">
                console.log('Adding calendar for edit: ${calendar.name} (ID: ${calendar.idCalendar})');
                calendarSelect.append('<option value="${calendar.idCalendar}">${calendar.name}</option>');
                    </c:forEach>
                </c:when>
                <c:otherwise>
                console.log('No calendars found for edit');
                calendarSelect.append('<option value="">Không có calendar</option>');
                </c:otherwise>
            </c:choose>

                console.log('Edit calendar dropdown populated. Options count:', calendarSelect.find('option').length);
            }

            function hideCreateEventModal() {
                $('#createEventModal').addClass('hidden');
                $('#createEventForm')[0].reset();
            }

            function hideEditEventModal() {
                $('#editEventModal').addClass('hidden');
                $('#editEventForm')[0].reset();
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

            // Event handlers for edit modal
            $('#closeEditModal, #cancelEditEvent').on('click', function () {
                hideEditEventModal();
            });

            $('#editEventModal').on('click', function (e) {
                if (e.target === this) {
                    hideEditEventModal();
                }
            });

            // Handle all-day checkbox for create modal
            $('#eventAllDay').on('change', function () {
                const isAllDay = $(this).is(':checked');
                if (isAllDay) {
                    $('#eventStartTime, #eventEndTime').prop('disabled', true).val('');
                } else {
                    $('#eventStartTime, #eventEndTime').prop('disabled', false);
                    // Auto-fill times when unchecking all-day
                    autoFillDefaultTimes();
                }
                console.log('Create all-day checkbox changed:', isAllDay);
            });

            // Handle all-day checkbox for edit modal
            $('#editEventAllDay').on('change', function () {
                const isAllDay = $(this).is(':checked');
                if (isAllDay) {
                    $('#editEventStartTime, #editEventEndTime').prop('disabled', true).val('');
                } else {
                    $('#editEventStartTime, #editEventEndTime').prop('disabled', false);
                }
                console.log('Edit all-day checkbox changed:', isAllDay);
            });

            // Handle end date auto-fill
            $('#eventStartDate').on('change', function () {
                const startDate = $(this).val();
                if (startDate && !$('#eventEndDate').val()) {
                    $('#eventEndDate').val(startDate);
                }
            });

            // Update event
            $('#updateEvent').on('click', function () {
                const formData = new FormData($('#editEventForm')[0]);

                // Validate required fields
                if (!formData.get('title') || !formData.get('startDate') || !formData.get('calendarId')) {
                    alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                    return;
                }

                // Prepare event data
                const eventData = {
                    eventId: formData.get('eventId'),
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

                console.log('Edit event data prepared:', eventData);

                // Send to server via AJAX
                const ajaxData = {
                    action: 'update',
                    eventId: eventData.eventId,
                    title: eventData.title,
                    description: eventData.description,
                    location: eventData.location,
                    startDate: eventData.startDate,
                    startTime: eventData.allDay ? '' : (eventData.startTime || ''),
                    endDate: eventData.endDate || '',
                    endTime: eventData.allDay ? '' : (eventData.endTime || ''),
                    allDay: eventData.allDay ? 'on' : 'off',
                    color: eventData.color,
                    calendarId: eventData.calendarId
                };

                console.log('Update AJAX data being sent:', ajaxData);

                $.ajax({
                    url: 'event',
                    type: 'POST',
                    dataType: 'json',
                    data: ajaxData,
                    success: function (response) {
                        console.log('Update response from server:', response);

                        if (response.success) {
                            console.log('Event updated successfully, reloading events from server...');

                            // Reload all events from server
                            loadAllEvents();

                            // Hide modal and show success message
                            hideEditEventModal();
                            alert('Event đã được cập nhật thành công!');
                        } else {
                            alert('Lỗi: ' + (response.error || 'Không thể cập nhật event'));
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('Update AJAX Error:', error);
                        console.error('Status:', status);
                        console.error('Response Text:', xhr.responseText);
                        
                        let errorMessage = 'Lỗi khi cập nhật event';
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.error) {
                                errorMessage = 'Lỗi: ' + response.error;
                            }
                        } catch (e) {
                            console.error('Could not parse error response:', e);
                        }
                        
                        alert(errorMessage);
                    }
                });
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

                // Debug: Check if allDay checkbox is working correctly
                console.log('Form data debug:');
                console.log('  allDay checkbox value:', formData.get('allDay'));
                console.log('  allDay boolean:', eventData.allDay);
                console.log('  startTime value:', formData.get('startTime'));
                console.log('  endTime value:', formData.get('endTime'));

                console.log('Event data prepared:', eventData);
                console.log('Calendar ID from form:', formData.get('calendarId'));

                // Create start and end datetime
                let startDateTime = eventData.startDate;
                let endDateTime = eventData.endDate || eventData.startDate;

                if (!eventData.allDay && eventData.startTime) {
                    startDateTime += 'T' + eventData.startTime;
                }
                if (!eventData.allDay && eventData.endTime) {
                    endDateTime += 'T' + eventData.endTime;
                }

                console.log('DateTime strings created:');
                console.log('  startDateTime:', startDateTime);
                console.log('  endDateTime:', endDateTime);

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
                const ajaxData = {
                    action: 'create',
                    title: eventData.title,
                    description: eventData.description,
                    location: eventData.location,
                    startDate: eventData.startDate,
                    startTime: eventData.allDay ? '' : (eventData.startTime || ''),
                    endDate: eventData.endDate || '',
                    endTime: eventData.allDay ? '' : (eventData.endTime || ''),
                    allDay: eventData.allDay ? 'on' : 'off',
                    color: eventData.color,
                    calendarId: eventData.calendarId
                };

                // Debug: Log the exact data being sent
                console.log('AJAX data details:');
                console.log('  startDate:', ajaxData.startDate);
                console.log('  startTime:', ajaxData.startTime);
                console.log('  endDate:', ajaxData.endDate);
                console.log('  endTime:', ajaxData.endTime);
                console.log('  allDay:', ajaxData.allDay);

                console.log('AJAX data being sent:', ajaxData);

                $.ajax({
                    url: 'event',
                    type: 'POST',
                    dataType: 'json',
                    data: ajaxData,
                    success: function (response) {
                        console.log('Response from server:', response);

                        if (response.success) {
                            console.log('Event created successfully, reloading events from server...');

                            // Reload all events from server
                            loadAllEvents();

                            // Hide modal and show success message
                            hideCreateEventModal();
                            alert('Event đã được tạo thành công!');
                        } else {
                            alert('Lỗi: ' + (response.error || 'Không thể tạo event'));
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('AJAX Error:', error);
                        console.error('Status:', status);
                        console.error('Response Text:', xhr.responseText);
                        
                        let errorMessage = 'Lỗi khi gửi dữ liệu đến server';
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.error) {
                                errorMessage = 'Lỗi: ' + response.error;
                            }
                        } catch (e) {
                            console.error('Could not parse error response:', e);
                        }
                        
                        alert(errorMessage);
                    }
                });
            });

            // Calendar filtering functionality
            var visibleCalendars = new Set();
            
            // Initialize visible calendars from checked checkboxes
            function initializeVisibleCalendars() {
                const checkboxes = document.querySelectorAll('.calendar-checkbox:checked');
                checkboxes.forEach(function(checkbox) {
                    const calendarId = checkbox.getAttribute('data-calendar-id');
                    visibleCalendars.add(calendarId);
                });
                console.log('Initial visible calendars:', Array.from(visibleCalendars));
            }
            
            // Filter events based on calendar visibility
            function filterCalendarEvents(calendarId, isVisible) {
                console.log('Filtering calendar events:', calendarId, 'visible:', isVisible);
                
                if (calendarId) {
                    if (isVisible) {
                        visibleCalendars.add(calendarId);
                    } else {
                        visibleCalendars.delete(calendarId);
                    }
                }
                
                console.log('Current visible calendars:', Array.from(visibleCalendars));
                
                // Filter events and refresh calendar
                const filteredEvents = events.filter(function(event) {
                    // Nếu không có calendar nào được chọn, ẩn hết events
                    if (visibleCalendars.size === 0) {
                        return false;
                    }
                    
                    // Check if event belongs to a visible calendar
                    // Support both old format (idCalendar) and new format (calendarId)
                    const eventCalendarId = event.calendarId || event.idCalendar;
                    if (eventCalendarId && eventCalendarId !== 'null') {
                        return visibleCalendars.has(eventCalendarId.toString());
                    }
                    return false; // Hide events without calendar ID
                });
                
                console.log('Filtered events:', filteredEvents.length, 'out of', events.length);
                
                // Update calendar with filtered events
                calendar.removeAllEvents();
                calendar.addEventSource(filteredEvents);
            }
            
            // Initialize visible calendars when page loads
            document.addEventListener('DOMContentLoaded', function() {
                // Wait a bit for sidebar to load
                setTimeout(function() {
                    initializeVisibleCalendars();
                    // Show all events initially (all calendars are checked by default)
                    filterCalendarEvents(null, true);
                }, 500);
            });
            
            // Make functions globally accessible
            window.showCreateEventModal = showCreateEventModal;
            window.hideCreateEventModal = hideCreateEventModal;
            window.filterCalendarEvents = filterCalendarEvents;
        </script>
    </body>
</html>
