<%-- 
    Document   : addEvent
    Created on : Jul 10, 2025, 11:11:25 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Calendar" %>
<%
    List<Calendar> calendars = (List<Calendar>) request.getAttribute("calendars");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thêm sự kiện mới</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <div class="w-full max-w-3xl mx-auto pt-6">

            <form id="addEventForm" action="event" method="post" class="bg-white rounded-xl shadow p-8">
                <input type="hidden" name="action" value="create" />
                <input type="hidden" name="recurrenceRule" id="recurrenceRule" value="" />
                <input type="hidden" id="isEditFlag" value="false" />

                <div class="flex items-center gap-3 mb-6">
                    <!-- Tiêu đề + nút lưu -->
                    <a href="<%=request.getContextPath()%>/home" class="text-gray-500 hover:text-red-500 transition-colors" title="Quay lại">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </a>
                    <input type="text" name="title" required placeholder="Thêm tiêu đề"
                           class="border rounded px-4 py-2 flex-1 text-xl font-semibold focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                    <button type="submit"
                            class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 font-semibold">Lưu</button>
                </div>
                <div class="mb-6">
                    <!-- Ngày giờ -->
                    <div class="flex flex-wrap gap-2 px-10">
                        <div class="flex items-center gap-2">
                            <div>
                                <label class="block text-sm font-medium mb-1">Ngày bắt đầu</label>
                                <input type="date" name="startDate" required
                                       class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                            </div>
                        </div>
                        <div class="flex items-center gap-2">
                            <div>
                                <label class="block text-sm font-medium mb-1">Giờ bắt đầu</label>
                                <input type="time" name="startTime"
                                       class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                            </div>
                        </div>
                        <div class="flex items-center mt-6">
                            <span class=" text-gray-500">-</span>
                        </div>
                        <div class="flex items-center gap-1">
                            <div>
                                <label class="block text-sm font-medium mb-1">Ngày kết thúc</label>
                                <input type="date" name="endDate"
                                       class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                            </div>
                        </div>
                        <div class="flex items-center gap-2">
                            <div>
                                <label class="block text-sm font-medium mb-1">Giờ kết thúc</label>
                                <input type="time" name="endTime"
                                       class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mb-6">
                    <!-- Cả ngày & lặp lại -->
                    <div class="flex items-center gap-6 px-10">
                        <label class="inline-flex items-center">
                            <input type="checkbox" name="allDay" value="on" class="accent-blue-600 mr-2"> Cả ngày
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
                                <option value="custom" style="display:none"></option> <!-- Thêm option custom ẩn -->
                            </select>
                        </div>
                    </div>
                </div>
                <div class="mb-6">
                    <!-- Vị trí -->
                    <div class="flex items-center gap-4">
                        <jsp:include page="../../assets/location_on.svg"/>
                        <input type="text" name="location" placeholder="Vị trí"
                               class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                    </div>
                </div>
                <div class="mb-6">
                    <!-- Nhắc nhở -->
                    <div class="flex items-center gap-4">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V4a2 2 0 10-4 0v1.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" /></svg>
                        <div class="flex-1">
                            <div class="flex gap-2 items-center">
                                <select name="remindMethod"
                                        class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                                    <option value="0">Thông báo</option>
                                    <option value="1">Email</option>
                                </select>
                                <input type="number" name="remindBefore" value="30" min="0"
                                       class="border rounded px-3 py-2 w-20 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                                <select name="remindUnit"
                                        class="border rounded px-3 py-2 w-28 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                                    <option value="minutes">phút</option>
                                    <option value="hours">giờ</option>
                                    <option value="days">ngày</option>
                                    <option value="weeks">tuần</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mb-6">
                    <!-- Chọn lịch -->
                    <div class="flex items-center gap-4">
                        <jsp:include page="../../assets/Calendar_bl.svg"/>
                        <div class="flex-1">
                            <label class="block text-sm font-medium mb-1">Chọn lịch</label>
                            <select name="calendarId" required
                                    class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                                <% if (calendars != null)
                                        for (Calendar c : calendars) {%>
                                <option value="<%=c.getIdCalendar()%>"><%=c.getName()%></option>
                                <% }%>
                                <option value="add_new">+ Thêm lịch mới...</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="mb-6">
                    <!-- Màu sắc -->
                    <div class="flex items-center gap-4">
                        <jsp:include page="../../assets/color_picker.svg"/>
                        <div class="flex-1">
                            <label class="block text-sm font-medium mb-1">Màu sắc</label>
                            <select name="color"
                                    class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                                <option value="#3b82f6">Xanh dương</option>
                                <option value="#ef4444">Đỏ</option>
                                <option value="#10b981">Xanh lá</option>
                                <option value="#f59e0b">Cam</option>
                                <option value="#8b5cf6">Tím</option>
                                <option value="#ec4899">Hồng</option>
                                <option value="#f59e0b">Vàng</option>
                                <option value="#6366f1">Xanh tím</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div>
                    <!-- Mô tả -->
                    <div class="flex items-center gap-4">
                        <jsp:include page="../../assets/Status_list.svg"/>
                        <div class="flex-1">
                            <label class="block text-sm font-medium mb-1">Mô tả</label>
                            <textarea name="description" rows="3"
                                      class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100"></textarea>
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
        // Tự động điền ngày và giờ khi tạo mới
        document.addEventListener('DOMContentLoaded', function () {
            // Lấy ngày hiện tại
            var now = new Date();
            var yyyy = now.getFullYear();
            var mm = String(now.getMonth() + 1).padStart(2, '0');
            var dd = String(now.getDate()).padStart(2, '0');
            var today = yyyy + '-' + mm + '-' + dd;

            // Giờ hiện tại
            var hh = String(now.getHours()).padStart(2, '0');
            var min = String(now.getMinutes()).padStart(2, '0');
            var startTime = hh + ':' + min;

            // Giờ kết thúc (sau 1 tiếng)
            var end = new Date(now.getTime() + 60 * 60 * 1000);
            var endH = String(end.getHours()).padStart(2, '0');
            var endM = String(end.getMinutes()).padStart(2, '0');
            var endTime = endH + ':' + endM;

            // Gán giá trị cho input
            var startDateInput = document.querySelector('input[name="startDate"]');
            var endDateInput = document.querySelector('input[name="endDate"]');
            var startTimeInput = document.querySelector('input[name="startTime"]');
            var endTimeInput = document.querySelector('input[name="endTime"]');
            if (startDateInput)
                startDateInput.value = today;
            if (endDateInput)
                endDateInput.value = today;
            if (startTimeInput)
                startTimeInput.value = startTime;
            if (endTimeInput)
                endTimeInput.value = endTime;

            // --- Tự động lấy startDate, startTime, endDate, endTime từ URL nếu có ---
            function getParam(name) {
                const url = new URL(window.location.href);
                return url.searchParams.get(name);
            }
            var startDate = getParam('startDate');
            var startTime = getParam('startTime');
            var endDate = getParam('endDate');
            var endTime = getParam('endTime');
            if (startDate)
                document.querySelector('input[name="startDate"]').value = startDate;
            if (startTime)
                document.querySelector('input[name="startTime"]').value = startTime;
            if (endDate)
                document.querySelector('input[name="endDate"]').value = endDate;
            if (endTime)
                document.querySelector('input[name="endTime"]').value = endTime;
        });
    </script>

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
            recurrenceType.addEventListener('mousedown', function (e) {
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

            // Gộp xử lý change cho recurrenceType
            recurrenceType.addEventListener('change', function () {
                var val = this.value;
                var rrule = "";
                var startDate = startDateInput.value;
                var rruleInput = document.getElementById('recurrenceRule');
                if (val === "setting") {
                    // Mở modal tùy chỉnh
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
                    // Tạo RRULE với thứ của ngày bắt đầu
                    rrule = "FREQ=WEEKLY;INTERVAL=1;BYDAY=" + dayOfWeek;
                } else if (val === "monthly") {
                    var date = new Date(startDate);
                    var dayOfMonth = date.getDate();
                    // Tạo RRULE với ngày trong tháng
                    rrule = "FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=" + dayOfMonth;
                } else if (val === "yearly") {
                    var date = new Date(startDate);
                    var month = date.getMonth() + 1;
                    var dayOfMonth = date.getDate();
                    // Tạo RRULE với ngày và tháng cụ thể
                    rrule = "FREQ=YEARLY;INTERVAL=1;BYMONTH=" + month + ";BYMONTHDAY=" + dayOfMonth;
                } else if (val === "none") {
                    // Xoá input khỏi form nếu có
                    if (rruleInput)
                        rruleInput.parentNode.removeChild(rruleInput);
                    return;
                }
                // Nếu không phải tùy chỉnh thì gán luôn
                if (val !== "setting") {
                    // Nếu chưa có input thì thêm lại
                    if (!document.getElementById('recurrenceRule')) {
                        var input = document.createElement('input');
                        input.type = 'hidden';
                        input.name = 'recurrenceRule';
                        input.id = 'recurrenceRule';
                        input.value = rrule;
                        document.getElementById('addEventForm').appendChild(input);
                    } else {
                        document.getElementById('recurrenceRule').value = rrule;
                    }
                }
            });

            // Bổ sung: Khi đổi ngày bắt đầu, nếu đang chọn kiểu lặp mặc định thì cập nhật lại RRULE
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
            // Đóng modal tùy chỉnh
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
                document.getElementById('addEventForm').appendChild(rruleInput);
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
        document.getElementById('addEventForm').addEventListener('submit', function (e) {
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
        // Đảm bảo nút Huỷ đóng được modal tuỳ chỉnh
        document.addEventListener('DOMContentLoaded', function () {
            var recurrenceType = document.getElementById('recurrenceType');
            var startDateInput = document.querySelector('input[name="startDate"]');
            var customModal = document.getElementById('customRecurrenceModal');
            var customEndDate = document.getElementById('customEndDate');
            var cancelBtn = document.getElementById('customCancelBtn');
            if (cancelBtn && customModal) {
                cancelBtn.addEventListener('click', function () {
                    customModal.classList.add('hidden');
                    // Reset select về "none" để lần sau chọn lại "Tùy chỉnh..." sẽ luôn kích hoạt
                    recurrenceType.value = "none";
                });
            }
        });
    </script>

</html>
