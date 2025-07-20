<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doanh Thu - Admin Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        
        .content {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .page-title {
            font-size: 28px;
            font-weight: 600;
            color: #333;
        }
        
        .filter-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        
        .filter-form {
            display: flex;
            gap: 20px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .form-group label {
            font-weight: 500;
            color: #555;
            font-size: 14px;
        }
        
        .form-control {
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            min-width: 150px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            transform: rotate(45deg);
        }
        
        .stat-card h3 {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        
        .stat-card p {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .stat-card i {
            position: absolute;
            top: 20px;
            right: 20px;
            font-size: 24px;
            opacity: 0.3;
        }
        
        .charts-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .chart-container {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: 400px;
            display: flex;
            flex-direction: column;
        }
        
        .chart-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
            flex-shrink: 0;
        }
        
        .chart-canvas {
            width: 100% !important;
            height: 100% !important;
            flex: 1;
            min-height: 0;
        }
        
        .table-container {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .table-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #555;
            border-bottom: 1px solid #dee2e6;
        }
        
        .table td {
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .table tr:hover {
            background: #f8f9fa;
        }
        
        .revenue-amount {
            color: #28a745;
            font-weight: 600;
        }
        
        .percentage {
            color: #007bff;
            font-weight: 500;
        }
        
        @media (max-width: 1200px) {
            .charts-grid {
                grid-template-columns: 1fr;
            }
            .chart-container {
                height: 350px;
            }
        }
        
        @media (max-width: 800px) {
            .sidebar {
                width: 100px;
            }
            .main {
                margin-left: 100px;
            }
            .filter-form {
                flex-direction: column;
                align-items: stretch;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <style>
        body.sidebar-collapsed .sidebar {
            width: 0 !important;
            padding: 0 !important;
            overflow: hidden !important;
            opacity: 0;
            transition: all 0.3s;
        }
        body.sidebar-collapsed .main {
            margin-left: 0 !important;
            transition: all 0.3s;
        }
    </style>
</head>
<body>
    <div class="sidebar" id="sidebar">
        <h2>JiKan</h2>
        <img src="https://randomuser.me/api/portraits/men/32.jpg" class="avatar" alt="avatar"/>
        <div class="admin-name">Welcome, Admin</div>
        <div class="nav">
            <a href="${pageContext.request.contextPath}/admin"><i class="fa fa-home"></i> Trang chủ</a>
            <a href="${pageContext.request.contextPath}/admin/users"><i class="fa fa-users"></i> Người dùng</a>
            <a href="${pageContext.request.contextPath}/admin/courses"><i class="fa fa-book"></i> Khóa học</a>
            <a href="${pageContext.request.contextPath}/admin/orders"><i class="fa fa-shopping-cart"></i> Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/admin/revenue" class="active"><i class="fa fa-chart-line"></i> Doanh thu</a>
        </div>
    </div>
    
    <div class="main">
        <div class="header">
            <button class="toggle-sidebar-btn" id="toggleSidebarBtn" title="Ẩn/hiện menu">
                <i class="fa fa-bars"></i>
            </button>
            <div class="user-info">
                <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="avatar"/>
                <span>Admin</span>
            </div>
        </div>
        
        <div class="content">
            <div class="page-header">
                <h1 class="page-title">Báo Cáo Doanh Thu</h1>
            </div>
            
            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <i class="fa fa-dollar-sign"></i>
                    <h3><fmt:formatNumber value="${revenueData.totalRevenue}" pattern="#,###.00 VND"/></h3>
                    <p>Tổng doanh thu</p>
                </div>
                <div class="stat-card">
                    <i class="fa fa-shopping-cart"></i>
                    <h3>${revenueData.totalOrders}</h3>
                    <p>Tổng đơn hàng</p>
                </div>
                <div class="stat-card">
                    <i class="fa fa-check-circle"></i>
                    <h3>${revenueData.completedOrders}</h3>
                    <p>Đơn hàng hoàn thành</p>
                </div>
                <div class="stat-card">
                    <i class="fa fa-percentage"></i>
                    <h3><fmt:formatNumber value="${revenueData.completionRate}" pattern="#.##"/>%</h3>
                    <p>Tỷ lệ hoàn thành</p>
                </div>
            </div>
            
            <!-- Charts -->
            <div class="charts-grid">
                <div class="chart-container">
                    <h3 class="chart-title">Doanh Thu Theo Thời Gian</h3>
                    <c:if test="${empty revenueData.revenueByTime}">
                        <div style="text-align: center; padding: 40px; color: #666;">
                            <i class="fa fa-chart-line" style="font-size: 48px; margin-bottom: 20px; opacity: 0.3;"></i>
                            <p>Không có dữ liệu doanh thu cho khoảng thời gian này</p>
                        </div>
                    </c:if>
                    <canvas id="revenueTimeChart" class="chart-canvas"></canvas>
                </div>
                <div class="chart-container">
                    <h3 class="chart-title">Doanh Thu Theo Phương Thức Thanh Toán</h3>
                    <c:if test="${empty revenueData.revenueByPaymentMethod}">
                        <div style="text-align: center; padding: 40px; color: #666;">
                            <i class="fa fa-credit-card" style="font-size: 48px; margin-bottom: 20px; opacity: 0.3;"></i>
                            <p>Không có dữ liệu thanh toán</p>
                        </div>
                    </c:if>
                    <canvas id="revenuePaymentChart" class="chart-canvas"></canvas>
                </div>
            </div>
            
            <!-- Tables -->
            <div class="table-container">
                <h3 class="table-title">Top 10 Khóa Học Có Doanh Thu Cao Nhất</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Khóa học</th>
                            <th>Doanh thu</th>
                            <th>Tỷ lệ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${revenueData.revenueByCourse}">
                            <tr>
                                <td>${entry.key}</td>
                                <td class="revenue-amount">
                                    <fmt:formatNumber value="${entry.value}" pattern="#,###.00 VND"/>
                                </td>
                                <td class="percentage">
                                    <fmt:formatNumber value="${entry.value / revenueData.totalRevenue * 100}" pattern="#.##"/>%
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        // Toggle sidebar
        document.getElementById('toggleSidebarBtn').onclick = function() {
            document.body.classList.toggle('sidebar-collapsed');
        };

        // Chart data
        const revenueTimeData = {
            labels: [<c:forEach var="entry" items="${revenueData.revenueByTime}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">, </c:if></c:forEach>],
            datasets: [{
                label: 'Doanh thu',
                data: [<c:forEach var="entry" items="${revenueData.revenueByTime}" varStatus="status">${entry.value}<c:if test="${!status.last}">, </c:if></c:forEach>],
                backgroundColor: 'rgba(102, 126, 234, 0.2)',
                borderColor: 'rgba(102, 126, 234, 1)',
                borderWidth: 2,
                tension: 0.4,
                fill: true
            }]
        };





        const revenuePaymentData = {
            labels: [<c:forEach var="entry" items="${revenueData.revenueByPaymentMethod}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">, </c:if></c:forEach>],
            datasets: [{
                label: 'Doanh thu',
                data: [<c:forEach var="entry" items="${revenueData.revenueByPaymentMethod}" varStatus="status">${entry.value}<c:if test="${!status.last}">, </c:if></c:forEach>],
                backgroundColor: [
                    'rgba(255, 99, 132, 0.8)',
                    'rgba(54, 162, 235, 0.8)',
                    'rgba(255, 206, 86, 0.8)',
                    'rgba(75, 192, 192, 0.8)'
                ],
                borderWidth: 1
            }]
        };



        // Create charts
        const revenueTimeChart = new Chart(
            document.getElementById('revenueTimeChart'),
            {
                type: 'line',
                data: revenueTimeData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    aspectRatio: 2,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        x: {
                            ticks: {
                                maxRotation: 45,
                                minRotation: 45,
                                maxTicksLimit: 12
                            }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return new Intl.NumberFormat('vi-VN', {
                                        style: 'currency',
                                        currency: 'VND'
                                    }).format(value);
                                }
                            }
                        }
                    },
                    elements: {
                        point: {
                            radius: 4,
                            hoverRadius: 6
                        }
                    }
                }
            }
        );

        const revenuePaymentChart = new Chart(
            document.getElementById('revenuePaymentChart'),
            {
                type: 'doughnut',
                data: revenuePaymentData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    aspectRatio: 1.5,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            }
        );
    </script>
</body>
</html> 