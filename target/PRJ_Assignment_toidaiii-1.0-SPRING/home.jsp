<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Calendar - Employee Portal</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <script src="js/calendar.js"></script>
        <script>
            // Đảm bảo đoạn này nằm sau khi calendar.js đã load
            const originalRenderEvents = renderEvents;
            renderEvents = function () {
                if (currentView === 'month') {
                    renderMonthEvents();
                } else {
                    originalRenderEvents();
                }
            };
        </script>
    </head>
    <body class="min-h-screen bg-gray-50">
        <!-- Header: luôn ở trên cùng -->
        <header class="flex items-center gap-4 px-6 h-16 border-b bg-white shadow-sm w-full z-10">
            <button class="text-blue-500 text-2xl focus:outline-none" id="headerSidebarToggle" title="Đóng/mở sidebar">
                <!-- SVG menu icon -->
                <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" /></svg>
            </button>
            <span class="font-bold text-2xl text-blue-500 select-none">Jikan</span>
            <!-- Thêm các nút điều hướng lịch vào đây -->
            <div class="flex items-center gap-4 ml-8">
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

                <div class="relative ml-2">
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
            <!-- Thêm vào header, ngay sau các nút điều hướng -->
            <button id="addEventBtn" class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition flex items-center gap-2">
                <i class="fas fa-plus"></i>
                Tạo sự kiện
            </button>
        </header>

        <!-- Error Message (nếu có) -->
        <% if (request.getAttribute("error") != null) {%>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
            <strong class="font-bold">Lỗi!</strong>
            <span class="block sm:inline"><%= request.getAttribute("error")%></span>
        </div>
        <% }%>

        <!-- Main content: flex row, sidebar bên trái, content bên phải -->
        <div class="flex flex-row min-h-[calc(100vh-4rem)]">
            <!-- Sidebar (ẩn/hiện bằng translate-x) -->
            <div id="sidebarWrapper" class="w-64 transform transition-transform duration-200 ease-in-out bg-white border-r border-gray-200">
                <jsp:include page="views/base/siderbar.jsp" />
            </div>
            <div class="flex-1 p-6">
                <!-- Views -->
                <div id="calendarDay" style="display:none;">
                    <jsp:include page="views/calendar/calendarDay.jsp"/>
                </div>
                <div id="calendarWeek" style="display:block;">
                    <jsp:include page="views/calendar/calendarWeek.jsp"/>
                </div>
                <div id="calendarMonth" style="display:none;">
                    <jsp:include page="views/calendar/calendarMonth.jsp"/>
                </div>
                <!-- Loading Overlay -->
                <div id="calendarLoading" class="fixed inset-0 bg-white bg-opacity-75 flex items-center justify-center z-40" style="display: none;">
                    <div class="flex items-center space-x-2">
                        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
                        <span class="text-gray-600">Đang tải...</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Hidden data from server -->
        <div id="serverData" style="display: none;">
            <input type="hidden" id="currentDate" value="<%= request.getAttribute("currentDate")%>" />
            <input type="hidden" id="userId" value="<%= request.getAttribute("userId")%>" />
            <input type="hidden" id="calendarCount" value="<%= ((java.util.List) request.getAttribute("calendars")).size()%>" />
            <input type="hidden" id="todoCount" value="<%= ((java.util.List) request.getAttribute("todos")).size()%>" />
        </div>

        <script>
            // Logic đóng/mở sidebar bằng translate-x
            const sidebarWrapper = document.getElementById('sidebarWrapper');
            const toggleBtn = document.getElementById('headerSidebarToggle');
            let sidebarOpen = true;
            function setSidebar(open) {
                sidebarOpen = open;
                if (open) {
                    sidebarWrapper.classList.remove('-translate-x-full');
                } else {
                    sidebarWrapper.classList.add('-translate-x-full');
                }
            }
            // Khởi tạo trạng thái mở
            setSidebar(true);
            toggleBtn.onclick = function () {
                setSidebar(!sidebarOpen);
            };

            // Thêm sự kiện cho nút tạo sự kiện
            document.getElementById('addEventBtn').addEventListener('click', function () {
                showEventModal();
            });

            // Log thông tin từ server
            console.log('Server data loaded:');
            console.log('- Current date:', document.getElementById('currentDate').value);
            console.log('- User ID:', document.getElementById('userId').value);
            console.log('- Calendar count:', document.getElementById('calendarCount').value);
            console.log('- Todo count:', document.getElementById('todoCount').value);

            // Nếu có lỗi từ server, hiển thị notification
            var serverError = '<%= request.getAttribute("error") != null ? request.getAttribute("error") : ""%>';
            if (serverError && serverError !== '') {
                setTimeout(function () {
                    if (typeof showNotification === 'function') {
                        showNotification(serverError);
                    }
                }, 1000);
            }
        </script>
        <form action="logout" method="POST">
            <input type="hidden" name="action" value="logout" />
            <input type="submit" value="Logout" class="btn btn-danger" />
        </form>
    </body>
</html>