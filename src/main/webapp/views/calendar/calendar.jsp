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
            <!-- Add ToDo Modal -->
            <div id="addTodoModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden z-50">
                <div class="flex items-center justify-center min-h-screen p-4">
                    <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
                        <div class="flex justify-between items-center p-6 border-b">
                            <h3 class="text-lg font-semibold text-gray-900">Tạo ToDo mới</h3>
                            <button id="closeAddTodoModal" class="text-gray-400 hover:text-gray-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                                </svg>
                            </button>
                        </div>
                        <form id="addTodoForm" class="p-6">
                            <div class="mb-4">
                                <label for="todoTitle" class="block text-sm font-medium text-gray-700 mb-1">Tiêu đề *</label>
                                <input type="text" id="todoTitle" name="title" required class="w-full px-3 py-2 border border-gray-300 rounded-md" placeholder="Nhập tiêu đề">
                            </div>
                            <div class="mb-4">
                                <label for="todoDescription" class="block text-sm font-medium text-gray-700 mb-1">Mô tả</label>
                                <textarea id="todoDescription" name="description" rows="2" class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                            </div>
                            <div class="grid grid-cols-2 gap-4 mb-4">
                                <div>
                                    <label for="todoDueDate" class="block text-sm font-medium text-gray-700 mb-1">Ngày đến hạn *</label>
                                    <input type="date" id="todoDueDate" name="dueDate" required class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                </div>
                                <div>
                                    <label for="todoDueTime" class="block text-sm font-medium text-gray-700 mb-1">Giờ đến hạn</label>
                                    <input type="time" id="todoDueTime" name="dueTime" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                </div>
                            </div>
                            <div class="mb-4">
                                <label class="flex items-center">
                                    <input type="checkbox" id="todoAllDay" name="isAllDay" class="mr-2">
                                    <span class="text-sm text-gray-700">Cả ngày</span>
                                </label>
                            </div>
                            <div class="mb-4">
                                <label for="todoTaskId" class="block text-sm font-medium text-gray-700 mb-1">Task</label>
                                <select id="todoTaskId" name="taskId" class="w-full px-3 py-2 border border-gray-300 rounded-md" required>
                                    <option value="">-- Chọn Task --</option>
                                    <c:forEach var="task" items="${tasks}">
                                        <option value="${task.idTask}">${task.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </form>
                        <div class="flex justify-end p-6 border-t">
                            <button id="swapToEvent" class="bg-gray-300 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-400 mr-2">
                                Tạo Event
                            </button>
                            <button id="saveTodo" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                                Thêm ToDo
                            </button>
                        </div>
                    </div>
                </div>
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
                            <div class="flex items-center mb-2">
                                <span id="modalColorDot" class="w-3 h-3 rounded-full mr-2 inline-block"></span>
                                <span id="modalTitle" class="text-xl font-semibold text-gray-900"></span>
                            </div>
                            <div class="mb-2 text-gray-700 text-sm" id="modalTime"></div>
                            <div class="mb-2 text-gray-700 text-sm" id="modalRRule"></div>
                            <div class="flex items-center mb-2 text-gray-700 text-sm">
                                <svg class="w-5 h-5 mr-1 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V4a2 2 0 10-4 0v1.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                                </svg>
                                <span id="modalRemindBefore"></span>
                            </div>
                            <div class="flex items-center text-gray-700 text-sm">
                                <svg class="w-5 h-5 mr-1 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                                <span id="modalCalendarName"></span>
                            </div>
                        </div>
                        <div class="flex justify-end p-6 border-t">
                            <button id="editEvent" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 mr-2">
                                Sửa Event
                            </button>
                            <button id="deleteEvent" class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 mr-2">
                                Xóa Event
                            </button>
                            <button id="completeTodo" class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 mr-2 hidden">
                                Hoàn thành
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
                                <label for="eventLocation" class="block text-sm font-medium text-gray-700 mb-1">Địa điểm</label>
                                <input type="text" id="eventLocation" name="location"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                            </div>


                            <div class="mb-4">
                                <label for="eventDescription" class="block text-sm font-medium text-gray-700 mb-1">Mô tả</label>
                                <textarea id="eventDescription" name="description" rows="1"
                                          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
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
                            <button id="swapToTodo" class="bg-gray-300 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-400 mr-2">
                                Tạo ToDo
                            </button>
                            <button id="otherOptionsBtn" class="bg-gray-300 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-400 mr-2">
                                Tùy chọn Khác
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
        <!-- rrule lib -->
        <script src='https://cdn.jsdelivr.net/npm/rrule@2.6.4/dist/es5/rrule.min.js'></script>
        <!-- the rrule-to-fullcalendar connector. must go AFTER the rrule lib -->
        <script src='https://cdn.jsdelivr.net/npm/@fullcalendar/rrule@5.11.5/main.global.min.js'></script>

        <script>

            // ====== BIẾN TOÀN CỤC ======
            var events = [];
            var todos = [];
            var visibleCalendars = new Set();
            // Biến lưu ngày/giờ cuối cùng được chọn từ dateClick
            var lastClickedDate = null;
            var lastClickedTime = null;

            // ====== FILTER TODO EVENTS ======
            var visibleTodos = new Set();
            function filterTodoEvents(taskId, isVisible) {
                if (isVisible) {
                    visibleTodos.add(taskId);
                } else {
                    visibleTodos.delete(taskId);
                }
                calendar.refetchEvents();
            }
            window.filterTodoEvents = filterTodoEvents;

            // ====== KHỞI TẠO CALENDAR ======
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                headerToolbar: false,
                locale: 'vi',
                buttonText: {
                    today: 'Hôm nay', month: 'Tháng', week: 'Tuần', day: 'Ngày', list: 'Danh sách'
                },
                titleFormat: {year: 'numeric', month: 'long'},
                nowIndicator: true,
                initialDate: new Date(),
                navLinks: true,
                businessHours: false,
                editable: true,
                selectable: true,
                droppable: true,
                dayMaxEventRows: true,
                eventClick: function (info) {
                    showEventModal(info.event);
                },
                eventDrop: function (info) {
                    // Lấy thông tin mới
                    const eventId = info.event.id;
                    const newStart = info.event.start ? info.event.start.toISOString() : null;
                    const newEnd = info.event.end ? info.event.end.toISOString() : null;
                    const allDay = info.event.allDay;

                    // Phân biệt Event và ToDo
                    if (/^\d+$/.test(eventId)) {
                        // Là Event, cho phép kéo thả
                        $.ajax({
                            url: 'event', // Đúng servlet xử lý update event
                            type: 'POST',
                            dataType: 'json',
                            data: {
                                action: 'updateTime',
                                eventId: eventId,
                                start: newStart,
                                end: newEnd,
                                allDay: allDay
                            },
                            success: function (response) {
                                if (response.success) {
                                    console.log('Cập nhật thời gian event thành công!');
                                } else {
                                    alert('Lỗi: ' + (response.error || 'Không thể cập nhật event'));
                                    info.revert(); // Quay lại vị trí cũ nếu lỗi
                                }
                            },
                            error: function () {
                                alert('Lỗi khi gửi dữ liệu cập nhật event!');
                                info.revert(); // Quay lại vị trí cũ nếu lỗi
                            }
                        });
                    } else if (/^todo-\d+$/.test(eventId)) {
                        // Là ToDo, cho phép kéo thả và cập nhật thời gian
                        $.ajax({
                            url: 'todo',
                            type: 'POST',
                            dataType: 'json',
                            data: {
                                action: 'updateTime',
                                id: eventId.replace('todo-', ''),
                                start: newStart,
                                end: newEnd,
                                allDay: allDay
                            },
                            success: function (response) {
                                if (response.success) {
                                    console.log('Cập nhật thời gian ToDo thành công!');
                                } else {
                                    alert('Lỗi: ' + (response.error || 'Không thể cập nhật ToDo'));
                                    info.revert();
                                }
                            },
                            error: function () {
                                alert('Lỗi khi gửi dữ liệu cập nhật ToDo!');
                                info.revert();
                            }
                        });
                    } else {
                        info.revert();
                        alert('ID không hợp lệ!');
                    }
                },
                eventResize: function (info) {},
                dateClick: function (info) {
                    console.log('dateStr:', info.dateStr, 'timeStr:', info.timeStr);
                    // Lấy ngày đúng định dạng yyyy-MM-dd
                    let dateOnly = info.dateStr ? info.dateStr.substring(0, 10) : '';
                    // Nếu info.timeStr có thì lấy, nếu không thì tách từ dateStr (nếu có dạng yyyy-MM-ddTHH:mm:ss)
                    let timeOnly;
                    let isAllDay = info.allDay || false;

                    if (info.timeStr && info.timeStr !== "") {
                        timeOnly = info.timeStr;
                        isAllDay = false;
                    } else if (info.dateStr && info.dateStr.length > 10 && info.dateStr.includes('T')) {
                        // Tách phần giờ từ dateStr
                        let timePart = info.dateStr.split('T')[1]; // "13:00:00+07:00"
                        if (timePart) {
                            let h_m = timePart.split(':'); // ["13", "00", "00+07:00"]
                            if (h_m.length >= 2) {
                                timeOnly = h_m[0] + ":" + h_m[1];
                            } else {
                                timeOnly = "08:00";
                            }
                        } else {
                            timeOnly = "08:00";
                        }
                    } else {
                        // Nếu ở view tháng (dateStr không có phần T), lấy giờ hiện tại
                        const now = new Date();
                        timeOnly = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
                        isAllDay = true; // Click vào all-day cell
                    }
                    lastClickedDate = dateOnly;
                    lastClickedTime = timeOnly;
                    showCreateEventModalWithDate(lastClickedDate, lastClickedTime, isAllDay);
                },
                events: function (info, successCallback) {
                    let filtered = events;
                    if (visibleCalendars.size > 0) {
                        filtered = events.filter(event => {
                            const eventCalendarId = event.calendarId || event.idCalendar;
                            return eventCalendarId && visibleCalendars.has(eventCalendarId.toString());
                        });
                    }
                    // Gộp thêm ToDo vào danh sách event
                    let filteredTodos = todos;
                    if (visibleTodos.size > 0) {
                        filteredTodos = todos.filter(todo => {
                            // todo.id dạng 'todo-123', todo.taskId là id của task
                            return todo.taskId && visibleTodos.has(todo.taskId.toString());
                        });
                    } else if (visibleTodos.size === 0 && document.querySelectorAll('.todo-checkbox').length > 0) {
                        // Nếu có todo-checkbox nhưng không có cái nào được check, ẩn hết ToDo
                        filteredTodos = [];
                    }
                    successCallback([...filtered, ...filteredTodos]);
                }
            });
            calendar.setOption('height', 860);
            calendar.render();
            window.calendar = calendar;

            // GỌI NGAY SAU KHI RENDER
            loadAllEvents();
            loadAllTodos();

            // ====== LOAD EVENTS ======
            function loadAllEvents() {
                fetch('calendar?action=getAllEvents')
                        .then(response => response.json())
                        .then(data => {
                            events = data.map(event => {
                                // SỬA DTSTART dùng giờ địa phương
                                if (event.rrule && !event.rrule.includes('DTSTART') && event.start) {
                                    const dt = new Date(event.start);
                                    const pad = n => n.toString().padStart(2, '0');
                                    const dtstart = dt.getFullYear() +
                                            pad(dt.getMonth() + 1) +
                                            pad(dt.getDate()) + 'T' +
                                            pad(dt.getHours()) +
                                            pad(dt.getMinutes()) +
                                            pad(dt.getSeconds());
                                    event.rrule = event.rrule + ';DTSTART=' + dtstart;
                                }
                                if (event.idEvent && !event.id)
                                    event.id = event.idEvent;
                                // ĐẢM BẢO allDay là boolean và đúng tên trường
                                event.allDay = (event.allDay === true || event.isAllDay === true || event.allDay === "true" || event.isAllDay === "true");
                                // ĐẢM BẢO backgroundColor đúng cho FullCalendar
                                
                                if (event.color)
                                    event.backgroundColor = event.color;
                                // THÊM TRƯỜNG DURATION theo chuẩn FullCalendar
                                if (event.start && event.end) {
                                    const start = new Date(event.start);
                                    const end = new Date(event.end);
                                    const durationMs = end - start;
                                    if (durationMs > 0) {
                                        // Tạo duration object theo chuẩn FullCalendar
                                        const totalSeconds = Math.floor(durationMs / 1000);
                                        const hours = Math.floor(totalSeconds / 3600);
                                        const minutes = Math.floor((totalSeconds % 3600) / 60);
                                        const seconds = totalSeconds % 60;
                                        
                                        // Format 1: Object với milliseconds (chuẩn FullCalendar)
                                        event.duration = {
                                            milliseconds: durationMs
                                        };
                                        
                                    }
                                }

                                
                                console.log('[LOG] Danh sách events hiện tại:', event); // <-- Thêm dòng này
                                return event;
                            });

                            calendar.refetchEvents();
                        });
            }


            function loadEvents(calendarId) {
                fetch('calendar?action=getEvents&calendarId=' + calendarId)
                        .then(response => response.json())
                        .then(data => {
                            events = data.map(event => {
                                if (event.rrule && !event.rrule.includes('DTSTART') && event.start) {
                                    const dt = new Date(event.start);
                                    const pad = n => n.toString().padStart(2, '0');
                                    const dtstart = dt.getUTCFullYear() +
                                            pad(dt.getUTCMonth() + 1) +
                                            pad(dt.getUTCDate()) + 'T' +
                                            pad(dt.getUTCHours()) +
                                            pad(dt.getUTCMinutes()) +
                                            pad(dt.getUTCSeconds()) + 'Z';
                                    event.rrule = event.rrule + ';DTSTART=' + dtstart;
                                }
                                if (event.idEvent && !event.id)
                                    event.id = event.idEvent;
                                console.log('[LOG] Event thêm vào FullCalendar:', event);
                                return event;
                            });
                            calendar.refetchEvents();
                        });
            }


            // ====== LOAD TODOS ======
            function loadAllTodos() {
                fetch('todo?action=getAllTodos')
                        .then(response => response.json())
                        .then(data => {
                            todos = data.map(todo => {
                                const mapped = {
                                    id: 'todo-' + todo.idTodo,
                                    title: '[ToDo] ' + todo.title,
                                    start: todo.dueDate,
                                    allDay: todo.isAllDay,
                                    color: todo.isCompleted ? '#10b981' : '#f59e0b',
                                    description: todo.description || '',
                                    taskId: todo.taskId // <-- Đảm bảo có trường này!
                                };
                                console.log('[LOG] ToDo thêm vào FullCalendar:', todo);
                                return mapped;
                            });
                            calendar.refetchEvents();
                        });
            }

            // ====== FILTER CALENDAR ======
            function initializeVisibleCalendars() {
                document.querySelectorAll('.calendar-checkbox:checked').forEach(checkbox => {
                    const calendarId = checkbox.getAttribute('data-calendar-id');
                    visibleCalendars.add(calendarId);
                });
            }
            function filterCalendarEvents(calendarId, isVisible) {
                if (calendarId) {
                    isVisible ? visibleCalendars.add(calendarId) : visibleCalendars.delete(calendarId);
                }
                calendar.refetchEvents();
            }
            document.addEventListener('DOMContentLoaded', function () {
                setTimeout(function () {
                    initializeVisibleCalendars();
                    filterCalendarEvents(null, true);
                }, 500);
            });
            window.filterCalendarEvents = filterCalendarEvents;

            // ====== MODAL & FORM ======
            // Hàm chuyển RRULE sang mô tả tiếng Việt thân thiện
            function parseRRuleToText(rruleStr) {
                if (!rruleStr)
                    return 'Không lặp lại';
                // Tách các phần của rrule
                const parts = {};
                rruleStr.split(';').forEach(pair => {
                    const [k, v] = pair.split('=');
                    if (k && v)
                        parts[k.toUpperCase()] = v;
                });

                let text = '';
                switch (parts['FREQ']) {
                    case 'DAILY':
                        text = 'Lặp lại hàng ngày';
                        break;
                    case 'WEEKLY':
                        if (parts['BYDAY']) {
                            // Chuyển mã ngày sang tiếng Việt
                            const days = {
                                MO: 'Thứ 2', TU: 'Thứ 3', WE: 'Thứ 4', TH: 'Thứ 5', FR: 'Thứ 6', SA: 'Thứ 7', SU: 'Chủ nhật'
                            };
                            const byday = parts['BYDAY'].split(',').map(d => days[d] || d).join(', ');
                            text = 'Lặp lại hàng tuần vào ' + byday;
                        } else {
                            text = 'Lặp lại hàng tuần';
                        }
                        break;
                    case 'MONTHLY':
                        if (parts['BYMONTHDAY']) {
                            text = 'Lặp lại hàng tháng vào ngày ' + parts['BYMONTHDAY'];
                        } else {
                            text = 'Lặp lại hàng tháng';
                        }
                        break;
                    case 'YEARLY':
                        if (parts['BYMONTH'] && parts['BYMONTHDAY']) {
                            text = `Lặp lại hàng năm vào ngày ${parts['BYMONTHDAY']}/${parts['BYMONTH']}`;
                        } else {
                            text = 'Lặp lại hàng năm';
                        }
                        break;
                    default:
                        text = 'Lặp lại';
                }
                return text;
            }
            function showEventModal(event) {
                // Tìm event gốc trong mảng events
                let original = events.find(e => e.id == event.id);
                if (!original)
                    original = event;

                $('#modalTitle').text(event.title);
                $('#modalTime').text(formatEventTime(event));
                $('#modalColorDot').css('background-color', event.backgroundColor || event.color);

                // Hiển thị lặp lại thân thiện
                $('#modalRRule').text(parseRRuleToText(original.rrule));
                // Hiển thị remindBefore
                if (original.remindBefore && original.remindBefore > 0) {
                    let unit = original.remindUnit ? original.remindUnit : 'phút';
                    $('#modalRemindBefore').text(original.remindBefore + ' ' + unit + ' trước');
                } else {
                    $('#modalRemindBefore').text('Không nhắc');
                }
                // Hiển thị tên calendar
                $('#modalCalendarName').text(original.calendarName || '');

                // Phân biệt Event hay ToDo
                if (event.id && (typeof event.id === 'string') && event.id.startsWith('todo-')) {
                    // Là ToDo
                    $('#deleteEvent').text('Xóa ToDo');
                    $('#editEvent').addClass('hidden'); // Ẩn nút sửa cho ToDo
                    $('#completeTodo').removeClass('hidden'); // Hiển thị nút hoàn thành
                    $('#closeModalBtn').addClass('hidden'); // Ẩn nút đóng
                    
                    $('#deleteEvent').off('click').on('click', function () {
                        if (confirm('Bạn có chắc chắn muốn xóa ToDo này?')) {
                            $.ajax({
                                url: 'todo',
                                type: 'POST',
                                dataType: 'json',
                                data: {action: 'deleteTodo', id: event.id.replace('todo-', '')},
                                success: function (response) {
                                    if (response.success) {
                                        todos = todos.filter(t => t.id !== event.id);
                                        calendar.refetchEvents();
                                        $('#eventModal').addClass('hidden');
                                        alert('ToDo đã được xóa thành công!');
                                    } else {
                                        alert('Lỗi: ' + (response.error || 'Không thể xóa ToDo'));
                                    }
                                },
                                error: function () {
                                    alert('Lỗi khi gửi yêu cầu xóa ToDo');
                                }
                            });
                        }
                    });
                    
                    // Xử lý nút hoàn thành ToDo
                    $('#completeTodo').off('click').on('click', function () {
                        if (confirm('Bạn có chắc chắn muốn hoàn thành ToDo này?')) {
                            $.ajax({
                                url: 'todo',
                                type: 'POST',
                                dataType: 'json',
                                data: {action: 'completeTodo', id: event.id.replace('todo-', '')},
                                success: function (response) {
                                    if (response.success) {
                                        // Cập nhật trạng thái ToDo trong mảng todos
                                        const todoIndex = todos.findIndex(t => t.id === event.id);
                                        if (todoIndex !== -1) {
                                            todos[todoIndex].color = '#10b981'; // Màu xanh lá cho ToDo đã hoàn thành
                                        }
                                        calendar.refetchEvents();
                                        $('#eventModal').addClass('hidden');
                                        alert('ToDo đã được hoàn thành thành công!');
                                    } else {
                                        alert('Lỗi: ' + (response.error || 'Không thể hoàn thành ToDo'));
                                    }
                                },
                                error: function () {
                                    alert('Lỗi khi gửi yêu cầu hoàn thành ToDo');
                                }
                            });
                        }
                    });
                } else {
                    // Là Event
                    $('#deleteEvent').text('Xóa Event');
                    $('#editEvent').removeClass('hidden'); // Hiển thị nút sửa cho Event
                    $('#completeTodo').addClass('hidden'); // Ẩn nút hoàn thành
                    $('#closeModalBtn').removeClass('hidden'); // Hiển thị nút đóng
                    
                    $('#deleteEvent').off('click').on('click', function () {
                        var eventId = event.id;
                        if (confirm('Bạn có chắc chắn muốn xóa event này?')) {
                            $.ajax({
                                url: 'event', type: 'POST', dataType: 'json',
                                data: {action: 'delete', eventId: eventId},
                                success: function (response) {
                                    if (response.success) {
                                        events = events.filter(e => e.id != eventId);
                                        calendar.refetchEvents();
                                        $('#eventModal').addClass('hidden');
                                        alert('Event đã được xóa thành công!');
                                    } else
                                        alert('Lỗi: ' + (response.error || 'Không thể xóa event'));
                                },
                                error: function () {
                                    alert('Lỗi khi xóa event');
                                }
                            });
                        }
                    });
                }

                $('#eventModal').removeClass('hidden');
                $('#deleteEvent').data('eventId', event.id);
                $('#editEvent').data('eventId', event.id);
            }
            function formatEventTime(event) {
                var start = new Date(event.start);
                var end = event.end ? new Date(event.end) : null;
                var weekdays = ['Chủ nhật', 'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy'];
                var weekday = weekdays[start.getDay()];
                var day = start.getDate();
                var month = start.getMonth() + 1;
                var hour = start.getHours();
                var minute = start.getMinutes();
                var ampm = hour >= 12 ? 'PM' : 'AM';
                var hour12 = hour % 12;
                if (hour12 === 0)
                    hour12 = 12;
                var startTimeStr = hour12 + ':' + String(minute).padStart(2, '0') + ampm;
                var result = weekday + ', ' + day + ' tháng ' + month;
                if (end) {
                    var endHour = end.getHours();
                    var endMinute = end.getMinutes();
                    var endAmpm = endHour >= 12 ? 'PM' : 'AM';
                    var endHour12 = endHour % 12;
                    if (endHour12 === 0)
                        endHour12 = 12;
                    var endTimeStr = endHour12 + ':' + String(endMinute).padStart(2, '0') + endAmpm;
                    result += '⋅' + startTimeStr + ' – ' + endTimeStr;
                } else {
                    result += '⋅' + startTimeStr;
                }
                return result;
            }
            $('#closeModal, #closeModalBtn').on('click', function () {
                $('#eventModal').addClass('hidden');
            });
            $('#eventModal').on('click', function (e) {
                if (e.target === this)
                    $(this).addClass('hidden');
            });
            // Nút 'Tùy chọn khác' trong modal tạo event
            $('#otherOptionsBtn').on('click', function () {
                // Lấy giá trị từ modal
                var startDate = $('#eventStartDate').val();
                var startTime = $('#eventStartTime').val();
                var endDate = $('#eventEndDate').val();
                var endTime = $('#eventEndTime').val();
                // Chuyển trang và truyền giá trị
                window.location.href = 'event?action=addForm'
                        + '&startDate=' + encodeURIComponent(startDate)
                        + '&startTime=' + encodeURIComponent(startTime)
                        + '&endDate=' + encodeURIComponent(endDate)
                        + '&endTime=' + encodeURIComponent(endTime);
            });

            // Nút 'Sửa Event' trong modal chi tiết event
            $('#editEvent').on('click', function () {
                var eventId = $(this).data('eventId');
                if (eventId) {
                    window.location.href = 'event?action=editEvent&id=' + eventId;
                }
            });

            // ====== CREATE EVENT MODAL ======
            function showCreateEventModal() {
                // Set default date to today
                const today = new Date().toISOString().split('T')[0];
                $('#eventStartDate').val(today);
                $('#eventEndDate').val(today);
                autoFillDefaultTimes();
                populateCalendarDropdown();
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

            }

            // Show create event modal with specific date
            function showCreateEventModalWithDate(selectedDate, selectedTime, isAllDay) {
                $('#eventStartDate').val(selectedDate);
                $('#eventEndDate').val(selectedDate);

                if (isAllDay) {
                    $('#eventAllDay').prop('checked', true);
                    $('#eventStartTime, #eventEndTime').prop('disabled', true).val('');
                } else {
                    $('#eventAllDay').prop('checked', false);
                    if (selectedTime) {
                        $('#eventStartTime').val(selectedTime);
                        // Set end time mặc định sau 1 tiếng
                        let [h, m] = selectedTime.split(':');
                        let endHour = (parseInt(h) + 1) % 24;
                        $('#eventEndTime').val(endHour.toString().padStart(2, '0') + ':' + m);
                    } else {
                        autoFillDefaultTimes();
                    }
                    $('#eventStartTime, #eventEndTime').prop('disabled', false);
                }
                populateCalendarDropdown();
                $('#createEventModal').removeClass('hidden');
            }

            // Show edit event modal
            function showEditEventModal(event) {
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
            }

            function populateEditCalendarDropdown() {
                const calendarSelect = $('#editEventCalendar');
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
            $('#closeCreateModal').on('click', function () {
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
            });

            // Handle all-day checkbox for edit modal
            $('#editEventAllDay').on('change', function () {
                const isAllDay = $(this).is(':checked');
                if (isAllDay) {
                    $('#editEventStartTime, #editEventEndTime').prop('disabled', true).val('');
                } else {
                    $('#editEventStartTime, #editEventEndTime').prop('disabled', false);
                }
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

                $.ajax({
                    url: 'event',
                    type: 'POST',
                    dataType: 'json',
                    data: ajaxData,
                    success: function (response) {
                        if (response.success) {
                            // Reload all events from server
                            loadAllEvents();
                            hideEditEventModal();
                            alert('Event đã được cập nhật thành công!');
                        } else {
                            alert('Lỗi: ' + (response.error || 'Không thể cập nhật event'));
                        }
                    },
                    error: function (xhr, status, error) {
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

            // Swap từ Create Event sang Create Todo
            $('#swapToTodo').on('click', function () {
                $('#createEventModal').addClass('hidden');
                // Khi chuyển sang modal ToDo, truyền ngày/giờ cuối cùng được chọn nếu có
                showAddTodoModal(lastClickedDate, lastClickedTime);
            });
            // Swap từ Create Todo sang Create Event
            $('#swapToEvent').on('click', function () {
                $('#addTodoModal').addClass('hidden');
                $('#createEventModal').removeClass('hidden');
                // Nếu muốn truyền ngày/giờ, có thể lấy giá trị từ form todo và set cho form event ở đây
            });
        </script>
        <!-- Đóng modal tạo event khi click ra ngoài vùng modal -->
        <script>
            $(function () {
                $('#createEventModal').on('mousedown', function (e) {
                    if (e.target === this || $(e.target).hasClass('flex')) {
                        hideCreateEventModal();
                    }
                });
            });
        </script>
        <script>
            function showAddTodoModal(selectedDate, selectedTime) {
                // Gọi API lấy tasks
                fetch('task?action=getAllTasks')
                        .then(response => response.json())
                        .then(tasks => {
                            var $taskSelect = $('#todoTaskId');
                            $taskSelect.empty();
                            $taskSelect.append('<option value="">-- Chọn Task --</option>');
                            tasks.forEach(function (task) {
                                $taskSelect.append('<option value="' + task.idTask + '">' + task.name + '</option>');
                            });
                            // Tự động chọn task đầu tiên nếu muốn
                            if ($taskSelect.find('option').length > 1) {
                                $taskSelect.val($taskSelect.find('option').eq(1).val());
                            }
                        });

                $('#addTodoModal').removeClass('hidden');
                if (selectedDate) {
                    $('#todoDueDate').val(selectedDate);
                } else {
                    $('#todoDueDate').val(new Date().toISOString().split('T')[0]);
                }
                if (selectedTime) {
                    $('#todoDueTime').val(selectedTime);
                } else {
                    const now = new Date();
                    $('#todoDueTime').val(now.toTimeString().slice(0, 5));
                }
            }
        </script>
        <!-- Đóng modal khi bấm nút X -->
        <script>
            $('#closeAddTodoModal').on('click', function () {
                $('#addTodoModal').addClass('hidden');
                $('#addTodoForm')[0].reset();
            });

            // Đóng modal khi click ra ngoài vùng modal
            $('#addTodoModal').on('mousedown', function (e) {
                if (e.target === this || $(e.target).hasClass('flex')) {
                    $('#addTodoModal').addClass('hidden');
                    $('#addTodoForm')[0].reset();
                }
            });
        </script>
        <!-- Đóng modal xem chi tiết event khi click overlay hoặc vùng flex -->
        <script>
            $('#eventModal').on('mousedown', function (e) {
                if (e.target === this || $(e.target).hasClass('flex')) {
                    $('#eventModal').addClass('hidden');
                }
            });
        </script>
        <script>
            $('#saveTodo').on('click', function () {
                // Lấy dữ liệu từ form
                const formData = {
                    title: $('#todoTitle').val(),
                    description: $('#todoDescription').val(),
                    dueDate: $('#todoDueDate').val(),
                    dueTime: $('#todoDueTime').val(),
                    isAllDay: $('#todoAllDay').is(':checked'),
                    taskId: $('#todoTaskId').val()
                };

                // Kiểm tra dữ liệu bắt buộc
                if (!formData.title || !formData.dueDate || !formData.taskId) {
                    alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                    return;
                }

                // Gửi AJAX lên server để tạo ToDo mới
                $.ajax({
                    url: 'todo', // <-- Đúng servlet xử lý createTodo
                    type: 'POST',
                    dataType: 'json',
                    data: {
                        action: 'createTodo',
                        title: formData.title,
                        description: formData.description,
                        dueDate: formData.dueDate,
                        dueTime: formData.dueTime,
                        isAllDay: formData.isAllDay ? 'on' : 'off',
                        taskId: formData.taskId
                    },
                    success: function (response) {
                        if (response.success) {
                            alert('ToDo đã được tạo thành công!');
                            $('#addTodoModal').addClass('hidden');
                            $('#addTodoForm')[0].reset();
                            loadAllTodos(); // <--- Thêm dòng này để reload danh sách ToDo
                        } else {
                            alert('Lỗi: ' + (response.error || 'Không thể tạo ToDo'));
                        }
                    },
                    error: function () {
                        alert('Lỗi khi gửi dữ liệu đến server');
                    }
                });
            });


        </script>
    </body>
</html>
