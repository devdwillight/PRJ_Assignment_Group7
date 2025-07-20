<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khóa học - Admin Panel</title>
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
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
        
        .courses-table {
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
        
        .course-image {
            width: 60px;
            height: 60px;
            border-radius: 8px;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }
        
        .course-image-container {
            display: flex;
            justify-content: center;
        }
        
        body.sidebar-collapsed .sidebar {
            transform: translateX(-100%);
        }
        
        body.sidebar-collapsed .main {
            margin-left: 0;
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
            max-width: 600px;
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
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>JiKan</h2>
        <img src="https://randomuser.me/api/portraits/men/32.jpg" class="avatar" alt="avatar"/>
        <div class="admin-name">Welcome, Admin</div>
                    <div class="nav">
                <a href="${pageContext.request.contextPath}/admin"><i class="fa fa-home"></i> Trang chủ</a>
                <a href="${pageContext.request.contextPath}/admin/users"><i class="fa fa-users"></i> Người dùng</a>
                <a href="${pageContext.request.contextPath}/admin/courses" class="active"><i class="fa fa-book"></i> Khóa học</a>
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
            
            <div class="page-header">
                <h1 class="page-title">Quản lý Khóa học</h1>
                <a href="#" class="btn btn-primary" onclick="openAddCourseModal()">
                    <i class="fa fa-plus"></i>
                    Thêm khóa học
                </a>
            </div>
            
            <div class="search-box">
                <form class="search-form" method="GET" action="${pageContext.request.contextPath}/admin/courses">
                    <div class="form-group">
                        <label for="searchName">Tìm theo tên</label>
                        <input type="text" id="searchName" name="searchName" class="form-control" 
                               placeholder="Nhập tên khóa học..." value="${searchName}">
                    </div>
                    <div class="form-group">
                        <label for="searchCategory">Danh mục</label>
                        <input type="text" id="searchCategory" name="searchCategory" class="form-control" 
                               placeholder="Nhập danh mục..." value="${searchCategory}">
                    </div>
                    <div class="form-group">
                        <label for="searchPrice">Giá</label>
                        <input type="number" id="searchPrice" name="searchPrice" class="form-control" 
                               placeholder="Nhập giá..." value="${searchPrice}">
                    </div>
                    <div class="form-group">
                        <label>&nbsp;</label>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-search"></i>
                            Tìm kiếm
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-secondary" style="margin-left: 10px;">
                            <i class="fa fa-refresh"></i>
                            Làm mới
                        </a>
                    </div>
                </form>
            </div>
            
            <div class="courses-table">
                <div class="table-header">
                    <h3 class="table-title">Danh sách khóa học</h3>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Hình ảnh</th>
                            <th>Tên khóa học</th>
                            <th>Danh mục</th>
                            <th>Giá</th>
                            <th>Thời lượng</th>
                            <th>Tần suất</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="course" items="${courseList}">
                            <tr>
                                <td>
                                    <div class="course-image-container">
                                        <c:choose>
                                            <c:when test="${not empty course.imageUrl}">
                                                <img src="${course.imageUrl}" alt="Course" class="course-image">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://via.placeholder.com/60x60/4fc3f7/ffffff?text=KH" 
                                                     alt="Course" class="course-image">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <strong>${course.name}</strong>
                                        <c:if test="${not empty course.description}">
                                            <br><small style="color: #666;">${course.description}</small>
                                        </c:if>
                                    </div>
                                </td>
                                <td>${course.category != null ? course.category : 'Chưa phân loại'}</td>
                                <td>
                                    <span style="color: #dc3545; font-weight: bold;">
                                        <fmt:formatNumber value="${course.price}" pattern="#,###.00 $"/>
                                    </span>
                                </td>
                                <td>${course.duration != null ? course.duration : 'N/A'}</td>
                                <td>${course.frequency != null ? course.frequency : 'N/A'}</td>
                                <td><fmt:formatDate value="${course.createdAt}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-sm btn-edit" onclick="editCourse(${course.idCourse})">
                                            <i class="fa fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-delete" onclick="deleteCourse(${course.idCourse})">
                                            <i class="fa fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <!-- Hiển thị thông báo nếu không có dữ liệu -->
                        <c:if test="${empty courseList}">
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 40px; color: #666;">
                                    <i class="fa fa-book" style="font-size: 48px; margin-bottom: 16px; display: block; color: #ccc;"></i>
                                    Không có khóa học nào
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <!-- Thông tin pagination -->
            <c:if test="${totalCourses > 0}">
                <div class="pagination-info" style="margin: 20px 0; text-align: center; color: #666;">
                    Hiển thị ${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalCourses ? totalCourses : currentPage * pageSize} 
                    trong tổng số ${totalCourses} khóa học
                </div>
            </c:if>
            
            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <!-- Nút Previous -->
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/admin/courses?page=${currentPage - 1}&searchName=${searchName}&searchCategory=${searchCategory}&searchPrice=${searchPrice}" 
                           class="page-link">
                            <i class="fa fa-chevron-left"></i> Trước
                        </a>
                    </c:if>
                    
                    <!-- Các trang -->
                    <c:choose>
                        <c:when test="${totalPages <= 7}">
                            <!-- Hiển thị tất cả trang nếu <= 7 -->
                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                <a href="${pageContext.request.contextPath}/admin/courses?page=${pageNum}&searchName=${searchName}&searchCategory=${searchCategory}&searchPrice=${searchPrice}" 
                                   class="page-link ${pageNum == currentPage ? 'active' : ''}">
                                    ${pageNum}
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- Hiển thị trang đầu -->
                            <a href="${pageContext.request.contextPath}/admin/courses?page=1&searchName=${searchName}&searchCategory=${searchCategory}&searchPrice=${searchPrice}" 
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
                                <a href="${pageContext.request.contextPath}/admin/courses?page=${pageNum}&searchName=${searchName}&searchCategory=${searchCategory}&searchPrice=${searchPrice}" 
                                   class="page-link ${pageNum == currentPage ? 'active' : ''}">
                                    ${pageNum}
                                </a>
                            </c:forEach>
                            
                            <!-- Dấu ... nếu cần -->
                            <c:if test="${currentPage < totalPages - 3}">
                                <span class="page-ellipsis">...</span>
                            </c:if>
                            
                            <!-- Hiển thị trang cuối -->
                            <a href="${pageContext.request.contextPath}/admin/courses?page=${totalPages}&searchName=${searchName}&searchCategory=${searchCategory}&searchPrice=${searchPrice}" 
                               class="page-link ${currentPage == totalPages ? 'active' : ''}">
                                ${totalPages}
                            </a>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Nút Next -->
                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/admin/courses?page=${currentPage + 1}&searchName=${searchName}&searchCategory=${searchCategory}&searchPrice=${searchPrice}" 
                           class="page-link">
                            Sau <i class="fa fa-chevron-right"></i>
                        </a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Modal Add Course -->
    <div id="addCourseModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Thêm khóa học mới</h2>
                <span class="close" onclick="closeAddModal()">&times;</span>
            </div>
            <form id="addCourseForm" method="POST" action="${pageContext.request.contextPath}/admin/courses">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="addName">Tên khóa học:</label>
                    <input type="text" id="addName" name="name" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="addCategory">Danh mục:</label>
                    <input type="text" id="addCategory" name="category" class="form-control" 
                           placeholder="Ví dụ: Lập trình, Thiết kế, Marketing...">
                </div>
                
                <div class="form-group">
                    <label for="addPrice">Giá (VND):</label>
                    <input type="number" id="addPrice" name="price" class="form-control" required min="0">
                </div>
                
                <div class="form-group">
                    <label for="addDuration">Thời lượng:</label>
                    <input type="text" id="addDuration" name="duration" class="form-control" 
                           placeholder="Ví dụ: 30 giờ, 2 tháng...">
                </div>
                
                <div class="form-group">
                    <label for="addFrequency">Tần suất:</label>
                    <input type="text" id="addFrequency" name="frequency" class="form-control" 
                           placeholder="Ví dụ: 3 buổi/tuần, Hàng ngày...">
                </div>
                
                <div class="form-group">
                    <label for="addDescription">Mô tả:</label>
                    <textarea id="addDescription" name="description" class="form-control" rows="4" 
                              placeholder="Mô tả chi tiết về khóa học..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="addImageUrl">URL hình ảnh:</label>
                    <input type="url" id="addImageUrl" name="imageUrl" class="form-control" 
                           placeholder="https://example.com/image.jpg">
                    <small class="form-text text-muted">Để trống để sử dụng hình ảnh mặc định</small>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeAddModal()">Hủy</button>
                    <button type="submit" class="btn btn-primary">Thêm khóa học</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Edit Course -->
    <div id="editCourseModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Chỉnh sửa khóa học</h2>
                <span class="close" onclick="closeEditModal()">&times;</span>
            </div>
            <form id="editCourseForm" method="POST" action="${pageContext.request.contextPath}/admin/courses">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="courseId" id="editCourseId">
                
                <div class="form-group">
                    <label for="editName">Tên khóa học:</label>
                    <input type="text" id="editName" name="name" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="editCategory">Danh mục:</label>
                    <input type="text" id="editCategory" name="category" class="form-control" 
                           placeholder="Ví dụ: Lập trình, Thiết kế, Marketing...">
                </div>
                
                <div class="form-group">
                    <label for="editPrice">Giá (VND):</label>
                    <input type="number" id="editPrice" name="price" class="form-control" required min="0">
                </div>
                
                <div class="form-group">
                    <label for="editDuration">Thời lượng:</label>
                    <input type="text" id="editDuration" name="duration" class="form-control" 
                           placeholder="Ví dụ: 30 giờ, 2 tháng...">
                </div>
                
                <div class="form-group">
                    <label for="editFrequency">Tần suất:</label>
                    <input type="text" id="editFrequency" name="frequency" class="form-control" 
                           placeholder="Ví dụ: 3 buổi/tuần, Hàng ngày...">
                </div>
                
                <div class="form-group">
                    <label for="editDescription">Mô tả:</label>
                    <textarea id="editDescription" name="description" class="form-control" rows="4" 
                              placeholder="Mô tả chi tiết về khóa học..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="editImageUrl">URL hình ảnh:</label>
                    <input type="url" id="editImageUrl" name="imageUrl" class="form-control" 
                           placeholder="https://example.com/image.jpg">
                    <small class="form-text text-muted">Để trống để sử dụng hình ảnh mặc định</small>
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

        // Course management functions
        function openAddCourseModal() {
            document.getElementById('addCourseModal').style.display = 'block';
        }
        
        function closeAddModal() {
            document.getElementById('addCourseModal').style.display = 'none';
        }
        
        function editCourse(courseId) {
            // Sử dụng AJAX để lấy thông tin course chi tiết
            fetch('${pageContext.request.contextPath}/admin/courses?action=getCourse&courseId=' + courseId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(course => {
                    // Điền thông tin vào modal
                    document.getElementById('editCourseId').value = course.id;
                    document.getElementById('editName').value = course.name || '';
                    document.getElementById('editCategory').value = course.category || '';
                    document.getElementById('editPrice').value = course.price || '';
                    document.getElementById('editDuration').value = course.duration || '';
                    document.getElementById('editFrequency').value = course.frequency || '';
                    document.getElementById('editDescription').value = course.description || '';
                    document.getElementById('editImageUrl').value = course.imageUrl || '';
                    
                    // Hiển thị modal
                    document.getElementById('editCourseModal').style.display = 'block';
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi tải thông tin khóa học');
                });
        }
        
        function closeEditModal() {
            document.getElementById('editCourseModal').style.display = 'none';
        }
        
        function deleteCourse(courseId) {
            if (confirm('Bạn có chắc chắn muốn xóa khóa học này?')) {
                // Tạo form ẩn để gửi request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/courses';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const courseIdInput = document.createElement('input');
                courseIdInput.type = 'hidden';
                courseIdInput.name = 'courseId';
                courseIdInput.value = courseId;
                
                form.appendChild(actionInput);
                form.appendChild(courseIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Đóng modal khi click bên ngoài
        window.onclick = function(event) {
            const addModal = document.getElementById('addCourseModal');
            const editModal = document.getElementById('editCourseModal');
            if (event.target === addModal) {
                addModal.style.display = 'none';
            }
            if (event.target === editModal) {
                editModal.style.display = 'none';
            }
        }
    </script>
</body>
</html> 