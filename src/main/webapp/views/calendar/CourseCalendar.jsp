<%-- 
    Document   : CourseCalendar
    Created on : Jul 20, 2025, 10:57:13 PM
    Author     : DELL
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String orderId = (String) request.getAttribute("orderId");
    String courseName = (String) request.getAttribute("courseName");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Thiết lập lịch học cho khóa học</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
    <div class="max-w-xl mx-auto mt-10 bg-white rounded-xl shadow-lg p-8">
        <h2 class="text-2xl font-bold mb-6 text-blue-700 text-center">Thiết lập lịch học cho khóa học bạn vừa mua</h2>
        <form id="calendarForm" class="space-y-4">
            <input type="hidden" name="orderId" value="<%= orderId %>"/>
            <div>
                <label for="calendarName" class="block font-medium mb-1">Tên lịch học:</label>
                <input type="text" id="calendarName" name="calendarName" required value="<%= courseName != null ? courseName : "" %>"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
            </div>
            <div class="flex gap-4">
                <div class="flex-1">
                    <label for="startDate" class="block font-medium mb-1">Ngày bắt đầu:</label>
                    <input type="date" id="startDate" name="startDate" required
                           class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
                </div>
                <div class="flex-1">
                    <label for="startTime" class="block font-medium mb-1">Giờ bắt đầu học:</label>
                    <input type="time" id="startTime" name="startTime" required
                           class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
                </div>
            </div>
            <div class="flex gap-4">
                <div class="flex-1">
                    <label for="color" class="block font-medium mb-1">Màu sắc cho lịch:</label>
                    <input type="color" id="color" name="color" value="#3b82f6"
                           class="w-full h-10 border rounded"/>
                </div>
                <div class="flex-1">
                    <label for="eventColor" class="block font-medium mb-1">Màu sắc cho các buổi học:</label>
                    <input type="color" id="eventColor" name="eventColor" value="#3b82f6"
                           class="w-full h-10 border rounded"/>
                </div>
            </div>
            <div>
                <label class="block font-medium mb-1">Chọn các ngày trong tuần để lặp:</label>
                <div id="weekday-group" class="flex flex-wrap gap-3">
                    <label><input type="checkbox" name="weekdays" value="MO" class="mr-1">Thứ 2</label>
                    <label><input type="checkbox" name="weekdays" value="TU" class="mr-1">Thứ 3</label>
                    <label><input type="checkbox" name="weekdays" value="WE" class="mr-1">Thứ 4</label>
                    <label><input type="checkbox" name="weekdays" value="TH" class="mr-1">Thứ 5</label>
                    <label><input type="checkbox" name="weekdays" value="FR" class="mr-1">Thứ 6</label>
                    <label><input type="checkbox" name="weekdays" value="SA" class="mr-1">Thứ 7</label>
                    <label><input type="checkbox" name="weekdays" value="SU" class="mr-1">Chủ nhật</label>
                </div>
                <input type="hidden" id="recurrenceRule" name="recurrenceRule"/>
            </div>
            <div class="flex gap-4">
                <div class="flex-1">
                    <label for="remindBefore" class="block font-medium mb-1">Nhắc trước:</label>
                    <input type="number" id="remindBefore" name="remindBefore" min="1" value="30" required
                           class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
                </div>
                <div class="flex-1">
                    <label for="remindUnit" class="block font-medium mb-1">Đơn vị:</label>
                    <select id="remindUnit" name="remindUnit"
                            class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400">
                        <option value="minutes">phút</option>
                        <option value="hours">giờ</option>
                        <option value="days">ngày</option>
                        <option value="weeks">tuần</option>
                    </select>
                </div>
            </div>
            <div>
                <label for="remindMethod" class="block font-medium mb-1">Cách nhắc:</label>
                <select id="remindMethod" name="remindMethod"
                        class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400">
                    <option value="0">Thông báo</option>
                    <option value="1">Email</option>
                </select>
            </div>
            <button type="button" onclick="submitCalendar()"
                    class="w-full bg-blue-600 text-white py-2 rounded font-semibold hover:bg-blue-700 transition">Tạo lịch học</button>
        </form>
        <div id="result" class="mt-4 text-green-600 font-semibold text-center"></div>
    </div>
    <script>
    function getSelectedWeekdays() {
        let checked = Array.from(document.querySelectorAll('input[name="weekdays"]:checked'))
            .map(cb => cb.value);
        return checked;
    }

    function buildRecurrenceRule() {
        let days = getSelectedWeekdays();
        if (days.length === 0) return "";
        // Lặp hàng tuần vào các ngày đã chọn
        return "FREQ=WEEKLY;INTERVAL=1;BYDAY=" + days.join(",");
    }

    function submitCalendar() {
        var formData = {
            calendarName: document.getElementById('calendarName').value,
            startDate: document.getElementById('startDate').value,
            startTime: document.getElementById('startTime').value,
            color: document.getElementById('color').value,
            eventColor: document.getElementById('eventColor').value,
            recurrenceRule: buildRecurrenceRule(),
            orderId: document.querySelector('input[name="orderId"]').value,
            remindBefore: document.getElementById('remindBefore').value,
            remindUnit: document.getElementById('remindUnit').value,
            remindMethod: document.getElementById('remindMethod').value
        };
        var contextPath = window.location.pathname.split('/')[1];
        fetch('/' + contextPath + '/calendar?action=createAjax', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: new URLSearchParams({
                action: 'createAjax',
                name: formData.calendarName,
                color: formData.color
            })
        })
        .then(response => response.json())
        .then(data => {
            let calendarId = data.calendarId;
            fetch('/' + contextPath + '/event?action=autoCreateEvents', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: new URLSearchParams({
                    action: 'autoCreateEvents',
                    orderId: formData.orderId,
                    calendarId: calendarId,
                    calendarName: formData.calendarName,
                    startDate: formData.startDate,
                    startTime: formData.startTime,
                    recurrenceRule: formData.recurrenceRule,
                    remindBefore: formData.remindBefore,
                    remindUnit: formData.remindUnit,
                    remindMethod: formData.remindMethod,
                    eventColor: formData.eventColor
                })
            })
            .then(res => res.json())
            .then(result => {
                document.getElementById('result').innerText = "Tạo lịch và các buổi học thành công!";
                setTimeout(function() {
                    window.location.href = '/' + contextPath + '/calendar';
                }, 1500);
            });
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        var now = new Date();
        var yyyy = now.getFullYear();
        var mm = String(now.getMonth() + 1).padStart(2, '0');
        var dd = String(now.getDate()).padStart(2, '0');
        var today = yyyy + '-' + mm + '-' + dd;
        document.getElementById('startDate').value = today;

        var hh = String(now.getHours()).padStart(2, '0');
        var min = String(now.getMinutes()).padStart(2, '0');
        var timeNow = hh + ':' + min;
        document.getElementById('startTime').value = timeNow;
    });
    </script>
</body>
</html>
