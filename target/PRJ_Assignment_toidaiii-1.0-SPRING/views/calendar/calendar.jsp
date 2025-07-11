<%-- 
    Document   : Calendar
    Created on : Jul 10, 2025, 11:14:34 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50">
        <!-- Header -->
        <div class="flex items-center justify-between px-4 py-3 bg-white rounded-lg shadow mb-4">
            <button id="todayBtn" class="border border-gray-300 rounded-full px-4 py-2 font-medium hover:bg-gray-100 transition">Hôm nay</button>
            <div class="flex items-center gap-2">
                <button id="prevBtn" class="w-9 h-9 flex items-center justify-center rounded-full hover:bg-gray-100 text-xl transition">‹</button>
                <span id="currentMonthYear" class="font-semibold text-lg select-none">Tháng 7, 2025</span>
                <button id="nextBtn" class="w-9 h-9 flex items-center justify-center rounded-full hover:bg-gray-100 text-xl transition">›</button>
            </div>
            <div class="relative">
                <button id="dropdownBtn" class="border border-gray-300 rounded-full px-4 py-2 font-medium flex items-center gap-2 hover:bg-gray-100 transition">
                    <span id="currentViewLabel">Tuần</span>
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                    </svg>
                </button>
                <div id="dropdownContent" class="absolute right-0 mt-2 w-32 bg-white border rounded shadow-lg hidden z-50">
                    <div class="px-4 py-2 hover:bg-blue-100 cursor-pointer">Ngày</div>
                    <div class="px-4 py-2 hover:bg-blue-100 cursor-pointer">Tuần</div>
                    <div class="px-4 py-2 hover:bg-blue-100 cursor-pointer">Tháng</div>
                </div>
            </div>
        </div>
        <!-- Views -->
        <div id="calendarDay" style="display:none;">
            <jsp:include page="calendarDay.jsp"/>
        </div>
        <div id="calendarWeek" style="display:block;">
            <jsp:include page="calendarWeek.jsp"/>
        </div>
        <div id="calendarMonth" style="display:none;">
            <jsp:include page="calendarMonth.jsp"/>
        </div>
        <script src="../../js/calendar.js" type="text/javascript"></script>
    </body>
</html>