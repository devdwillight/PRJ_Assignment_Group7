<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Calendar - Employee Portal</title>


        <!-- FullCalendar CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.2/main.min.css">

        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

        <style>
            html, body {
                overflow: hidden;
            }

            /* Thêm vào CSS */
            #sidebarWrapper.closed {
                width: 0 !important;
                min-width: 0 !important;
                transition: width 0.2s;
            }
            #sidebarWrapper {
                width: 16rem; /* 256px */
                transition: width 0.2s;
            }

            .fc-button-primary{
                background-color: #3b82f6!important;
                border-color: #3b82f6!important;
                color: white!important;
                padding: 8px 12px!important;
                border-radius: 6px!important;
            }
            .fc-button-primary:hover{
                background-color: #2563eb!important;
                border-color: #2563eb!important;
            }
            .fc-button-primary:focus{
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.5)!important;
            }
            .fc-button-group .fc-button{
                margin: 0 2px!important;
                border-radius: 6px!important;
            }
            .fc-view .fc-col-header-cell{
                padding: 10px 0!important;
                background-color: #f8fafc!important;
            }
            .fc-theme-standard td, .fc-theme-standard th{
                border: 1px solid #e2e8f0!important;
            }
            .fc-daygrid-event{
                border-radius: 4px!important;
                margin: 1px 0!important;
            }
            .fc-daygrid-day-top{
                font-size: 16px;
                font-weight: 500;
            }
            .fc-col-header-cell-cushion {
                font-size: 18px;
                font-weight: 600!important;
                color: #374151!important;
            }
            .fc-event-time{
                font-size: 14px;
            }
            .fc-event-title{
                font-size: 14px;
                font-weight: 500;
            }
            #calendar > div > div > table > thead > tr > th > div > div,
            #calendar > div > div > table > tbody > tr:nth-child(1) > td > div > div {
                overflow-y: hidden !important;
            }

            /* Thêm vào CSS cho chatbox */
            #chatboxSidebar.open {
                transform: translateX(0) !important;
            }
        </style>
    </head>
    <body class="min-h-screen bg-gray-50 ">
        <!-- Header: luôn ở trên cùng -->
        <header class="flex items-center gap-4 px-6 h-16 border-b bg-white shadow-sm w-full z-10">
            <!-- Sidebar Toggle Button -->
            <button class="text-blue-500 text-2xl focus:outline-none" id="headerSidebarToggle" title="Đóng/mở sidebar">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                </svg>
            </button>

            <!-- Logo -->
            <span class="font-bold text-2xl text-blue-500 select-none px-10">Jikan</span>

            <!-- Calendar Navigation -->
            <div class="flex items-center gap-4 ml-8">
                <!-- Navigation Buttons -->
                <div class="flex items-center gap-2">
                    <button id="todayBtn" class="px-3 py-1.5 text-sm font-medium text-blue-600 bg-blue-50 border border-blue-200 rounded-md hover:bg-blue-100 transition-colors">
                        Hôm nay
                    </button>
                    <button id="prevBtn" class="p-2 text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded-md transition-colors" title="Tháng trước">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button id="nextBtn" class="p-2 text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded-md transition-colors" title="Tháng sau">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>

                <!-- Calendar Title -->
                <h1 id="calendarTitle" class="text-xl font-semibold text-gray-800 ml-4">
                    <%= new java.text.SimpleDateFormat("MMMM 'năm' yyyy", new java.util.Locale("vi")).format(new java.util.Date())%>
                </h1>
            </div>

            <!-- Right Menu -->
            <div class="ml-auto flex items-center gap-4">




                <div class="relative mr-2">
                    <a href="Course" title="Khoá học" class="flex items-center gap-2 text-gray-700 hover:text-blue-500 px-3 py-2 rounded-md hover:bg-gray-100 transition-colors">
                        <i class="fas fa-shopping-cart text-xl"></i>
                    </a>
                </div>


                <!-- Nút mở chatbox -->
                <button id="chatboxToggleBtn" class="flex items-center gap-2 text-blue-500 hover:text-blue-700 px-3 py-2 rounded-md hover:bg-blue-100 transition-colors" title="Chat với Agent">
                    <i class="fas fa-comments text-2xl"></i>
                </button>


                <!--nút dropdown content đổi Tháng Tuần Ngày Danh sách-->
                <div class="relative">
                    <button id="viewDropdownBtn" class="flex items-center gap-2 text-gray-700 hover:text-blue-500 px-3 py-2 rounded-md hover:bg-gray-100 transition-colors">
                        <i class="fas fa-calendar-alt text-lg"></i>
                        <span id="currentViewText">Tháng</span>
                        <i class="fas fa-chevron-down text-sm"></i>
                    </button>

                    <!-- Dropdown Menu -->
                    <div id="viewDropdownMenu" class="absolute right-0 mt-2 w-32 bg-white border border-gray-200 rounded-md shadow-lg z-50 hidden">
                        <div class="py-1">
                            <button id="viewMonth" class="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-blue-50 hover:text-blue-600 transition-colors">
                                <i class="fas fa-calendar mr-2"></i>Tháng
                            </button>
                            <button id="viewWeek" class="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-blue-50 hover:text-blue-600 transition-colors">
                                <i class="fas fa-calendar-week mr-2"></i>Tuần
                            </button>
                            <button id="viewDay" class="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-blue-50 hover:text-blue-600 transition-colors">
                                <i class="fas fa-calendar-day mr-2"></i>Ngày
                            </button>
                            <button id="viewList" class="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-blue-50 hover:text-blue-600 transition-colors">
                                <i class="fas fa-list mr-2"></i>Danh sách
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Segmented Control Calendar/Task -->
                <div class="relative">
                    <div class="flex bg-gray-100 rounded-full p-1">
                        <a href="calendar" class="flex items-center gap-2 px-4 py-2 rounded-full transition-all duration-200 bg-blue-500 text-white shadow-sm">
                            <i class="fas fa-calendar-alt text-sm"></i>
                        </a>
                        <a href="task" class="flex items-center gap-2 px-4 py-2 rounded-full transition-all duration-200 text-gray-600 hover:text-gray-800">
                            <i class="fas fa-check-circle text-sm"></i>
                        </a>
                    </div>
                </div>

                <div class="relative">
                    <%
                        com.model.User user = (com.model.User) session.getAttribute("user");
                        String avatar = (user != null && user.getAvatar() != null && !user.getAvatar().isEmpty())
                            ? user.getAvatar()
                            : (request.getContextPath() + "/assets/User.svg");
                    %>
                    <button id="userDropdownBtn" class="flex items-center gap-2 text-gray-700 hover:text-blue-500 px-3 py-2 rounded-md hover:bg-gray-100 transition-colors">
                        <img src="<%= avatar %>" alt="avatar" class="w-8 h-8 rounded-full object-cover border" />
                        <span><%= user != null ? user.getUsername() : "Người dùng" %></span>
                        <i class="fas fa-chevron-down text-sm"></i>
                    </button>
                    <!-- Dropdown menu -->
                    <div id="userDropdownMenu" class="absolute right-0 mt-2 w-40 bg-white border border-gray-200 rounded-md shadow-lg z-50 hidden">
                        <a href="editProfile.jsp" class="block px-4 py-2 text-gray-700 hover:bg-blue-50 hover:text-blue-600 transition-colors">Edit Profile</a>
                        <form action="logout" method="POST">
                            <input type="hidden" name="action" value="logout" />
                            <button  class="w-full text-left px-4 py-2 text-gray-700 hover:bg-blue-50 hover:text-blue-600 transition-colors">  <input type="submit" value="Logout" /> </button>
                        </form>
                    </div>
                </div>


            </div>
        </header>

        <!-- Error Message (nếu có) -->
        <% if (request.getAttribute("error") != null) {%>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
            <strong class="font-bold">Lỗi!</strong>
            <span class="block sm:inline"><%= request.getAttribute("error")%></span>
        </div>
        <% }%>

        <!-- Main content: flex row, sidebar bên trái, content bên phải -->
        <div class="flex flex-row min-h-[calc(100vh-4rem)] ">
            <!-- Sidebar (ẩn/hiện bằng translate-x) -->
            <div id="sidebarWrapper" class="w-64 transform transition-transform duration-200 ease-in-out bg-white border-r border-gray-200">
                <jsp:include page="views/base/siderbar.jsp" />
            </div>

            <!-- Main Content Area -->
            <div class="flex-1 h-full min-h-0 max-h-[calc(100vh-4rem)]">
                <div class="h-full min-h-0">
                    <jsp:include page="views/calendar/calendar.jsp" />
                </div>
            </div>
        </div>

        <!-- FullCalendar JS -->
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.2/main.min.js"></script>

        <script>

            // Dropdown User
            const userDropdownBtn = document.getElementById('userDropdownBtn');
            const userDropdownMenu = document.getElementById('userDropdownMenu');
            userDropdownBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                userDropdownMenu.classList.toggle('hidden');
            });
            document.addEventListener('click', function (e) {
                if (!userDropdownBtn.contains(e.target) && !userDropdownMenu.contains(e.target)) {
                    userDropdownMenu.classList.add('hidden');
                }
            });

            // Sidebar trái
            const sidebarWrapper = document.getElementById('sidebarWrapper');
            let sidebarOpen = true;
            function setSidebar(open) {
                sidebarOpen = open;
                if (open) {
                    sidebarWrapper.classList.remove('closed', 'overflow-hidden', 'p-0');
                } else {
                    sidebarWrapper.classList.add('closed', 'overflow-hidden', 'p-0');
                }
                setTimeout(function () {
                    if (window.calendar) {
                        window.calendar.updateSize();
                        window.calendar.render();
                    }
                    window.dispatchEvent(new Event('resize'));
                }, 250);
            }
            setSidebar(true);

            // Nút toggle sidebar trái
            const toggleBtn = document.getElementById('headerSidebarToggle');
            if (toggleBtn) {
                toggleBtn.onclick = function () {
                    setSidebar(!sidebarOpen);
                };
            }

            // Dropdown đổi Tháng/Tuần/Ngày/Danh sách
            const viewDropdownBtn = document.getElementById('viewDropdownBtn');
            const viewDropdownMenu = document.getElementById('viewDropdownMenu');
            const currentViewText = document.getElementById('currentViewText');
            if (viewDropdownBtn && viewDropdownMenu) {
                viewDropdownBtn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    viewDropdownMenu.classList.toggle('hidden');
                });
                document.addEventListener('click', function(e) {
                    if (!viewDropdownBtn.contains(e.target) && !viewDropdownMenu.contains(e.target)) {
                        viewDropdownMenu.classList.add('hidden');
                    }
                });
            }

            function updateViewButtons(activeView) {
                // Update current view text
                const viewTexts = {
                    'month': 'Tháng',
                    'week': 'Tuần',
                    'day': 'Ngày',
                    'list': 'Danh sách'
                };
                currentViewText.textContent = viewTexts[activeView] || 'Tháng';
                // Close dropdown
                viewDropdownMenu.classList.add('hidden');
            }

            function updateCalendarTitle() {
                if (window.calendar) {
                    const currentDate = window.calendar.getDate();
                    // Luôn hiển thị theo tháng và năm, bất kể view type
                    let title = currentDate.toLocaleDateString('vi-VN', {month: 'long', year: 'numeric'});
                    const calendarTitle = document.getElementById('calendarTitle');
                    if (calendarTitle) calendarTitle.textContent = title;
                }
            }
            window.updateViewButtons = updateViewButtons;
            window.updateCalendarTitle = updateCalendarTitle;

            // View button event listeners
            const viewMonthBtn = document.getElementById('viewMonth');
            const viewWeekBtn = document.getElementById('viewWeek');
            const viewDayBtn = document.getElementById('viewDay');
            const viewListBtn = document.getElementById('viewList');
            if (viewMonthBtn) viewMonthBtn.addEventListener('click', function () {
                if (window.calendar) {
                    window.calendar.changeView('dayGridMonth');
                    updateViewButtons('month');
                    updateCalendarTitle();
                }
            });
            if (viewWeekBtn) viewWeekBtn.addEventListener('click', function () {
                if (window.calendar) {
                    window.calendar.changeView('timeGridWeek');
                    updateViewButtons('week');
                    updateCalendarTitle();
                }
            });
            if (viewDayBtn) viewDayBtn.addEventListener('click', function () {
                if (window.calendar) {
                    window.calendar.changeView('timeGridDay');
                    updateViewButtons('day');
                    updateCalendarTitle();
                }
            });
            if (viewListBtn) viewListBtn.addEventListener('click', function () {
                if (window.calendar) {
                    window.calendar.changeView('listWeek');
                    updateViewButtons('list');
                    updateCalendarTitle();
                }
            });

            // Navigation button event listeners
            const prevBtn = document.getElementById('prevBtn');
            const todayBtn = document.getElementById('todayBtn');
            const nextBtn = document.getElementById('nextBtn');
            if (prevBtn) prevBtn.addEventListener('click', function () {
                if (window.calendar) {
                    window.calendar.prev();
                    updateCalendarTitle();
                }
            });
            if (todayBtn) todayBtn.addEventListener('click', function () {
                if (window.calendar) {
                    window.calendar.today();
                    updateCalendarTitle();
                }
            });
            if (nextBtn) nextBtn.addEventListener('click', function () {
                if (window.calendar) {
                    window.calendar.next();
                    updateCalendarTitle();
                }
            });

            // Chatbox sidebar logic giữ nguyên
            document.addEventListener('DOMContentLoaded', function () {
                const chatboxSidebar = document.getElementById('chatboxSidebar');
                const chatboxToggleBtn = document.getElementById('chatboxToggleBtn');
                const closeBtn = document.getElementById('closeChatboxBtn');
                function resizeCalendar() {
                    if (window.calendar) {
                        window.calendar.updateSize();
                        window.calendar.render();
                    }
                    window.dispatchEvent(new Event('resize'));
                }
                if (chatboxToggleBtn && chatboxSidebar) {
                    chatboxToggleBtn.onclick = function (e) {
                        chatboxSidebar.classList.toggle('open');
                        resizeCalendar();
                        e.stopPropagation();
                    };
                }
                document.addEventListener('click', function (e) {
                    if (
                        chatboxSidebar &&
                        chatboxSidebar.classList.contains('open') &&
                        !chatboxSidebar.contains(e.target) &&
                        e.target !== chatboxToggleBtn
                    ) {
                        chatboxSidebar.classList.remove('open');
                        resizeCalendar();
                    }
                });
                if (chatboxSidebar) {
                    chatboxSidebar.addEventListener('click', function (e) {
                        e.stopPropagation();
                    });
                }
                if (closeBtn && chatboxSidebar) {
                    closeBtn.onclick = function (e) {
                        chatboxSidebar.classList.remove('open');
                        resizeCalendar();
                        e.stopPropagation();
                    };
                }
            });

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

        <!-- Logout Form -->
        <form action="logout" method="POST" style="display: none;">
            <input type="hidden" name="action" value="logout" />
            <input type="submit" value="Logout" class="btn btn-danger" />
        </form>

        <!-- Sidebar Chatbox Agent (ẩn/hiện bằng JS) -->
        <div id="chatboxSidebar" class="fixed top-0 right-0 h-full w-80 bg-white border-l border-gray-200 shadow-lg z-50 transform translate-x-full transition-transform duration-200 ease-in-out">
            <div class="h-full">
                <jsp:include page="views/agent/siderAgent.jsp" />
            </div>
        </div>
    </body>
</html>