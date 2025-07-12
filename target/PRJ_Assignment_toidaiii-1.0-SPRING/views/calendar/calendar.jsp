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
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body class="bg-gray-50">
        <!-- Header -->
        <div class="flex items-center justify-between px-4 py-3 bg-white rounded-lg shadow mb-4">
            <div class="flex items-center gap-4">
                <button id="todayBtn" class="border border-gray-300 rounded-full px-4 py-2 font-medium hover:bg-gray-100 transition flex items-center gap-2">
                    <i class="fas fa-calendar-day"></i>
                    Hôm nay
                </button>
                <div class="flex items-center gap-2">
                    <button id="prevBtn" class="w-9 h-9 flex items-center justify-center rounded-full hover:bg-gray-100 text-xl transition">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <span id="currentMonthYear" class="font-semibold text-lg select-none">Tháng 7, 2025</span>
                    <button id="nextBtn" class="w-9 h-9 flex items-center justify-center rounded-full hover:bg-gray-100 text-xl transition">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>
            <div class="flex items-center gap-3">
                <button id="addEventBtn" class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition flex items-center gap-2">
                    <i class="fas fa-plus"></i>
                    Tạo sự kiện
                </button>
                <div class="relative">
                    <button id="dropdownBtn" class="border border-gray-300 rounded-full px-4 py-2 font-medium flex items-center gap-2 hover:bg-gray-100 transition">
                        <span id="currentViewLabel">Tuần</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div id="dropdownContent" class="absolute right-0 mt-2 w-32 bg-white border rounded shadow-lg hidden z-50">
                        <div class="px-4 py-2 hover:bg-blue-100 cursor-pointer flex items-center gap-2">
                            <i class="fas fa-calendar-day"></i>
                            Ngày
                        </div>
                        <div class="px-4 py-2 hover:bg-blue-100 cursor-pointer flex items-center gap-2">
                            <i class="fas fa-calendar-week"></i>
                            Tuần
                        </div>
                        <div class="px-4 py-2 hover:bg-blue-100 cursor-pointer flex items-center gap-2">
                            <i class="fas fa-calendar-alt"></i>
                            Tháng
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Quick Stats -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-4">
            <div class="bg-white p-4 rounded-lg shadow">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-600">Sự kiện hôm nay</p>
                        <p class="text-2xl font-bold text-blue-600" id="todayEventsCount">0</p>
                    </div>
                    <i class="fas fa-calendar-day text-blue-500 text-xl"></i>
                </div>
            </div>
            <div class="bg-white p-4 rounded-lg shadow">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-600">Sự kiện tuần này</p>
                        <p class="text-2xl font-bold text-green-600" id="weekEventsCount">0</p>
                    </div>
                    <i class="fas fa-calendar-week text-green-500 text-xl"></i>
                </div>
            </div>
            <div class="bg-white p-4 rounded-lg shadow">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-600">Sự kiện đã hoàn thành</p>
                        <p class="text-2xl font-bold text-purple-600" id="completedEventsCount">0</p>
                    </div>
                    <i class="fas fa-check-circle text-purple-500 text-xl"></i>
                </div>
            </div>
            <div class="bg-white p-4 rounded-lg shadow">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-600">Sự kiện sắp tới</p>
                        <p class="text-2xl font-bold text-orange-600" id="upcomingEventsCount">0</p>
                    </div>
                    <i class="fas fa-clock text-orange-500 text-xl"></i>
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
        
        <!-- Loading Overlay -->
        <div id="calendarLoading" class="fixed inset-0 bg-white bg-opacity-75 flex items-center justify-center z-40" style="display: none;">
            <div class="flex items-center space-x-2">
                <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
                <span class="text-gray-600">Đang tải...</span>
            </div>
        </div>
        
        <script src="../../js/calendar.js" type="text/javascript"></script>
        <script type="text/javascript">
            // Thêm sự kiện cho nút tạo sự kiện
            document.getElementById('addEventBtn').addEventListener('click', function() {
                showEventModal();
            });
            
            // Cập nhật thống kê
            function updateStats() {
                // TODO: Implement actual stats calculation
                document.getElementById('todayEventsCount').textContent = Math.floor(Math.random() * 5);
                document.getElementById('weekEventsCount').textContent = Math.floor(Math.random() * 15);
                document.getElementById('completedEventsCount').textContent = Math.floor(Math.random() * 10);
                document.getElementById('upcomingEventsCount').textContent = Math.floor(Math.random() * 8);
            }
            
            // Cập nhật thống kê khi trang load
            updateStats();
            
            // Cập nhật thống kê mỗi phút
            setInterval(updateStats, 60000);
        </script>
    </body>
</html>