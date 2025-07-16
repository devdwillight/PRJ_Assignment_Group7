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
            var visibleCalendars = new Set();

            // ====== KHỞI TẠO CALENDAR ======
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                headerToolbar: false,
                locale: 'vi',
                buttonText: {
                    today: 'Hôm nay', month: 'Tháng', week: 'Tuần', day: 'Ngày', list: 'Danh sách'
                },
                titleFormat: {year: 'numeric', month: 'long'},
                initialDate: new Date(),
                navLinks: true,
                businessHours: false,
                editable: true,
                selectable: true,
                droppable: true,
                dayMaxEventRows: true,
                eventClick: function (info) { showEventModal(info.event); },
                eventDrop: function (info) {},
                eventResize: function (info) {},
                dateClick: function (info) { showCreateEventModalWithDate(info.dateStr); },
                events: function (info, successCallback) {
                    let filtered = events;
                    if (visibleCalendars.size > 0) {
                        filtered = events.filter(event => {
                            const eventCalendarId = event.calendarId || event.idCalendar;
                            return eventCalendarId && visibleCalendars.has(eventCalendarId.toString());
                        });
                    }
                    successCallback(filtered);
                }
            });
            calendar.setOption('height', 860);
            calendar.render();
            window.calendar = calendar;

            // GỌI NGAY SAU KHI RENDER
            loadAllEvents();

            // ====== LOAD EVENTS ======
            function loadAllEvents() {
                console.log('[Calendar] Gọi loadAllEvents');
                fetch('calendar?action=getAllEvents')
                    .then(response => response.json())
                    .then(data => {
                        // Tự động nối DTSTART vào rrule nếu thiếu
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
                            if (event.idEvent && !event.id) event.id = event.idEvent;
                            return event;
                        });
                        console.log('[Calendar] Đã load', events.length, 'events');
                        calendar.refetchEvents();
                    });
            }
            function loadEvents(calendarId) {
                console.log('[Calendar] Gọi loadEvents cho calendarId:', calendarId);
                fetch('calendar?action=getEvents&calendarId=' + calendarId)
                    .then(response => response.json())
                    .then(data => {
                        // Tự động nối DTSTART vào rrule nếu thiếu
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
                            if (event.idEvent && !event.id) event.id = event.idEvent;
                            return event;
                        });
                        console.log('[Calendar] Đã load', events.length, 'events cho calendarId:', calendarId);
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
                console.log('[Calendar] filterCalendarEvents', {calendarId, isVisible, visibleCalendars: Array.from(visibleCalendars)});
                if (calendarId) {
                    isVisible ? visibleCalendars.add(calendarId) : visibleCalendars.delete(calendarId);
                }
                calendar.refetchEvents();
            }
            document.addEventListener('DOMContentLoaded', function() {
                setTimeout(function() {
                    initializeVisibleCalendars();
                    filterCalendarEvents(null, true);
                }, 500);
            });
            window.filterCalendarEvents = filterCalendarEvents;

            // ====== MODAL & FORM ======
            // Hàm chuyển RRULE sang mô tả tiếng Việt thân thiện
            function parseRRuleToText(rruleStr) {
                if (!rruleStr) return 'Không lặp lại';
                // Tách các phần của rrule
                const parts = {};
                rruleStr.split(';').forEach(pair => {
                    const [k, v] = pair.split('=');
                    if (k && v) parts[k.toUpperCase()] = v;
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
                if (!original) original = event;

                $('#modalTitle').text(event.title);
                $('#modalTime').text(formatEventTime(event));
                $('#modalColorDot').css('background-color', event.backgroundColor || event.color);

                // Hiển thị lặp lại thân thiện
                $('#modalRRule').text(parseRRuleToText(original.rrule));
                // Hiển thị remindBefore
                if(original.remindBefore && original.remindBefore > 0) {
                  let unit = original.remindUnit ? original.remindUnit : 'phút';
                  $('#modalRemindBefore').text(original.remindBefore + ' ' + unit + ' trước');
                } else {
                  $('#modalRemindBefore').text('Không nhắc');
                }
                // Hiển thị tên calendar
                $('#modalCalendarName').text(original.calendarName || '');

                $('#eventModal').removeClass('hidden');
                $('#deleteEvent').data('eventId', event.id);
                $('#editEvent').data('eventId', event.id);
            }
            function formatEventTime(event) {
                // Format: 'Thứ hai, 14 tháng 7⋅10:00 – 10:30AM'
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
                if (hour12 === 0) hour12 = 12;
                var startTimeStr = hour12 + ':' + String(minute).padStart(2, '0') + ampm;
                var result = weekday + ', ' + day + ' tháng ' + month;
                if (end) {
                    var endHour = end.getHours();
                    var endMinute = end.getMinutes();
                    var endAmpm = endHour >= 12 ? 'PM' : 'AM';
                    var endHour12 = endHour % 12;
                    if (endHour12 === 0) endHour12 = 12;
                    var endTimeStr = endHour12 + ':' + String(endMinute).padStart(2, '0') + endAmpm;
                    result += '⋅' + startTimeStr + ' – ' + endTimeStr;
                } else {
                    result += '⋅' + startTimeStr;
                }
                return result;
            }
            $('#closeModal, #closeModalBtn').on('click', function () { $('#eventModal').addClass('hidden'); });
            $('#eventModal').on('click', function (e) { if (e.target === this) $(this).addClass('hidden'); });
            $('#deleteEvent').on('click', function () {
                var eventId = $(this).data('eventId');
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
                            } else alert('Lỗi: ' + (response.error || 'Không thể xóa event'));
                        },
                        error: function () { alert('Lỗi khi xóa event'); }
                    });
                }
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
                    window.location.href = 'event?action=addForm&id=' + eventId;
                }
            });

            // ====== CREATE EVENT MODAL ======
            function showCreateEventModal() {
                console.log('[Calendar] showCreateEventModal');
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
                console.log('[Calendar] showEditEventModal', event);
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
        </script>
        <!-- Đóng modal tạo event khi click ra ngoài vùng modal -->
        <script>
            $(function() {
                $('#createEventModal').on('mousedown', function(e) {
                    if (e.target === this || $(e.target).hasClass('flex')) {
                        hideCreateEventModal();
                    }
                });
            });
        </script>
    </body>
</html>
