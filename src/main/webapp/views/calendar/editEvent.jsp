<%-- 
    Document   : editEvent
    Created on : Jul 10, 2025, 11:11:25 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Calendar" %>
<%@ page import="com.model.UserEvents" %>
<%
    UserEvents event = (UserEvents) request.getAttribute("event");
    List<Calendar> calendars = (List<Calendar>) request.getAttribute("calendars");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa sự kiện</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <div class="w-full max-w-3xl mx-auto pt-6">
            <form id="editEventForm" action="event" method="post" class="bg-white rounded-xl shadow p-8">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="eventId" value="<%= event.getIdEvent()%>" />
                <input type="hidden" name="recurrenceRule" id="recurrenceRule" value="<%= event.getRecurrenceRule() != null ? event.getRecurrenceRule() : ""%>" />
                <input type="hidden" id="isEditFlag" value="true" />
                <div class="flex items-center gap-3 mb-6">
                    <a href="<%=request.getContextPath()%>/home" class="text-gray-500 hover:text-red-500 transition-colors" title="Quay lại">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </a>
                    <input type="text" name="title" required placeholder="Tiêu đề"
                           class="border rounded px-4 py-2 flex-1 text-xl font-semibold focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100"
                           value="<%= event.getName()%>" />
                    <button type="submit"
                            class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 font-semibold">Cập nhật</button>
                </div>
                <div class="mb-6">
                    <div class="flex flex-wrap gap-2 px-10">
                        <div class="flex items-center gap-2">
                            <div>
                                <label class="block text-sm font-medium mb-1">Ngày bắt đầu</label>
                                <input type="date" name="startDate" required
                                       class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100"
                                       value="<%= event.getStartDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(event.getStartDate()) : ""%>" />
                            </div>
                        </div>
                        <div class="flex items-center gap-2">
                            <div>
                                <label class="block text-sm font-medium mb-1">Giờ bắt đầu</label>
                                <input type="time" name="startTime"
                                       class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100"
                                       value="<%= event.getStartDate() != null ? new java.text.SimpleDateFormat("HH:mm").format(event.getStartDate()) : ""%>" />
                            </div>
                        </div>
                        <div class="flex items-center mt-6">
                            <span class=" text-gray-500">-</span>
                        </div>
                        <div class="flex items-center gap-1">
                            <div>
                                <label class="block text-sm font-medium mb-1">Ngày kết thúc</label>
                                <input type="date" name="endDate"
                                       class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100"
                                       value="<%= event.getDueDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(event.getDueDate()) : ""%>" />
                            </div>
                        </div>
                        <div class="flex items-center gap-2">
                            <div>
                                <label class="block text-sm font-medium mb-1">Giờ kết thúc</label>
                                <input type="time" name="endTime"
                                       class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100"
                                       value="<%= event.getDueDate() != null ? new java.text.SimpleDateFormat("HH:mm").format(event.getDueDate()) : ""%>" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mb-6">
                    <div class="flex items-center gap-6 px-10">
                        <label class="inline-flex items-center">
                            <input type="checkbox" name="allDay" value="on" class="accent-blue-600 mr-2" <%= event.getIsAllDay() ? "checked" : ""%>> Cả ngày
                        </label>
                        <div id="recurrenceOptions" class="flex items-center gap-2">
                            <label class="text-sm">Kiểu lặp:</label>
                            <select name="recurrenceType" id="recurrenceType" class="border rounded px-3 py-2 bg-gray-100">
                                <option value="none">Không lặp lại</option>
                                <option value="daily">Hằng ngày</option>
                                <option value="weekly">Hằng tuần vào ...</option>
                                <option value="monthly">Hằng tháng cùng ngày</option>
                                <option value="yearly">Hằng năm vào ngày ...</option>
                                <option value="setting">Tùy chỉnh...</option>
                                <option value="custom" style="display:none"></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="mb-6">
                    <div class="flex items-center gap-4">
                        <jsp:include page="../../assets/location_on.svg"/>
                        <input type="text" name="location" placeholder="Vị trí"
                               class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100"
                               value="<%= event.getLocation()%>" />
                    </div>
                </div>
                <div class="mb-6">
                    <div class="flex items-center gap-4">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V4a2 2 0 10-4 0v1.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" /></svg>
                        <div class="flex-1">
                            <div class="flex gap-2 items-center">
                                <select name="remindMethod"
                                        class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                                    <option value="0" <%= !event.getRemindMethod() ? "selected" : ""%>>Thông báo</option>
                                    <option value="1" <%= event.getRemindMethod() ? "selected" : ""%>>Email</option>
                                </select>
                                <input type="number" name="remindBefore" value="<%= event.getRemindBefore()%>" min="0"
                                       class="border rounded px-3 py-2 w-20 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                                <select name="remindUnit"
                                        class="border rounded px-3 py-2 w-28 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                                    <option value="minutes" <%= "minutes".equals(event.getRemindUnit()) ? "selected" : ""%>>phút</option>
                                    <option value="hours" <%= "hours".equals(event.getRemindUnit()) ? "selected" : ""%>>giờ</option>
                                    <option value="days" <%= "days".equals(event.getRemindUnit()) ? "selected" : ""%>>ngày</option>
                                    <option value="weeks" <%= "weeks".equals(event.getRemindUnit()) ? "selected" : ""%>>tuần</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mb-6">
                    <div class="flex items-center gap-4">
                        <jsp:include page="../../assets/Calendar_bl.svg"/>
                        <div class="flex-1">
                            <label class="block text-sm font-medium mb-1">Chọn lịch</label>
                            <select name="calendarId" required
                                    class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                                <% if (calendars != null)
                                        for (Calendar c : calendars) {%>
                                <option value="<%=c.getIdCalendar()%>" <%= event.getIdCalendar() != null && c.getIdCalendar().equals(event.getIdCalendar().getIdCalendar()) ? "selected" : ""%>><%=c.getName()%></option>
                                <% }%>
                                <option value="add_new">+ Thêm lịch mới...</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="mb-6">
                    <div class="flex items-center gap-4">
                        <jsp:include page="../../assets/color_picker.svg"/>
                        <div class="flex-1">
                            <label class="block text-sm font-medium mb-1">Màu sắc</label>
                            <select name="color"
                                    class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                                <option value="#3b82f6" <%= "#3b82f6".equals(event.getColor()) ? "selected" : ""%>>Xanh dương</option>
                                <option value="#ef4444" <%= "#ef4444".equals(event.getColor()) ? "selected" : ""%>>Đỏ</option>
                                <option value="#10b981" <%= "#10b981".equals(event.getColor()) ? "selected" : ""%>>Xanh lá</option>
                                <option value="#f59e0b" <%= "#f59e0b".equals(event.getColor()) ? "selected" : ""%>>Cam</option>
                                <option value="#8b5cf6" <%= "#8b5cf6".equals(event.getColor()) ? "selected" : ""%>>Tím</option>
                                <option value="#ec4899" <%= "#ec4899".equals(event.getColor()) ? "selected" : ""%>>Hồng</option>
                                <option value="#f59e0b" <%= "#f59e0b".equals(event.getColor()) ? "selected" : ""%>>Vàng</option>
                                <option value="#6366f1" <%= "#6366f1".equals(event.getColor()) ? "selected" : ""%>>Xanh tím</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="flex items-center gap-4">
                        <jsp:include page="../../assets/Status_list.svg"/>
                        <div class="flex-1">
                            <label class="block text-sm font-medium mb-1">Mô tả</label>
                            <textarea name="description" rows="3"
                                      class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100"><%= event.getDescription()%></textarea>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- Modal tùy chỉnh -->
        <div id="customRecurrenceModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-30 z-50 flex items-start justify-center">
            <div class="bg-white rounded-2xl shadow-2xl max-w-lg w-full p-8 mt-20">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-2xl font-bold text-gray-900">Lặp lại tuỳ chỉnh</h3>
                </div>
                <div class="mb-6 flex items-center gap-2">
                    <span class="text-gray-700">Lặp lại mỗi</span>
                    <input id="customRepeatInterval" type="number" min="1" value="1" required class="w-16 border rounded px-2 py-1 text-center focus:ring-2 focus:ring-blue-400" />
                    <select id="customRepeatUnit" class="border rounded px-2 py-1 focus:ring-2 focus:ring-blue-400">
                        <option value="day">ngày</option>
                        <option value="week">tuần</option>
                        <option value="month">tháng</option>
                        <option value="year">năm</option>
                    </select>
                </div>
                <div id="customWeekdays" class="flex items-center gap-2" style="display:none;">
                    <label class="text-sm">Lặp lại vào</label>
                    <div class="flex gap-2">
                        <button type="button" class="custom-day-btn rounded-full w-8 h-8 flex items-center justify-center border text-gray-700" data-day="SU">CN</button>
                        <button type="button" class="custom-day-btn rounded-full w-8 h-8 flex items-center justify-center border text-gray-700" data-day="MO">T2</button>
                        <button type="button" class="custom-day-btn rounded-full w-8 h-8 flex items-center justify-center border text-gray-700" data-day="TU">T3</button>
                        <button type="button" class="custom-day-btn rounded-full w-8 h-8 flex items-center justify-center border text-gray-700" data-day="WE">T4</button>
                        <button type="button" class="custom-day-btn rounded-full w-8 h-8 flex items-center justify-center border text-gray-700" data-day="TH">T5</button>
                        <button type="button" class="custom-day-btn rounded-full w-8 h-8 flex items-center justify-center border text-gray-700" data-day="FR">T6</button>
                        <button type="button" class="custom-day-btn rounded-full w-8 h-8 flex items-center justify-center border text-gray-700" data-day="SA">T7</button>
                    </div>
                </div>
                <!-- Bổ sung trong modal tùy chỉnh -->
                <div id="customMonthOptions" class="mb-4" style="display:none;">
                    <label><input type="radio" name="monthOption" value="day" checked> Ngày trong tháng</label>
                    <input type="number" id="monthDay" min="1" max="31" value="1" class="w-16 border rounded px-2 py-1 text-center mx-2">
                    <label><input type="radio" name="monthOption" value="weekday"> Thứ trong tháng</label>
                    <select id="monthWeek" class="border rounded px-2 py-1 mx-1">
                        <option value="1">Tuần 1</option>
                        <option value="2">Tuần 2</option>
                        <option value="3">Tuần 3</option>
                        <option value="4">Tuần 4</option>
                        <option value="-1">Tuần cuối</option>
                    </select>
                    <select id="monthWeekday" class="border rounded px-2 py-1 mx-1">
                        <option value="MO">Thứ 2</option>
                        <option value="TU">Thứ 3</option>
                        <option value="WE">Thứ 4</option>
                        <option value="TH">Thứ 5</option>
                        <option value="FR">Thứ 6</option>
                        <option value="SA">Thứ 7</option>
                        <option value="SU">Chủ nhật</option>
                    </select>
                </div>
                <div class="mb-8">
                    <span class="block text-gray-700 mb-2">Kết thúc</span>
                    <div class="flex flex-col gap-2">
                        <label class="inline-flex items-center gap-2">
                            <input type="radio" name="customEndType" value="never" checked class="accent-blue-600"> Không bao giờ
                        </label>
                        <label class="inline-flex items-center gap-2">
                            <input type="radio" name="customEndType" value="ondate" class="accent-blue-600"> Vào ngày
                            <input type="date" id="customEndDate" class="border rounded px-2 py-1" disabled>
                        </label>
                        <label class="inline-flex items-center gap-2">
                            <input type="radio" name="customEndType" value="after" class="accent-blue-600"> Sau
                            <input type="number" id="customEndCount" min="1" value="10" class="w-16 border rounded px-2 py-1 text-center" disabled>
                            lần xuất hiện
                        </label>
                    </div>
                </div>
                <div class="flex justify-end gap-3">
                    <button type="button" id="customCancelBtn" class="px-4 py-2 rounded text-gray-700 hover:bg-gray-100">Huỷ</button>
                    <button type="button" id="customDoneBtn" class="px-5 py-2 rounded bg-blue-600 text-white font-semibold hover:bg-blue-700">Xong</button>
                </div>
            </div>
        </div>
    </body>

    <script>
        // Khi chọn '+ Thêm lịch mới...' thì chuyển qua trang addCalendar.jsp
        document.addEventListener('DOMContentLoaded', function () {
            var calendarSelect = document.querySelector('select[name="calendarId"]');
            if (calendarSelect) {
                calendarSelect.addEventListener('change', function () {
                    if (this.value === 'add_new') {
                        window.location.href = 'calendar?action=create';
                    }
                });
            }
        });
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Khai báo biến chung cho modal tuỳ chỉnh
            var recurrenceType = document.getElementById('recurrenceType');
            var startDateInput = document.querySelector('input[name="startDate"]');
            var customModal = document.getElementById('customRecurrenceModal');
            var customEndDate = document.getElementById('customEndDate');
            var cancelBtn = document.getElementById('customCancelBtn');

            // Đóng modal khi bấm Huỷ và reset select về 'none'
            if (cancelBtn && customModal) {
                cancelBtn.addEventListener('click', function () {
                    customModal.classList.add('hidden');
                    recurrenceType.value = "none";
                });
            }

            // Sự kiện click cho option 'Tùy chỉnh...'
            var settingOption = recurrenceType.querySelector('option[value="setting"]');
            recurrenceType.addEventListener('mousedown', function(e) {
                if (e.target === settingOption) {
                    var date = startDateInput && startDateInput.value ? new Date(startDateInput.value) : new Date();
                    date.setMonth(date.getMonth() + 1);
                    var yyyy = date.getFullYear();
                    var mm = String(date.getMonth() + 1).padStart(2, '0');
                    var dd = String(date.getDate()).padStart(2, '0');
                    customEndDate.value = yyyy + '-' + mm + '-' + dd;
                    customModal.classList.remove('hidden');
                    e.preventDefault();
                }
            });

            // Hiển thị thứ/ngày động cho option weekly/yearly
            function updateRecurrenceLabels() {
                if (startDateInput && startDateInput.value) {
                    var date = new Date(startDateInput.value);
                    var weekdays = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
                    var weekday = weekdays[date.getDay()];
                    document.querySelector('#recurrenceType option[value="weekly"]').textContent = 'Hằng tuần vào ' + weekday;
                    document.querySelector('#recurrenceType option[value="yearly"]').textContent = 'Hằng năm vào ngày ' + date.getDate() + '/' + (date.getMonth() + 1);
                } else {
                    document.querySelector('#recurrenceType option[value="weekly"]').textContent = 'Hằng tuần vào ...';
                    document.querySelector('#recurrenceType option[value="yearly"]').textContent = 'Hằng năm vào ngày ...';
                }
            }
            if (startDateInput) {
                startDateInput.addEventListener('change', updateRecurrenceLabels);
                updateRecurrenceLabels();
            }

            // Sự kiện change cho select kiểu lặp
            recurrenceType.addEventListener('change', function () {
                var val = this.value;
                var rrule = "";
                var startDate = startDateInput.value;
                var rruleInput = document.getElementById('recurrenceRule');
                if (val === "setting") {
                    var date = startDate ? new Date(startDate) : new Date();
                    date.setMonth(date.getMonth() + 1);
                    var yyyy = date.getFullYear();
                    var mm = String(date.getMonth() + 1).padStart(2, '0');
                    var dd = String(date.getDate()).padStart(2, '0');
                    customEndDate.value = yyyy + '-' + mm + '-' + dd;
                    customModal.classList.remove('hidden');
                } else if (val === "daily") {
                    rrule = "FREQ=DAILY;INTERVAL=1";
                } else if (val === "weekly") {
                    var date = new Date(startDate);
                    var days = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"];
                    var dayOfWeek = days[date.getDay()];
                    rrule = "FREQ=WEEKLY;INTERVAL=1;BYDAY=" + dayOfWeek;
                } else if (val === "monthly") {
                    var date = new Date(startDate);
                    var dayOfMonth = date.getDate();
                    rrule = "FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=" + dayOfMonth;
                } else if (val === "yearly") {
                    var date = new Date(startDate);
                    var month = date.getMonth() + 1;
                    var dayOfMonth = date.getDate();
                    rrule = "FREQ=YEARLY;INTERVAL=1;BYMONTH=" + month + ";BYMONTHDAY=" + dayOfMonth;
                } else if (val === "none") {
                    if (rruleInput)
                        rruleInput.parentNode.removeChild(rruleInput);
                    return;
                }
                if (val !== "setting") {
                    if (!document.getElementById('recurrenceRule')) {
                        var input = document.createElement('input');
                        input.type = 'hidden';
                        input.name = 'recurrenceRule';
                        input.id = 'recurrenceRule';
                        input.value = rrule;
                        document.getElementById('editEventForm').appendChild(input);
                    } else {
                        document.getElementById('recurrenceRule').value = rrule;
                    }
                }
            });

            // Khi đổi ngày bắt đầu, nếu đang chọn kiểu lặp mặc định thì cập nhật lại RRULE
            if (startDateInput) {
                startDateInput.addEventListener('change', function () {
                    var val = recurrenceType.value;
                    var rrule = "";
                    var startDate = startDateInput.value;
                    if (val === "daily") {
                        rrule = "FREQ=DAILY;INTERVAL=1";
                    } else if (val === "weekly") {
                        var date = new Date(startDate);
                        var days = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"];
                        var dayOfWeek = days[date.getDay()];
                        rrule = "FREQ=WEEKLY;INTERVAL=1;BYDAY=" + dayOfWeek;
                    } else if (val === "monthly") {
                        var date = new Date(startDate);
                        var dayOfMonth = date.getDate();
                        rrule = "FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=" + dayOfMonth;
                    } else if (val === "yearly") {
                        var date = new Date(startDate);
                        var month = date.getMonth() + 1;
                        var dayOfMonth = date.getDate();
                        rrule = "FREQ=YEARLY;INTERVAL=1;BYMONTH=" + month + ";BYMONTHDAY=" + dayOfMonth;
                    } else if (val === "none" || val === "setting") {
                        rrule = "";
                    }
                    if (val !== "setting") {
                        document.getElementById('recurrenceRule').value = rrule;
                    }
                });
            }

            // Đóng modal khi click ra ngoài
            customModal.addEventListener('click', function (e) {
                if (e.target === this)
                    customModal.classList.add('hidden');
            });
        });
    </script>

    <script>
        // Ẩn/hiện chọn thứ khi chọn tuần
        document.getElementById('customRepeatUnit').addEventListener('change', function () {
            const weekDaysDiv = document.getElementById('customWeekdays');
            const monthOptionsDiv = document.getElementById('customMonthOptions');
            if (weekDaysDiv)
                weekDaysDiv.style.display = this.value === 'week' ? 'block' : 'none';
            if (monthOptionsDiv)
                monthOptionsDiv.style.display = this.value === 'month' ? 'block' : 'none';
        });
        // --- Tương tác chọn thứ trong tuần ---
        document.querySelectorAll('.custom-day-btn').forEach(btn => {
            btn.addEventListener('click', function () {
                this.classList.toggle('bg-blue-600');
                this.classList.toggle('text-white');
                this.classList.toggle('border-blue-600');
                if (this.classList.contains('bg-blue-600')) {
                    this.setAttribute('data-selected', 'true');
                } else {
                    this.removeAttribute('data-selected');
                }
            });
        });
        // --- Enable/disable input date và input count theo radio ---
        const endTypeRadios = document.getElementsByName('customEndType');
        const endDateInput = document.getElementById('customEndDate');
        const endCountInput = document.getElementById('customEndCount');
        endTypeRadios.forEach(radio => {
            radio.addEventListener('change', function () {
                if (this.value === 'ondate') {
                    endDateInput.disabled = false;
                    endCountInput.disabled = true;
                } else if (this.value === 'after') {
                    endDateInput.disabled = true;
                    endCountInput.disabled = false;
                } else {
                    endDateInput.disabled = true;
                    endCountInput.disabled = true;
                }
            });
        });
        // --- Khi nhấn Xong ---
        document.getElementById('customDoneBtn').addEventListener('click', function () {
            const rrule = buildCustomRRule();
            let rruleInput = document.getElementById('recurrenceRule');
            if (!rruleInput) {
                // Nếu input đã bị xóa, tạo lại
                rruleInput = document.createElement('input');
                rruleInput.type = 'hidden';
                rruleInput.name = 'recurrenceRule';
                rruleInput.id = 'recurrenceRule';
                document.getElementById('editEventForm').appendChild(rruleInput);
            }
            rruleInput.value = rrule;
            console.log('[customRecurrenceModal] recurrenceRule:', rrule);

            // Hiển thị mô tả lặp lại ở option custom
            const recurrenceTypeSelect = document.getElementById('recurrenceType');
            const customOption = recurrenceTypeSelect.querySelector('option[value="custom"]');
            let desc = '';
            if (rrule.includes('FREQ=DAILY')) {
                desc = 'Tùy chỉnh: Hằng ngày';
            } else if (rrule.includes('FREQ=WEEKLY')) {
                const days = [];
                const byDays = rrule.match(/BYDAY=([A-Z,]+)/);
                if (byDays && byDays[1]) {
                    byDays[1].split(',').forEach(day => {
                        const dayMapVi = {'SU': 'CN', 'MO': 'T2', 'TU': 'T3', 'WE': 'T4', 'TH': 'T5', 'FR': 'T6', 'SA': 'T7'};
                        if (dayMapVi[day])
                            days.push(dayMapVi[day]);
                    });
                }
                desc = 'Tùy chỉnh: Hằng tuần vào ' + days.join(', ');
            } else if (rrule.includes('FREQ=MONTHLY')) {
                const monthOption = document.querySelector('input[name="monthOption"]:checked').value;
                if (monthOption === 'day') {
                    const day = document.getElementById('monthDay').value;
                    desc = 'Tùy chỉnh: Hằng tháng ngày ' + day;
                } else {
                    const week = document.getElementById('monthWeek').value;
                    const weekday = document.getElementById('monthWeekday').value;
                    desc = 'Tùy chỉnh: Hằng tháng thứ ' + weekday + ' tuần ' + week;
                }
            } else if (rrule.includes('FREQ=YEARLY')) {
                const matchMonth = rrule.match(/BYMONTH=(\d+)/);
                const matchDayOfMonth = rrule.match(/BYMONTHDAY=(\d+)/);
                if (matchMonth && matchDayOfMonth) {
                    desc = 'Tùy chỉnh: Hằng năm tháng ' + matchMonth[1] + ' ngày ' + matchDayOfMonth[1];
                } else {
                    desc = 'Tùy chỉnh: Hằng năm';
                }
            } else {
                desc = 'Tùy chỉnh: Không lặp lại';
            }
            customOption.textContent = desc;
            customOption.style.display = '';
            recurrenceTypeSelect.value = 'custom';
            // Đóng modal
            document.getElementById('customRecurrenceModal').classList.add('hidden');
        });
    </script>

    <script>
        function buildCustomRRule() {
            var rrule = "";
            var interval = document.getElementById('customRepeatInterval').value;
            var unit = document.getElementById('customRepeatUnit').value;
            var startDate = document.querySelector('input[name="startDate"]').value;

            if (unit === 'day') {
                rrule = "FREQ=DAILY;INTERVAL=" + interval;
            } else if (unit === 'week') {
                const daysSet = new Set();
                document.querySelectorAll('.custom-day-btn.bg-blue-600').forEach(btn => {
                    const txt = btn.getAttribute('data-day');
                    if (txt)
                        daysSet.add(txt);
                });
                const days = Array.from(daysSet);
                if (days.length > 0) {
                    rrule = "FREQ=WEEKLY;INTERVAL=" + interval + ";BYDAY=" + days.join(',');
                }
            } else if (unit === 'month') {
                var monthOption = document.querySelector('input[name="monthOption"]:checked').value;
                if (monthOption === 'day') {
                    var day = document.getElementById('monthDay').value;
                    rrule = "FREQ=MONTHLY;INTERVAL=" + interval + ";BYMONTHDAY=" + day;
                } else {
                    var week = document.getElementById('monthWeek').value;
                    var weekday = document.getElementById('monthWeekday').value;
                    rrule = "FREQ=MONTHLY;INTERVAL=" + interval + ";BYDAY=" + week + ";" + weekday;
                }
            } else if (unit === 'year') {
                // Lấy ngày bắt đầu
                var startDate = document.querySelector('input[name="startDate"]').value;
                if (startDate) {
                    var date = new Date(startDate);
                    var month = date.getMonth() + 1;
                    var day = date.getDate();
                    rrule = "FREQ=YEARLY;INTERVAL=" + interval + ";BYMONTH=" + month + ";BYMONTHDAY=" + day;
                } else {
                    rrule = "FREQ=YEARLY;INTERVAL=" + interval;
                }
            }

            // Kết thúc: UNTIL hoặc COUNT
            var endType = document.querySelector('input[name="customEndType"]:checked').value;
            if (endType === 'ondate') {
                var untilDate = document.getElementById('customEndDate').value;
                rrule += ";UNTIL=" + untilDate.replace(/-/g, '');
            } else if (endType === 'after') {
                var count = document.getElementById('customEndCount').value;
                rrule += ";COUNT=" + count;
            }
            return rrule;
        }
    </script>

    <script>
        document.getElementById('editEventForm').addEventListener('submit', function (e) {
            var recurrenceType = document.getElementById('recurrenceType').value;
            if (recurrenceType === 'none') {
                document.getElementById('recurrenceRule').value = '';
            }
        });
    </script>

    <script>
        // 1. Thêm thuộc tính required và min=1 cho input customRepeatInterval
        // (Chỉnh sửa trực tiếp input trong HTML)
        // <input id="customRepeatInterval" type="number" min="1" value="1" required ... />
        // 2. Thêm sự kiện blur cho input này
        (function () {
            var intervalInput = document.getElementById('customRepeatInterval');
            if (intervalInput) {
                intervalInput.addEventListener('blur', function () {
                    if (!this.value || isNaN(this.value) || parseInt(this.value) < 1)
                        this.value = "1";
                });
            }
        })();
        // 3. Khi mở modal, nếu input này rỗng thì set về 1
        (function () {
            var modal = document.getElementById('customRecurrenceModal');
            var intervalInput = document.getElementById('customRepeatInterval');
            if (modal && intervalInput) {
                var observer = new MutationObserver(function (mutations) {
                    mutations.forEach(function (mutation) {
                        if (!modal.classList.contains('hidden')) {
                            if (!intervalInput.value || isNaN(intervalInput.value) || parseInt(intervalInput.value) < 1) {
                                intervalInput.value = "1";
                            }
                        }
                    });
                });
                observer.observe(modal, {attributes: true, attributeFilter: ['class']});
            }
        })();
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var recurrenceRuleInput = document.getElementById('recurrenceRule');
            var recurrenceRule = recurrenceRuleInput ? recurrenceRuleInput.value : "";
            var recurrenceTypeSelect = document.getElementById('recurrenceType');
            var customOption = recurrenceTypeSelect.querySelector('option[value="custom"]');
            if (recurrenceRule && recurrenceRule !== "") {
                let desc = '';
                if (recurrenceRule.includes('FREQ=DAILY')) {
                    desc = 'Tùy chỉnh: Hằng ngày';
                } else if (recurrenceRule.includes('FREQ=WEEKLY')) {
                    const days = [];
                    const byDays = recurrenceRule.match(/BYDAY=([A-Z,]+)/);
                    if (byDays && byDays[1]) {
                        byDays[1].split(',').forEach(day => {
                            const dayMapVi = {'SU': 'CN', 'MO': 'T2', 'TU': 'T3', 'WE': 'T4', 'TH': 'T5', 'FR': 'T6', 'SA': 'T7'};
                            if (dayMapVi[day])
                                days.push(dayMapVi[day]);
                        });
                    }
                    desc = 'Tùy chỉnh: Hằng tuần vào ' + days.join(', ');
                } else if (recurrenceRule.includes('FREQ=MONTHLY')) {
                    const matchMonthDay = recurrenceRule.match(/BYMONTHDAY=(\\d+)/);
                    const matchByDay = recurrenceRule.match(/BYDAY=(\\d+)?([A-Z]{2})/);
                    if (matchMonthDay) {
                        desc = 'Tùy chỉnh: Hằng tháng ngày ' + matchMonthDay[1];
                    } else if (matchByDay) {
                        const week = matchByDay[1];
                        const weekday = matchByDay[2];
                        const dayMapVi = {'MO': 'Thứ 2', 'TU': 'Thứ 3', 'WE': 'Thứ 4', 'TH': 'Thứ 5', 'FR': 'Thứ 6', 'SA': 'Thứ 7', 'SU': 'Chủ nhật'};
                        desc = `Tùy chỉnh: Hằng tháng thứ ${dayMapVi[weekday] || weekday} tuần ${week}`;
                    } else {
                        desc = 'Tùy chỉnh: Hằng tháng';
                    }
                } else if (recurrenceRule.includes('FREQ=YEARLY')) {
                    const matchMonth = recurrenceRule.match(/BYMONTH=(\\d+)/);
                    const matchDayOfMonth = recurrenceRule.match(/BYMONTHDAY=(\\d+)/);
                    if (matchMonth && matchDayOfMonth) {
                        desc = 'Tùy chỉnh: Hằng năm tháng ' + matchMonth[1] + ' ngày ' + matchDayOfMonth[1];
                    } else {
                        desc = 'Tùy chỉnh: Hằng năm';
                    }
                } else {
                    desc = 'Tùy chỉnh: Không lặp lại';
                }
                customOption.textContent = desc;
                customOption.style.display = '';
                recurrenceTypeSelect.value = 'custom';
            }
        });
    </script>

    <script>
    // Hàm parse RRULE và set lại các trường trong modal tùy chỉnh
        function setCustomModalFromRRule(rrule) {
            // INTERVAL
            var matchInterval = rrule.match(/INTERVAL=(\d+)/);
            var interval = matchInterval ? matchInterval[1] : "1";
            document.getElementById('customRepeatInterval').value = interval;
            // Đơn vị lặp
            if (rrule.includes('FREQ=DAILY')) {
                document.getElementById('customRepeatUnit').value = 'day';
                document.getElementById('customWeekdays').style.display = 'none';
                document.getElementById('customMonthOptions').style.display = 'none';
            } else if (rrule.includes('FREQ=WEEKLY')) {
                document.getElementById('customRepeatUnit').value = 'week';
                document.getElementById('customWeekdays').style.display = 'block';
                document.getElementById('customMonthOptions').style.display = 'none';
                // BYDAY
                var matchByDay = rrule.match(/BYDAY=([A-Z,]+)/);
                var bydays = matchByDay ? matchByDay[1].split(',') : [];
                document.querySelectorAll('.custom-day-btn').forEach(btn => {
                    // Reset hết trạng thái
                    btn.classList.remove('bg-blue-600', 'text-white', 'border-blue-600');
                    btn.removeAttribute('data-selected');
                    var day = btn.getAttribute('data-day');
                    if (bydays.includes(day)) {
                        btn.classList.add('bg-blue-600', 'text-white', 'border-blue-600');
                        btn.setAttribute('data-selected', 'true');
                    }
                });
            } else if (rrule.includes('FREQ=MONTHLY')) {
                document.getElementById('customRepeatUnit').value = 'month';
                document.getElementById('customWeekdays').style.display = 'none';
                document.getElementById('customMonthOptions').style.display = 'block';
                // BYMONTHDAY
                var matchByMonthDay = rrule.match(/BYMONTHDAY=(\d+)/);
                if (matchByMonthDay) {
                    document.querySelector('input[name="monthOption"][value="day"]').checked = true;
                    document.getElementById('monthDay').value = matchByMonthDay[1];
                }
                // BYDAY + BYSETPOS (thứ trong tháng)
                var matchByDay = rrule.match(/BYDAY=([A-Z]{2});BYSETPOS=([\-\d]+)/);
                if (matchByDay) {
                    document.querySelector('input[name="monthOption"][value="weekday"]').checked = true;
                    document.getElementById('monthWeekday').value = matchByDay[1];
                    document.getElementById('monthWeek').value = matchByDay[2];
                }
            } else if (rrule.includes('FREQ=YEARLY')) {
                document.getElementById('customRepeatUnit').value = 'year';
                document.getElementById('customWeekdays').style.display = 'none';
                document.getElementById('customMonthOptions').style.display = 'none';
                // Xử lý BYMONTH và BYMONTHDAY nếu có
                var matchByMonth = rrule.match(/BYMONTH=(\d+)/);
                var matchByMonthDay = rrule.match(/BYMONTHDAY=(\d+)/);
                if (matchByMonth && matchByMonthDay) {
                    // Có thể thêm logic để hiển thị thông tin ngày/tháng nếu cần
                    console.log('Yearly recurrence: Month ' + matchByMonth[1] + ', Day ' + matchByMonthDay[1]);
                }
            }
            // Kết thúc: UNTIL hoặc COUNT
            var matchUntil = rrule.match(/UNTIL=(\d{8})/);
            var matchCount = rrule.match(/COUNT=(\d+)/);
            if (matchUntil) {
                document.querySelector('input[name="customEndType"][value="ondate"]').checked = true;
                var until = matchUntil[1];
                document.getElementById('customEndDate').value = until.slice(0, 4) + '-' + until.slice(4, 6) + '-' + until.slice(6, 8);
                document.getElementById('customEndDate').disabled = false;
                document.getElementById('customEndCount').disabled = true;
            } else if (matchCount) {
                document.querySelector('input[name="customEndType"][value="after"]').checked = true;
                document.getElementById('customEndCount').value = matchCount[1];
                document.getElementById('customEndDate').disabled = true;
                document.getElementById('customEndCount').disabled = false;
            } else {
                document.querySelector('input[name="customEndType"][value="never"]').checked = true;
                document.getElementById('customEndDate').disabled = true;
                document.getElementById('customEndCount').disabled = true;
            }
        }

    // Khi mở modal tùy chỉnh, nếu đang edit event và có recurrenceRule, tự động set lại các trường
        (function () {
            var isEdit = document.getElementById('isEditFlag').value === 'true';
            if (isEdit) {
                var recurrenceRule = document.getElementById('recurrenceRule').value;
                var modal = document.getElementById('customRecurrenceModal');
                var recurrenceTypeSelect = document.getElementById('recurrenceType');
                // Theo dõi khi modal được hiển thị
                var observer = new MutationObserver(function (mutations) {
                    mutations.forEach(function (mutation) {
                        if (!modal.classList.contains('hidden') && recurrenceTypeSelect.value === 'setting' && recurrenceRule) {
                            setTimeout(function () {
                                setCustomModalFromRRule(recurrenceRule);
                            }, 50); // Đảm bảo DOM đã render xong
                        }
                    });
                });
                observer.observe(modal, {attributes: true, attributeFilter: ['class']});
            }
        })();
    </script>

</html> 