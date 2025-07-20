<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đơn hàng - Admin Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
        
        .search-form button,
        .search-form a.btn-secondary {
            height: 40px;
            padding-top: 0;
            padding-bottom: 0;
            font-size: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
        }
        
        .btn-edit {
            background: #28a745;
            color: white;
        }
        
        .btn-edit:hover {
            background: #218838;
        }
        
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        
        .btn-delete:hover {
            background: #c82333;
        }
        
        .search-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        
        .search-form {
            display: flex;
            gap: 24px;
            align-items: flex-end;
            flex-wrap: wrap;
            width: 100%;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            min-width: 220px;
            min-height: 70px;
            justify-content: flex-end;
        }
        
        .form-group:last-child {
            min-width: 180px;
            display: flex;
            flex-direction: row;
            gap: 10px;
            align-items: flex-end;
            height: 40px;
        }
        
        .form-group label {
            font-weight: 500;
            color: #555;
            font-size: 14px;
        }
        
        .form-control {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            min-width: 200px;
            height: 40px;
        }
        
        .orders-table {
            margin-bottom: 30px;
        }
        
        .table-header {
            margin-bottom: 20px;
        }
        
        .table-title {
            font-size: 20px;
            font-weight: 600;
            color: #333;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
            vertical-align: middle;
        }
        
        .table tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-processing {
            background: #cce5ff;
            color: #004085;
        }
        
        .status-shipped {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-delivered {
            background: #d4edda;
            color: #155724;
        }
        
        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-top: 24px;
        }
        
        .page-link {
            padding: 8px 12px;
            border: 1px solid #e0e0e0;
            background: white;
            color: #333;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        
        .page-link:hover, .page-link.active {
            background: #4fc3f7;
            color: white;
            border-color: #4fc3f7;
        }
        
        .pagination-info {
            background: #f8f9fa;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            margin: 20px 0;
            text-align: center;
            color: #666;
        }
        
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 0;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .modal-header {
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-header h2 {
            margin: 0;
            color: #333;
        }
        
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #000;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .modal-footer {
            padding: 20px;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        
        /* Notification styles */
        .notification {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideInDown 0.5s ease-out;
            position: relative;
        }
        
        .notification.success {
            background: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
        }
        
        .notification.error {
            background: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
        }
        
        .notification .close-notification {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            opacity: 0.7;
        }
        
        .notification .close-notification:hover {
            opacity: 1;
        }
        
        @keyframes slideInDown {
            from {
                transform: translateY(-100%);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        @keyframes fadeOut {
            from {
                opacity: 1;
                transform: translateY(0);
            }
            to {
                opacity: 0;
                transform: translateY(-100%);
            }
        }
        
        /* Responsive styles */
        @media (max-width: 1200px) {
            .search-form {
                flex-direction: column;
                align-items: stretch;
            }
        }
        
        @media (max-width: 800px) {
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
            .page-header {
                flex-direction: column;
                gap: 16px;
                align-items: stretch;
            }
            .table {
                font-size: 14px;
            }
            .table th, .table td {
                padding: 12px 8px;
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
            <a href="${pageContext.request.contextPath}/admin/orders" class="active"><i class="fa fa-shopping-cart"></i> Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/admin/revenue"><i class="fa fa-chart-line"></i> Doanh thu</a>
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
            <!-- Hiển thị thông báo -->
            <c:if test="${not empty message}">
                <div id="successNotification" class="notification success">
                    <i class="fa fa-check-circle"></i>
                    <span>${message}</span>
                    <button class="close-notification" onclick="closeNotification('successNotification')">&times;</button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div id="errorNotification" class="notification error">
                    <i class="fa fa-exclamation-circle"></i>
                    <span>${error}</span>
                    <button class="close-notification" onclick="closeNotification('errorNotification')">&times;</button>
                </div>
            </c:if>
            
            <div class="page-header">
                <h1 class="page-title">Quản lý Đơn hàng</h1>
            </div>
            
            <div class="search-box">
                <form class="search-form" method="GET" action="${pageContext.request.contextPath}/admin/orders">
                    <div class="form-group">
                        <label for="searchStatus">Trạng thái</label>
                        <select id="searchStatus" name="searchStatus" class="form-control">
                            <option value="">Tất cả trạng thái</option>
                            <option value="Processing" ${searchStatus == 'Processing' ? 'selected' : ''}>Đang xử lý</option>
                            <option value="Completed" ${searchStatus == 'Completed' ? 'selected' : ''}>Đã hoàn thành</option>
                            <option value="Failed" ${searchStatus == 'Failed' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="searchPaymentMethod">Phương thức thanh toán</label>
                        <select id="searchPaymentMethod" name="searchPaymentMethod" class="form-control">
                            <option value="">Tất cả phương thức</option>
                            <option value="Bank Transfer" ${searchPaymentMethod == 'Bank Transfer' ? 'selected' : ''}>Chuyển khoản</option>
                            <option value="Credit Card" ${searchPaymentMethod == 'Credit Card' ? 'selected' : ''}>Thẻ tín dụng</option>
                            <option value="PayPal" ${searchPaymentMethod == 'PayPal' ? 'selected' : ''}>Ví điện tử</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="searchDateFrom">Từ ngày</label>
                        <input type="date" id="searchDateFrom" name="searchDateFrom" class="form-control" value="${searchDateFrom}">
                    </div>
                    <div class="form-group">
                        <label for="searchDateTo">Đến ngày</label>
                        <input type="date" id="searchDateTo" name="searchDateTo" class="form-control" value="${searchDateTo}">
                    </div>
                    <div class="form-group">
                        <label>&nbsp;</label>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-search"></i>
                            Tìm kiếm
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary">
                            <i class="fa fa-refresh"></i>
                            Làm mới
                        </a>
                    </div>
                </form>
            </div>
            
            <div class="orders-table">
                <div class="table-header">
                    <h3 class="table-title">Danh sách đơn hàng</h3>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Mã đơn hàng</th>
                            <th>Khách hàng</th>
                            <th>Tổng tiền</th>
                            <th>Phương thức thanh toán</th>
                            <th>Thời gian thanh toán</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orderList}">
                            <tr>
                                <td>
                                    <strong>#${order.idOrder}</strong>
                                </td>
                                <td>
                                    <div>
                                        <strong>${order.idUser.firstName} ${order.idUser.lastName}</strong>
                                        <br><small style="color: #666;">${order.idUser.email}</small>
                                    </div>
                                </td>
                                <td>
                                    <span style="color: #dc3545; font-weight: bold;">
                                        <fmt:formatNumber value="${order.totalAmount}" pattern="#,###.00 VND"/>
                                    </span>
                                </td>
                                <td>${order.paymentMethod}</td>
                                <td><fmt:formatDate value="${order.paymentTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 'Processing'}">
                                            <span class="status-badge status-processing">Đang xử lý</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Completed'}">
                                            <span class="status-badge status-delivered">Đã hoàn thành</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Failed'}">
                                            <span class="status-badge status-cancelled">Đã hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-pending">Chưa xác định</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-sm btn-edit" onclick="editOrderStatus(${order.idOrder})">
                                            <i class="fa fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-delete" onclick="deleteOrder(${order.idOrder})">
                                            <i class="fa fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <!-- Hiển thị thông báo nếu không có dữ liệu -->
                        <c:if test="${empty orderList}">
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 40px; color: #666;">
                                    <i class="fa fa-shopping-cart" style="font-size: 48px; margin-bottom: 16px; display: block; color: #ccc;"></i>
                                    Không có đơn hàng nào
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <!-- Thông tin pagination -->
            <c:if test="${totalOrders > 0}">
                <div class="pagination-info">
                    Hiển thị ${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalOrders ? totalOrders : currentPage * pageSize} 
                    trong tổng số ${totalOrders} đơn hàng
                </div>
            </c:if>
            
            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <!-- Nút Previous -->
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/admin/orders?page=${currentPage - 1}&searchStatus=${searchStatus}&searchPaymentMethod=${searchPaymentMethod}&searchDateFrom=${searchDateFrom}&searchDateTo=${searchDateTo}" 
                           class="page-link">
                            <i class="fa fa-chevron-left"></i> Trước
                        </a>
                    </c:if>
                    
                    <!-- Các trang -->
                    <c:choose>
                        <c:when test="${totalPages <= 7}">
                            <!-- Hiển thị tất cả trang nếu <= 7 -->
                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                <a href="${pageContext.request.contextPath}/admin/orders?page=${pageNum}&searchStatus=${searchStatus}&searchPaymentMethod=${searchPaymentMethod}&searchDateFrom=${searchDateFrom}&searchDateTo=${searchDateTo}" 
                                   class="page-link ${pageNum == currentPage ? 'active' : ''}">
                                    ${pageNum}
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- Hiển thị trang đầu -->
                            <a href="${pageContext.request.contextPath}/admin/orders?page=1&searchStatus=${searchStatus}&searchPaymentMethod=${searchPaymentMethod}&searchDateFrom=${searchDateFrom}&searchDateTo=${searchDateTo}" 
                               class="page-link ${currentPage == 1 ? 'active' : ''}">
                                1
                            </a>
                            
                            <!-- Dấu ... nếu cần -->
                            <c:if test="${currentPage > 4}">
                                <span class="page-ellipsis">...</span>
                            </c:if>
                            
                            <!-- Các trang xung quanh trang hiện tại -->
                            <c:forEach begin="${currentPage > 3 ? currentPage - 1 : 2}" 
                                       end="${currentPage < totalPages - 2 ? currentPage + 1 : totalPages - 1}" 
                                       var="pageNum">
                                <a href="${pageContext.request.contextPath}/admin/orders?page=${pageNum}&searchStatus=${searchStatus}&searchPaymentMethod=${searchPaymentMethod}&searchDateFrom=${searchDateFrom}&searchDateTo=${searchDateTo}" 
                                   class="page-link ${pageNum == currentPage ? 'active' : ''}">
                                    ${pageNum}
                                </a>
                            </c:forEach>
                            
                            <!-- Dấu ... nếu cần -->
                            <c:if test="${currentPage < totalPages - 3}">
                                <span class="page-ellipsis">...</span>
                            </c:if>
                            
                            <!-- Hiển thị trang cuối -->
                            <a href="${pageContext.request.contextPath}/admin/orders?page=${totalPages}&searchStatus=${searchStatus}&searchPaymentMethod=${searchPaymentMethod}&searchDateFrom=${searchDateFrom}&searchDateTo=${searchDateTo}" 
                               class="page-link ${currentPage == totalPages ? 'active' : ''}">
                                ${totalPages}
                            </a>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Nút Next -->
                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/admin/orders?page=${currentPage + 1}&searchStatus=${searchStatus}&searchPaymentMethod=${searchPaymentMethod}&searchDateFrom=${searchDateFrom}&searchDateTo=${searchDateTo}" 
                           class="page-link">
                            Sau <i class="fa fa-chevron-right"></i>
                        </a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Modal Edit Order Status -->
    <div id="editOrderModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Cập nhật trạng thái đơn hàng</h2>
                <span class="close" onclick="closeEditModal()">&times;</span>
            </div>
            <form id="editOrderForm" method="POST" action="${pageContext.request.contextPath}/admin/orders">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="orderId" id="editOrderId">
                
                <div class="modal-body">
                    <div class="form-group">
                        <label for="editStatus">Trạng thái mới:</label>
                        <select id="editStatus" name="status" class="form-control" required>
                            <option value="">Chọn trạng thái</option>
                            <option value="Processing">Đang xử lý</option>
                            <option value="Completed">Đã hoàn thành</option>
                            <option value="Failed">Đã hủy</option>
                        </select>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Hủy</button>
                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Toggle sidebar
        document.getElementById('toggleSidebarBtn').onclick = function() {
            document.body.classList.toggle('sidebar-collapsed');
        };

        // Order management functions
        function editOrderStatus(orderId) {
            // Sử dụng AJAX để lấy thông tin order chi tiết
            fetch('${pageContext.request.contextPath}/admin/orders?action=getOrder&orderId=' + orderId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(order => {
                    // Điền thông tin vào modal
                    document.getElementById('editOrderId').value = order.id;
                    document.getElementById('editStatus').value = order.status || '';
                    
                    // Hiển thị modal
                    document.getElementById('editOrderModal').style.display = 'block';
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi tải thông tin đơn hàng');
                });
        }
        
        function closeEditModal() {
            document.getElementById('editOrderModal').style.display = 'none';
        }
        
        function deleteOrder(orderId) {
            if (confirm('Bạn có chắc chắn muốn xóa đơn hàng này?')) {
                // Tạo form ẩn để gửi request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/orders';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const orderIdInput = document.createElement('input');
                orderIdInput.type = 'hidden';
                orderIdInput.name = 'orderId';
                orderIdInput.value = orderId;
                
                form.appendChild(actionInput);
                form.appendChild(orderIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Đóng modal khi click bên ngoài
        window.onclick = function(event) {
            const editModal = document.getElementById('editOrderModal');
            if (event.target === editModal) {
                editModal.style.display = 'none';
            }
        }
        
        // Xử lý thông báo
        function closeNotification(notificationId) {
            const notification = document.getElementById(notificationId);
            if (notification) {
                notification.style.animation = 'fadeOut 0.5s ease-out';
                setTimeout(() => {
                    notification.remove();
                }, 500);
            }
        }
        
        // Auto-hide thông báo thành công sau 5 giây
        document.addEventListener('DOMContentLoaded', function() {
            const successNotification = document.getElementById('successNotification');
            if (successNotification) {
                setTimeout(() => {
                    closeNotification('successNotification');
                }, 5000);
            }
        });
    </script>
</body>
</html>

 