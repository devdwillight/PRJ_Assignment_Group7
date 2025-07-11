<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Calendar - Employee Portal</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/calendar.css">
        <link rel="stylesheet" href="css/chatBot.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    </head>
    <body class="min-h-screen bg-gray-50">
        <!-- Header: luôn ở trên cùng -->
        <header class="flex items-center gap-4 px-6 h-16 border-b bg-white shadow-sm w-full z-10">
            <button class="text-blue-500 text-2xl focus:outline-none" id="headerSidebarToggle" title="Đóng/mở sidebar">
                <!-- SVG menu icon -->
                <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" /></svg>
            </button>
            <span class="font-bold text-2xl text-blue-500 select-none">Jikan</span>
        </header>
        <!-- Main content: flex row, sidebar bên trái, content bên phải -->
        <div class="flex flex-row min-h-[calc(100vh-4rem)]">
            <!-- Sidebar (ẩn/hiện bằng translate-x) -->
            <div id="sidebarWrapper" class="w-64 transform transition-transform duration-200 ease-in-out bg-white border-r border-gray-200">
                <jsp:include page="views/base/siderbar.jsp" />
            </div>
            <div class="flex-1"></div>
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
        </script>
        <form action="logout" method="POST">
            <input type="hidden" name="action" value="logout" />
            <input type="submit" value="Logout" class="btn btn-danger" />
        </form>
    </body>
</html>