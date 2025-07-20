<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Quản lý Lịch</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f5f5f5;
                color: #333;
            }

            .sidebar {
                width: 250px;
                height: 100vh;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                position: fixed;
                left: 0;
                top: 0;
                padding: 20px;
                color: white;
                transition: all 0.3s ease;
            }

            .sidebar h2 {
                margin-bottom: 30px;
                text-align: center;
                font-size: 24px;
            }

            .avatar {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                margin: 0 auto 15px;
                display: block;
                border: 3px solid rgba(255,255,255,0.3);
            }

            .admin-name {
                text-align: center;
                margin-bottom: 30px;
                font-size: 14px;
                opacity: 0.9;
            }

            .nav {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .nav a {
                color: white;
                text-decoration: none;
                padding: 12px 15px;
                border-radius: 8px;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .nav a:hover, .nav a.active {
                background: rgba(255,255,255,0.2);
                transform: translateX(5px);
            }

            .nav a i {
                width: 20px;
            }

            .main {
                margin-left: 250px;
                padding: 20px;
                min-height: 100vh;
                transition: all 0.3s ease;
            }
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                position: sticky;
                top: 0;
                z-index: 100;
            }

            .toggle-sidebar-btn {
                background: none;
                border: none;
                font-size: 20px;
                cursor: pointer;
                color: #333;
                padding: 8px;
                border-radius: 6px;
                transition: all 0.3s ease;
            }

            .toggle-sidebar-btn:hover {
                background: #f0f0f0;
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .user-info img {
                width: 40px;
                height: 40px;
                border-radius: 50%;
            }

            body.sidebar-collapsed .sidebar {
                transform: translateX(-100%);
            }

            body.sidebar-collapsed .main {
                margin-left: 0;
            }
            .dashboard-content {
                padding: 30px;
            }
            .cards {
                display: grid;
                grid-template-columns: repeat(5, 1fr);
                gap: 24px;
                margin-bottom: 30px;
            }
            .card {
                background: #fff;
                border-radius: 16px;
                padding: 24px;
                box-shadow: 0 2px 8px #e0e0e0;
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }
            .card .card-title {
                font-size: 14px;
                color: #888;
                margin-bottom: 8px;
            }
            .card .card-value {
                font-size: 28px;
                font-weight: bold;
                margin-bottom: 4px;
                color: #263544;
            }
            .card .card-desc {
                font-size: 12px;
                color: #4caf50;
            }
            .card .card-desc.negative {
                color: #f44336;
            }
            .charts-row {
                display: grid;
                grid-template-columns: 2.5fr 1fr;
                gap: 24px;
                margin-bottom: 30px;
            }
            .chart-box {
                background: #fff;
                border-radius: 16px;
                padding: 24px;
                box-shadow: 0 2px 8px #e0e0e0;
            }
            .chart-canvas-wrap {
                overflow-x: auto;
                width: 100%;
                max-width: 100%;
            }
            .tables-row {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr;
                gap: 24px;
            }
            .table-box {
                background: #fff;
                border-radius: 16px;
                padding: 24px;
                box-shadow: 0 2px 8px #e0e0e0;
            }
            .table-box table {
                width: 100%;
                border-collapse: collapse;
            }
            .table-box th, .table-box td {
                padding: 8px 4px;
                text-align: left;
                font-size: 14px;
            }
            .table-box th {
                color: #2196f3;
            }
            .footer {
                text-align: center;
                color: #888;
                font-size: 13px;
                margin-top: 30px;
            }
            .toggle-sidebar-btn {
                background: none;
                border: none;
                font-size: 24px;
                cursor: pointer;
                margin-right: 20px;
                color: #4fc3f7;
                display: flex;
                align-items: center;
                transition: color 0.3s ease;
            }
            .toggle-sidebar-btn:hover {
                color: #1976d2;
            }
            @media (max-width: 1200px) {
                .cards {
                    grid-template-columns: repeat(3, 1fr);
                }
                .charts-row, .tables-row {
                    grid-template-columns: 1fr 1fr;
                }
            }
            @media (max-width: 800px) {
                .cards, .charts-row, .tables-row {
                    grid-template-columns: 1fr;
                }
                .sidebar {
                    width: 100px;
                }
                .sidebar-collapsed .sidebar {
                    width: 0;
                }
                .main {
                    margin-left: 100px;
                }
                .sidebar-collapsed .main {
                    margin-left: 0;
                }
            }
            .header-nav {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 8px;
                padding: 10px 0;
                position: absolute;
                top: 60px;
                left: 50px;
                z-index: 1000;
                min-width: 220px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.12);
            }
            .header-nav a {
                color: white;
                text-decoration: none;
                padding: 12px 20px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                gap: 10px;
                transition: background 0.2s;
            }
            .header-nav a:hover, .header-nav a.active {
                background: rgba(255,255,255,0.2);
            }
            @media (max-width: 900px) {
                .sidebar {
                    display: none;
                }
                .main {
                    margin-left: 0;
                }
                .header-nav {
                    position: static;
                    min-width: unset;
                    box-shadow: none;
                    margin-left: 10px;
                }
            }
            .header-nav-horizontal {
                display: flex;
                flex-direction: row;
                align-items: center;
                gap: 8px;
                background: none;
                position: static;
                box-shadow: none;
                padding: 0;
                margin-left: 16px;
            }
            .header-nav-horizontal a {
                color: #667eea;
                background: #f5f5f5;
                text-decoration: none;
                padding: 8px 16px;
                border-radius: 6px;
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 500;
                transition: background 0.2s, color 0.2s;
            }
            .header-nav-horizontal a:hover, .header-nav-horizontal a.active {
                background: #667eea;
                color: #fff;
            }
        </style>
    </head>
    <body>
        <div class="sidebar" id="sidebar">
            <h2>JiKan</h2>
            <img src="https://randomuser.me/api/portraits/men/32.jpg" class="avatar" alt="avatar"/>
            <div class="admin-name">Welcome, Admin</div>
            <div class="nav" id="sidebarNav">
                <a href="${pageContext.request.contextPath}/admin" class="active"><i class="fa fa-home"></i> Trang chủ</a>
                <a href="${pageContext.request.contextPath}/admin/users"><i class="fa fa-users"></i> Người dùng</a>
                <a href="${pageContext.request.contextPath}/admin/courses"><i class="fa fa-book"></i> Khóa học</a>
                <a href="${pageContext.request.contextPath}/admin/orders"><i class="fa fa-shopping-cart"></i> Đơn hàng</a>
                <a href="${pageContext.request.contextPath}/admin/revenue"><i class="fa fa-chart-line"></i> Doanh thu</a>
            </div>
        </div>
        <div class="main" id="mainContent">
            <div class="header">
                <button class="toggle-sidebar-btn" id="toggleSidebarBtn" title="Ẩn/hiện menu">
                    <i class="fa fa-bars"></i>
                </button>
                <!-- Menu nav trên header, ẩn mặc định, hiển thị ngang -->
                <div class="nav header-nav-horizontal" id="headerNav" style="display:none;">
                    <a href="${pageContext.request.contextPath}/admin"><i class="fa fa-home"></i> Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/admin/users"><i class="fa fa-users"></i> Người dùng</a>
                    <a href="${pageContext.request.contextPath}/admin/courses"><i class="fa fa-book"></i> Khóa học</a>
                    <a href="${pageContext.request.contextPath}/admin/orders"><i class="fa fa-shopping-cart"></i> Đơn hàng</a>
                    <a href="${pageContext.request.contextPath}/admin/revenue"><i class="fa fa-chart-line"></i> Doanh thu</a>
                </div>
                <div class="user-info">
                    <div class="relative">
                        <button id="userDropdownBtn" class="flex items-center gap-2 text-gray-700 hover:text-blue-500 px-3 py-2 rounded-md hover:bg-gray-100 transition-colors">
                            <i class="fas fa-user-circle text-xl"></i>
                            <span>Admin</span>
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
            </div>
            <div class="dashboard-content">
                <!-- 5 thẻ số liệu -->
                <div class="cards">
                    <div class="card">
                        <div class="card-title">Tổng người dùng</div>
                        <div class="card-value">${userCount}</div>
                        <div class="card-desc">
                            <c:choose>
                                <c:when test="${userPercentChange >= 0}">
                                    <span style="color: #43a047;">+<fmt:formatNumber value="${userPercentChange}" maxFractionDigits="1"/>% so với tháng trước</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #e53935;"><fmt:formatNumber value="${userPercentChange}" maxFractionDigits="1"/>% so với tháng trước</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-title">Lịch</div>
                        <div class="card-value">${calendarCount}</div>
                        <div class="card-desc">
                            <c:choose>
                                <c:when test="${calendarPercentChange >= 0}">
                                    <span style="color: #43a047;">+<fmt:formatNumber value="${calendarPercentChange}" maxFractionDigits="1"/>% so với tháng trước</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #e53935;"><fmt:formatNumber value="${calendarPercentChange}" maxFractionDigits="1"/>% so với tháng trước</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-title">Sự kiện hôm nay</div>
                        <div class="card-value">${todayEventCount}</div>
                        <div class="card-desc">
                            <c:choose>
                                <c:when test="${eventPercentChange >= 0}">
                                    <span style="color: #43a047;">+<fmt:formatNumber value="${eventPercentChange}" maxFractionDigits="1"/>% so với tháng trước</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #e53935;"><fmt:formatNumber value="${eventPercentChange}" maxFractionDigits="1"/>% so với tháng trước</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-title">Khóa học</div>
                        <div class="card-value">${courseCount}</div>
                        <div class="card-desc">
                            <c:choose>
                                <c:when test="${coursePercentChange >= 0}">
                                    <span style="color: #43a047;">+<fmt:formatNumber value="${coursePercentChange}" maxFractionDigits="1"/>% so với tháng trước</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #e53935;"><fmt:formatNumber value="${coursePercentChange}" maxFractionDigits="1"/>% so với tháng trước</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-title">Doanh thu</div>
                        <div class="card-value">${totalRevenue}</div>
                        <div class="card-desc">
                            <c:choose>
                                <c:when test="${revenuePercentChange >= 0}">
                                    <span style="color: #43a047;">+<fmt:formatNumber value="${revenuePercentChange}" maxFractionDigits="1"/>% so với tháng trước</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #e53935;"><fmt:formatNumber value="${revenuePercentChange}" maxFractionDigits="1"/>% so với tháng trước</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <!-- 2 biểu đồ -->
                <div class="charts-row">
                    <div class="chart-box grouped-bar-box">
                        <div class="chart-title">Thống kê theo tháng</div>
                        <div class="chart-canvas-wrap">
                            <canvas id="groupedBarChart" height="320" style="width:100%;max-width:100%"></canvas>
                        </div>
                    </div>
                    <div class="chart-box doughnut-box">
                        <div class="chart-title">Trạng thái sự kiện</div>
                        <canvas id="eventStatusPie" height="320"></canvas>
                    </div>
                </div>
                <!-- 3 bảng -->
                <div class="tables-row">
                    <div class="table-box">
                        <div style="font-weight:bold;color:#2196f3;margin-bottom:8px;">Người dùng mới</div>
                        <table>
                            <thead>
                                <tr><th>Tên</th><th>Email</th><th>Ngày tạo</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${newUserList}" varStatus="status">
                                    <c:if test="${status.index < 5}">
                                        <tr>
                                            <td>${user.firstName} ${user.lastName}</td>
                                            <td>${user.email}</td>
                                            <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/></td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="table-box">
                        <div style="font-weight:bold;color:#2196f3;margin-bottom:8px;">Lịch mới tạo</div>
                        <table>
                            <thead>
                                <tr><th>Tên lịch</th><th>Người sở hữu</th><th>Ngày tạo</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="calendar" items="${newCalendarList}" varStatus="status">
                                    <c:if test="${status.index < 5}">
                                        <tr>
                                            <td>${calendar.name}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty calendar.idUser and not empty calendar.idUser.username}">
                                                        ${calendar.idUser.username}
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${calendar.createdAt}" pattern="dd/MM/yyyy"/></td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="table-box">
                        <div style="font-weight:bold;color:#2196f3;margin-bottom:8px;">Khóa học mới</div>
                        <table>
                            <thead>
                                <tr><th>Tên khóa học</th><th>Category</th><th>Ngày tạo</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="course" items="${newCourseList}" varStatus="status">
                                    <c:if test="${status.index < 5}">
                                        <tr>
                                            <td>${course.name}</td>
                                            <td>${course.category}</td>
                                            <td><fmt:formatDate value="${course.createdAt}" pattern="dd/MM/yyyy"/></td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="footer">2025 © JiKan</div>
            </div>
            <!-- Chart.js scripts giữ nguyên như cũ -->
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

                // Grouped Bar Chart - Thống kê theo tháng
                new Chart(document.getElementById('groupedBarChart'), {
                    type: 'bar',
                    data: {
                        labels: <c:out value="${requestScope.groupedLabels != null ? requestScope.groupedLabels : '[]'}" escapeXml="false"/>,
                        datasets: [
                            {
                                label: 'Người dùng',
                                data: <c:out value="${requestScope.userCountsByTime != null ? requestScope.userCountsByTime : '[]'}" escapeXml="false"/>,
                                backgroundColor: '#4fc3f7'
                            },
                            {
                                label: 'Lịch',
                                data: <c:out value="${requestScope.calendarCountsByTime != null ? requestScope.calendarCountsByTime : '[]'}" escapeXml="false"/>,
                                backgroundColor: '#43a047'
                            },
                            {
                                label: 'Khóa học',
                                data: <c:out value="${requestScope.courseCountsByTime != null ? requestScope.courseCountsByTime : '[]'}" escapeXml="false"/>,
                                backgroundColor: '#ffb300'
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {position: 'top'},
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        return context.dataset.label + ': ' + context.parsed.y;
                                    }
                                }
                            }
                        },
                        scales: {
                            x: {
                                stacked: false,
                                grid: {display: false},
                                ticks: {color: '#666', font: {size: 12}}
                            },
                            y: {
                                beginAtZero: true,
                                grid: {color: 'rgba(0,0,0,0.08)'},
                                ticks: {color: '#666', font: {size: 12}}
                            }
                        },
                        animation: {
                            duration: 1500,
                            easing: 'easeInOutQuart'
                        }
                    }
                });

                // Trạng thái sự kiện (Doughnut Chart) - Dữ liệu động từ backend
                new Chart(document.getElementById('eventStatusPie'), {
                    type: 'doughnut',
                    data: {
                        labels: <c:out value="${requestScope.eventStatusLabels != null ? requestScope.eventStatusLabels : '[]'}" escapeXml="false"/>,
                        datasets: [{
                                data: <c:out value="${requestScope.eventStatusData != null ? requestScope.eventStatusData : '[]'}" escapeXml="false"/>,
                                backgroundColor: ['#4caf50', '#ffb300', '#e0e0e0']
                            }]
                    },
                    options: {
                        plugins: {legend: {display: true, position: 'bottom'}},
                        cutout: '70%'
                    }
                });

                // Toggle sidebar/menu
                const sidebar = document.getElementById('sidebar');
                const headerNav = document.getElementById('headerNav');
                const toggleBtn = document.getElementById('toggleSidebarBtn');
                const mainContent = document.getElementById('mainContent');
                let menuVisible = false;
                toggleBtn.onclick = function () {
                    menuVisible = !menuVisible;
                    if (menuVisible) {
                        if (sidebar)
                            sidebar.style.display = 'none';
                        if (headerNav)
                            headerNav.style.display = 'flex';
                        if (mainContent)
                            mainContent.style.marginLeft = '0';
                    } else {
                        if (sidebar)
                            sidebar.style.display = '';
                        if (headerNav)
                            headerNav.style.display = 'none';
                        if (window.innerWidth > 900 && mainContent)
                            mainContent.style.marginLeft = '250px';
                    }
                };
                // Đảm bảo khi resize về desktop thì sidebar hiện lại
                window.addEventListener('resize', function () {
                    if (window.innerWidth > 900) {
                        if (sidebar)
                            sidebar.style.display = '';
                        if (headerNav)
                            headerNav.style.display = 'none';
                        if (mainContent)
                            mainContent.style.marginLeft = '250px';
                        menuVisible = false;
                    } else {
                        if (!menuVisible && mainContent)
                            mainContent.style.marginLeft = '0';
                    }
                });
            </script>
        </div>
    </body>
</html> 