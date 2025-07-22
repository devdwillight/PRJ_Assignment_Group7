<%-- 
    Document   : subHome
    Created on : Jul 19, 2025, 10:49:15 AM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sub Home - Employee Portal</title>

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
            
            /* CSS cho layout scroll ngang */
            .main-content-area {
                overflow: hidden;
                height: calc(100vh - 4rem);
            }
            
            .task-content-wrapper {
                height: 100%;
                overflow: hidden;
            }

            /* Hiệu ứng mở/đóng chatbox agent giống home.jsp */
            #chatboxSidebar {
                transform: translateX(100%);
                transition: transform 0.2s;
            }
            #chatboxSidebar.open {
                transform: translateX(0) !important;
            }
        </style>
    </head>
    <body class="min-h-screen bg-gray-50">
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

                <!-- Segmented Control Calendar/Task -->
                <div class="relative">
                    <div class="flex bg-gray-100 rounded-full p-1">
                        <a href="calendar" class="flex items-center gap-2 px-4 py-2 rounded-full transition-all duration-200 text-gray-600 hover:text-gray-800">
                            <i class="fas fa-calendar-alt text-sm"></i>
                        </a>
                        <a href="task" class="flex items-center gap-2 px-4 py-2 rounded-full transition-all duration-200 bg-blue-500 text-white shadow-sm">
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
                            <button class="w-full text-left px-4 py-2 text-gray-700 hover:bg-blue-50 hover:text-blue-600 transition-colors">
                                <input type="submit" value="Logout" />
                            </button>
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
        <div class="flex flex-row min-h-[calc(100vh-4rem)]">
            <!-- Sidebar (ẩn/hiện bằng translate-x) -->
            <div id="sidebarWrapper" class="w-64 transform transition-transform duration-200 ease-in-out bg-white border-r border-gray-200">
                <jsp:include page="views/base/subSiderbar.jsp" />
            </div>

            <!-- Main Content Area -->
            <div class="flex-1 h-full min-h-0 max-h-[calc(100vh-4rem)] main-content-area">
                <div class="h-full min-h-0 task-content-wrapper">
                    <jsp:include page="views/task/task.jsp" />
                </div>
            </div>
        </div>

        <!-- Sidebar Chatbox Agent (ẩn/hiện bằng JS) -->
        <div id="chatboxSidebar" class="fixed top-0 right-0 h-full w-80 bg-white border-l border-gray-200 shadow-lg z-50 transform translate-x-full transition-transform duration-200 ease-in-out">
            <div class="h-full">
                <jsp:include page="views/agent/siderAgent.jsp" />
            </div>
        </div>

       

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

            // Sidebar toggle functionality
            const sidebarWrapper = document.getElementById('sidebarWrapper');
            const toggleBtn = document.getElementById('headerSidebarToggle');
            let sidebarOpen = true;

            function setSidebar(open) {
                sidebarOpen = open;
                if (open) {
                    sidebarWrapper.classList.remove('closed', 'overflow-hidden', 'p-0');
                } else {
                    sidebarWrapper.classList.add('closed', 'overflow-hidden', 'p-0');
                }
                setTimeout(function () {
                    window.dispatchEvent(new Event('resize'));
                }, 250);
            }

            // Khởi tạo trạng thái mở
            setSidebar(true);

            toggleBtn.onclick = function () {
                setSidebar(!sidebarOpen);
            };

            // Chatbox sidebar logic (giống home.jsp)
            document.addEventListener('DOMContentLoaded', function () {
                const chatboxSidebar = document.getElementById('chatboxSidebar');
                const chatboxToggleBtn = document.getElementById('chatboxToggleBtn');
                const closeBtn = document.getElementById('closeChatboxBtn');
                function resizeCalendar() {
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
                                    alert(serverError);
                }, 1000);
            }

           
        </script>

        <!-- Logout Form -->
        <form action="logout" method="POST" style="display: none;">
            <input type="hidden" name="action" value="logout" />
            <input type="submit" value="Logout" class="btn btn-danger" />
        </form>
    </body>
</html>
