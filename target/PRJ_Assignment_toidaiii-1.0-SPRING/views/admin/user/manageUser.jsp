<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Người dùng - JiKan Calendar</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
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

            .users-table {
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

            .status-active {
                background: #e8f5e8;
                color: #2e7d32;
            }

            .status-inactive {
                background: #ffebee;
                color: #c62828;
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

            .page-ellipsis {
                display: inline-block;
                padding: 8px 12px;
                margin: 0 4px;
                color: #666;
            }

            .pagination-info {
                background: #f8f9fa;
                padding: 12px;
                border-radius: 8px;
                border: 1px solid #e9ecef;
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

            .modal form {
                padding: 20px;
            }

            .modal-body {
                padding: 20px;
                max-height: 400px;
                overflow-y: auto;
            }

            .modal-footer {
                padding: 20px;
                border-top: 1px solid #e9ecef;
                display: flex;
                justify-content: flex-end;
                gap: 10px;
            }

            /* Avatar styles */
            .user-avatar {
                display: flex;
                justify-content: center;
            }

            .avatar-img {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
                border: 2px solid #e9ecef;
            }

            /* History buttons styles */
            .history-buttons {
                display: flex;
                justify-content: center;
            }

            .btn-history {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 8px 12px;
                border-radius: 20px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 5px;
                font-size: 12px;
                min-width: 80px;
                justify-content: center;
            }

            .btn-history:hover {
                background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }

            .history-count {
                background: rgba(255,255,255,0.2);
                border-radius: 10px;
                padding: 2px 6px;
                font-size: 10px;
                font-weight: bold;
            }
            .sidebar-collapsed .sidebar {
                width: 0;
                padding: 0;
                overflow: hidden;
            }
            .sidebar-collapsed .main {
                margin-left: 0;
            }
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
    </head>
    <body>
        <div class="sidebar">
            <h2>JiKan</h2>
            <img src="https://randomuser.me/api/portraits/men/32.jpg" class="avatar" alt="avatar"/>
            <div class="admin-name">Welcome, Admin</div>
            <div class="nav">
                <a href="${pageContext.request.contextPath}/admin"><i class="fa fa-home"></i> Trang chủ</a>
                <a href="${pageContext.request.contextPath}/admin/users" class="active"><i class="fa fa-users"></i> Người dùng</a>
                <a href="${pageContext.request.contextPath}/admin/courses"><i class="fa fa-book"></i> Khóa học</a>
                <a href="${pageContext.request.contextPath}/admin/orders"><i class="fa fa-shopping-cart"></i> Đơn hàng</a>
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
                    <div style="background: #d4edda; color: #155724; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
                        <i class="fa fa-check-circle"></i> ${message}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
                        <i class="fa fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <c:if test="${not empty message}">
                    <div style="background: #d4edda; color: #155724; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
                        <i class="fa fa-check-circle"></i> ${message}
                    </div>
                </c:if>

                <div class="page-header">
                    <h1 class="page-title">Quản lý Người dùng</h1>
                    <a href="#" class="btn btn-primary" onclick="openAddUserModal()">
                        <i class="fa fa-plus"></i>
                        Thêm người dùng
                    </a>
                </div>

                <div class="search-box">
                    <form class="search-form" method="GET" action="${pageContext.request.contextPath}/admin/users">
                        <div class="form-group">
                            <label for="searchName">Tìm theo tên</label>
                            <input type="text" id="searchName" name="searchName" class="form-control" 
                                   placeholder="Nhập tên người dùng..." value="${searchName}">
                        </div>
                        <div class="form-group">
                            <label for="searchEmail">Tìm theo email</label>
                            <input type="email" id="searchEmail" name="searchEmail" class="form-control" 
                                   placeholder="Nhập email..." value="${searchEmail}">
                        </div>
                        <div class="form-group">
                            <label for="searchStatus">Trạng thái</label>
                            <select id="searchStatus" name="searchStatus" class="form-control">
                                <option value="">Tất cả</option>
                                <option value="active" ${searchStatus == 'active' ? 'selected' : ''}>Hoạt động</option>
                                <option value="inactive" ${searchStatus == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <button type="submit" class="btn btn-primary">
                                <i class="fa fa-search"></i>
                                Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary" style="margin-left: 10px;">
                                <i class="fa fa-refresh"></i>
                                Làm mới
                            </a>
                        </div>
                    </form>
                </div>

                <div class="users-table">
                    <div class="table-header">
                        <h3 class="table-title">Danh sách người dùng</h3>
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Avatar</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Lịch sử đăng ký khóa học</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${userList}">
                                <tr>
                                    <td>
                                        <div class="user-avatar">
                                            <c:choose>
                                                <c:when test="${not empty user.avatar}">
                                                    <img src="${user.avatar}" alt="Avatar" class="avatar-img">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://randomuser.me/api/portraits/${user.gender == 'female' ? 'women' : 'men'}/${user.idUser % 70}.jpg" 
                                                         alt="Avatar" class="avatar-img">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td>${user.firstName} ${user.lastName}</td>
                                    <td>${user.email}</td>
                                    <td>${user.isAdmin ? 'Admin' : 'User'}</td>
                                    <td>
                                        <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'}">
                                            ${user.active ? 'Hoạt động' : 'Không hoạt động'}
                                        </span>
                                    </td>
                                    <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <div class="history-buttons">
                                            <button class="btn btn-sm btn-history" onclick="viewCourseHistory(${user.idUser})" title="Xem lịch sử đăng ký khóa học">
                                                <i class="fa fa-graduation-cap"></i>
                                                <span class="history-count">0</span>
                                            </button>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn btn-sm btn-edit" onclick="editUser(${user.idUser})">
                                                <i class="fa fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-delete" onclick="deleteUser(${user.idUser})">
                                                <i class="fa fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <!-- Hiển thị thông báo nếu không có dữ liệu -->
                            <c:if test="${empty userList}">
                                <tr>
                                    <td colspan="9" style="text-align: center; padding: 40px; color: #666;">
                                        <i class="fa fa-users" style="font-size: 48px; margin-bottom: 16px; display: block; color: #ccc;"></i>
                                        Không có người dùng nào
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Thông tin pagination -->
                <c:if test="${totalUsers > 0}">
                    <div class="pagination-info" style="margin: 20px 0; text-align: center; color: #666;">
                        Hiển thị ${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalUsers ? totalUsers : currentPage * pageSize} 
                        trong tổng số ${totalUsers} người dùng
                    </div>
                </c:if>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <!-- Nút Previous -->
                        <c:if test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&searchName=${searchName}&searchEmail=${searchEmail}&searchStatus=${searchStatus}" 
                               class="page-link">
                                <i class="fa fa-chevron-left"></i> Trước
                            </a>
                        </c:if>

                        <!-- Các trang -->
                        <c:choose>
                            <c:when test="${totalPages <= 7}">
                                <!-- Hiển thị tất cả trang nếu <= 7 -->
                                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                    <a href="${pageContext.request.contextPath}/admin/users?page=${pageNum}&searchName=${searchName}&searchEmail=${searchEmail}&searchStatus=${searchStatus}" 
                                       class="page-link ${pageNum == currentPage ? 'active' : ''}">
                                        ${pageNum}
                                    </a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- Hiển thị trang đầu -->
                                <a href="${pageContext.request.contextPath}/admin/users?page=1&searchName=${searchName}&searchEmail=${searchEmail}&searchStatus=${searchStatus}" 
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
                                    <a href="${pageContext.request.contextPath}/admin/users?page=${pageNum}&searchName=${searchName}&searchEmail=${searchEmail}&searchStatus=${searchStatus}" 
                                       class="page-link ${pageNum == currentPage ? 'active' : ''}">
                                        ${pageNum}
                                    </a>
                                </c:forEach>

                                <!-- Dấu ... nếu cần -->
                                <c:if test="${currentPage < totalPages - 3}">
                                    <span class="page-ellipsis">...</span>
                                </c:if>

                                <!-- Hiển thị trang cuối -->
                                <a href="${pageContext.request.contextPath}/admin/users?page=${totalPages}&searchName=${searchName}&searchEmail=${searchEmail}&searchStatus=${searchStatus}" 
                                   class="page-link ${currentPage == totalPages ? 'active' : ''}">
                                    ${totalPages}
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <!-- Nút Next -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&searchName=${searchName}&searchEmail=${searchEmail}&searchStatus=${searchStatus}" 
                               class="page-link">
                                Sau <i class="fa fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Modal Add User -->
        <div id="addUserModal" class="modal" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Thêm người dùng mới</h2>
                    <span class="close" onclick="closeAddModal()">&times;</span>
                </div>
                <form id="addUserForm" method="POST" action="${pageContext.request.contextPath}/admin/users">
                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label for="addUsername">Tên đăng nhập:</label>
                        <input type="text" id="addUsername" name="username" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="addFirstName">Họ:</label>
                        <input type="text" id="addFirstName" name="firstName" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="addLastName">Tên:</label>
                        <input type="text" id="addLastName" name="lastName" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="addEmail">Email:</label>
                        <input type="email" id="addEmail" name="email" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="addPassword">Mật khẩu:</label>
                        <input type="password" id="addPassword" name="password" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="addBirthday">Ngày sinh:</label>
                        <input type="date" id="addBirthday" name="birthday" class="form-control">
                    </div>

                    <div class="form-group">
                        <label for="addPhone">Số điện thoại:</label>
                        <input type="text" id="addPhone" name="phone" class="form-control">
                    </div>

                    <div class="form-group">
                        <label for="addGender">Giới tính:</label>
                        <select id="addGender" name="gender" class="form-control">
                            <option value="">Chọn giới tính</option>
                            <option value="male">Nam</option>
                            <option value="female">Nữ</option>
                            <option value="other">Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="addAvatar">Avatar URL:</label>
                        <input type="url" id="addAvatar" name="avatar" class="form-control" 
                               placeholder="https://example.com/avatar.jpg">
                        <small class="form-text text-muted">Để trống để sử dụng avatar mặc định</small>
                    </div>

                    <div class="form-group">
                        <label for="addActive">Trạng thái:</label>
                        <select id="addActive" name="active" class="form-control">
                            <option value="true" selected>Hoạt động</option>
                            <option value="false">Không hoạt động</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="addIsAdmin">Vai trò:</label>
                        <select id="addIsAdmin" name="isAdmin" class="form-control">
                            <option value="false" selected>User</option>
                            <option value="true">Admin</option>
                        </select>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeAddModal()">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm người dùng</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal Edit User -->
        <div id="editUserModal" class="modal" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Chỉnh sửa người dùng</h2>
                    <span class="close" onclick="closeEditModal()">&times;</span>
                </div>
                <form id="editUserForm" method="POST" action="${pageContext.request.contextPath}/admin/users">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="userId" id="editUserId">

                    <div class="form-group">
                        <label for="editFirstName">Họ:</label>
                        <input type="text" id="editFirstName" name="firstName" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="editLastName">Tên:</label>
                        <input type="text" id="editLastName" name="lastName" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="editEmail">Email:</label>
                        <input type="email" id="editEmail" name="email" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="editAvatar">Avatar URL:</label>
                        <input type="url" id="editAvatar" name="avatar" class="form-control" 
                               placeholder="https://example.com/avatar.jpg">
                        <small class="form-text text-muted">Để trống để sử dụng avatar mặc định</small>
                    </div>

                    <div class="form-group">
                        <label for="editPhone">Số điện thoại:</label>
                        <input type="text" id="editPhone" name="phone" class="form-control">
                    </div>

                    <div class="form-group">
                        <label for="editGender">Giới tính:</label>
                        <select id="editGender" name="gender" class="form-control">
                            <option value="">Chọn giới tính</option>
                            <option value="male">Nam</option>
                            <option value="female">Nữ</option>
                            <option value="other">Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="editActive">Trạng thái:</label>
                        <select id="editActive" name="active" class="form-control">
                            <option value="true" ${user.active ? 'selected' : ''}>Hoạt động</option>
                            <option value="false" ${!user.active ? 'selected' : ''}>Không hoạt động</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="editIsAdmin">Vai trò:</label>
                        <select id="editIsAdmin" name="isAdmin" class="form-control">
                            <option value="false" ${!user.isAdmin ? 'selected' : ''}>User</option>
                            <option value="true" ${user.isAdmin ? 'selected' : ''}>Admin</option>
                        </select>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Hủy</button>
                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal Course History -->
        <div id="courseHistoryModal" class="modal" style="display: none;">
            <div class="modal-content" style="max-width: 800px;">
                <div class="modal-header">
                    <h2>Lịch sử đăng ký khóa học</h2>
                    <span class="close" onclick="closeCourseHistoryModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <div id="courseHistoryContent">
                        <div style="text-align: center; padding: 40px; color: #666;">
                            <i class="fa fa-spinner fa-spin" style="font-size: 24px; margin-bottom: 16px;"></i>
                            <p>Đang tải dữ liệu...</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeCourseHistoryModal()">Đóng</button>
                </div>
            </div>
        </div>

        <script>
            // Toggle sidebar
            document.getElementById('toggleSidebarBtn').onclick = function() {
            document.body.classList.toggle('sidebar-collapsed');
            };
            // Search functionality - Form sẽ tự động submit đến servlet
            // Không cần JavaScript để xử lý search nữa

            // User management functions
            function openAddUserModal() {
            document.getElementById('addUserModal').style.display = 'block';
            }

            function closeAddModal() {
            document.getElementById('addUserModal').style.display = 'none';
            }

            function editUser(userId) {
            // Sử dụng AJAX để lấy thông tin user chi tiết
        fetch('${pageContext.request.contextPath}/admin/users?action=getUser&userId=' + userId)
                    .then(response => {
                    if (!response.ok) {
                    throw new Error('Network response was not ok');
                    }
                    return response.json();
                    })
                    .then(user => {
                    // Điền thông tin vào modal
                    document.getElementById('editUserId').value = user.id;
                    document.getElementById('editFirstName').value = user.firstName || '';
                    document.getElementById('editLastName').value = user.lastName || '';
                    document.getElementById('editEmail').value = user.email || '';
                    document.getElementById('editAvatar').value = user.avatar || '';
                    document.getElementById('editPhone').value = user.phone || '';
                    document.getElementById('editGender').value = user.gender || '';
                    document.getElementById('editActive').value = user.active.toString();
                    document.getElementById('editIsAdmin').value = user.isAdmin.toString();
                    // Hiển thị modal
                    document.getElementById('editUserModal').style.display = 'block';
                    })
                    .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi tải thông tin người dùng');
                    });
            }

            function closeEditModal() {
            document.getElementById('editUserModal').style.display = 'none';
            }

            // Đóng modal khi click bên ngoài
            window.onclick = function(event) {
            const addModal = document.getElementById('addUserModal');
            const editModal = document.getElementById('editUserModal');
            const paymentModal = document.getElementById('paymentHistoryModal');
            const courseModal = document.getElementById('courseHistoryModal');
            if (event.target === addModal) {
            addModal.style.display = 'none';
            }
            if (event.target === editModal) {
            editModal.style.display = 'none';
            }
            if (event.target === paymentModal) {
            paymentModal.style.display = 'none';
            }
            if (event.target === courseModal) {
            courseModal.style.display = 'none';
            }
            }








            // Course History functions
            function viewCourseHistory(userId) {
            userId = userId.toString();
            document.getElementById('courseHistoryModal').style.display = 'block';
            var courses = window.userCoursesMap && window.userCoursesMap[userId] ? window.userCoursesMap[userId] : [];
            if (!courses || courses.length === 0) {
            document.getElementById('courseHistoryContent').innerHTML = `
                        <div style="text-align: center; padding: 40px; color: #666;">
                            <i class="fa fa-graduation-cap" style="font-size: 48px; margin-bottom: 16px; color: #ccc;"></i>
                            <p>Chưa có lịch sử đăng ký khóa học</p>
                        </div>
                    `;
            return;
            }
            let html = `
        <div class="history-table">
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background: #f8f9fa;">
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #dee2e6;">Khóa học</th>
                    </tr>
                </thead>
                <tbody>
    `;
            courses.forEach(function(course) {
            html += `
            <tr>
                <td style="padding: 12px; border-bottom: 1px solid #dee2e6; font-weight: bold;">${course.name}</td>
            </tr>
        `;
            });
            html += `
                </tbody>
            </table>
        </div>
    `;
            document.getElementById('courseHistoryContent').innerHTML = html;
            }

            function closeCourseHistoryModal() {
            document.getElementById('courseHistoryModal').style.display = 'none';
            }

            function deleteUser(userId) {
            if (confirm('Bạn có chắc chắn muốn xóa người dùng này?')) {
            // Tạo form ẩn để gửi request
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/users';
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete';
            const userIdInput = document.createElement('input');
            userIdInput.type = 'hidden';
            userIdInput.name = 'userId';
            userIdInput.value = userId;
            form.appendChild(actionInput);
            form.appendChild(userIdInput);
            document.body.appendChild(form);
            form.submit();
            }
            }
        </script>
        <%-- Truyền dữ liệu userCoursesMap sang JS --%>
        <script>
            window.userCoursesMap = {
            <c:forEach var="user" items="${userList}" varStatus="userStatus">
            "${user.idUser}": [
                <c:forEach var="course" items="${userCoursesMap[user.idUser]}" varStatus="courseStatus">
            {"name": "${course.name}"}<c:if test="${!courseStatus.last}">,</c:if>
                </c:forEach>
            ]<c:if test="${!userStatus.last}">,</c:if>
            </c:forEach>
            };
            console.log('userCoursesMap:', window.userCoursesMap);
        </script>
    </body>
</html>
