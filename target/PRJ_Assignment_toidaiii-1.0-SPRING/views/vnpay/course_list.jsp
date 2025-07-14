<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.model.Course" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <style>
            :root{
                --bg-page:     #f5f6fa;
                --bg-card:     #ffffff;
                --bg-popup:    #ffffff;
                --bg-thumb:    #e5e7eb;
                --bg-tag:      #e3e6ff;
                --tag-text:    #5263ff;
                --text-main:   #23262f;
                --text-sub:    #6b7280;
                --gold:        #facc15;
                --price-sale:  #ff4d4f;
            }
            body{
                font-family: Arial, sans-serif;
                margin: 20px;
                background: var(--bg-page);
                color: var(--text-main);
            }
            h1{
                text-align: center;
                color: var(--text-main);
                margin-bottom: 32px;
                font-size: 32px;
            }
            .main-layout {
                display: flex;
                gap: 36px;
                align-items: flex-start;
            }
            /* ==== SIDEBAR ==== */
            .sidebar {
                width: 100%;
                max-width: 295px;
                background: #fff;
                border-radius: 14px;
                box-shadow: 0 2px 16px rgba(30, 34, 90, 0.10);
                padding: 22px 18px 22px 18px;
                margin-bottom: 16px;
            }
            .search-box input[type="text"] {
                width: 100%;
                padding: 10px 12px;
                border: 1.5px solid #e2e8f0;
                border-radius: 8px;       /* hoặc 6px nếu muốn ít bo hơn */
                font-size: 15px;
                background: #fafafd;
                outline: none;
                margin-bottom: 18px;      /* nhỏ hơn, để sát các section khác */
                box-sizing: border-box;   /* Đảm bảo không bị tràn */
                transition: border 0.18s;
            }
            .search-box input[type="text"]:focus {
                border: 1.5px solid #5263ff;
            }
            .filter-section {
                margin-bottom: 22px;
            }
            .filter-title {
                font-weight: 700;
                font-size: 17px;
                margin-bottom: 9px;
                color: #23262f;
                letter-spacing: 0.01em;
            }
            .sort-select {
                width: 100%;
                padding: 9px 11px;
                border-radius: 8px;
                border: 1.5px solid #e2e8f0;
                background: #fafafd;
                font-size: 15px;
                color: #23262f;
                margin-bottom: 14px;
                outline: none;
                transition: border 0.18s;
            }
            .sort-select:focus {
                border: 1.5px solid #5263ff;
            }
            .subcategory-item {
                margin-bottom: 9px;
                display: flex;
                align-items: center;
            }
            .subcategory-item input[type="checkbox"] {
                width: 17px;
                height: 17px;
                accent-color: #5263ff;
                margin-right: 10px;
            }
            .subcategory-item label {
                font-size: 15px;
                color: #23262f;
                cursor: pointer;
                font-weight: 500;
                letter-spacing: 0.012em;
            }
            button[type="submit"] {
                margin-top: 10px;
                padding: 10px 0;
                width: 100%;
                border-radius: 8px;
                background: #5263ff;
                color: #fff;
                border: none;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.21s;
            }
            button[type="submit"]:hover {
                background: #4351ff;
            }

            /* ==== COURSE CONTENT ==== */
            .course-content {
                flex: 3;
                min-width: 0;
            }
            .product-list{
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 24px;
            }
            .product-item{
                background: var(--bg-card);
                padding: 18px;
                border-radius: 10px;
                text-align: left;
                box-shadow: 0 3px 8px rgba(0,0,0,.08);
                border: 1px solid #e2e8f0;
                transition: transform .25s, box-shadow .25s;
                position: relative;
                z-index: 1;
            }
            .product-item:hover{
                transform: translateY(-4px);
                box-shadow: 0 8px 20px rgba(0,0,0,.15);
                z-index: 100;
            }
            .thumb{
                width: 100%;
                height: 180px;
                border-radius: 8px;
                overflow: hidden;
                background: var(--bg-thumb);
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 14px;
            }
            .thumb img{
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            .course-tag{
                display: inline-block;
                font-size: 12px;
                background: var(--bg-tag);
                color: var(--tag-text);
                padding: 2px 8px;
                border-radius: 4px;
                margin-bottom: 6px;
            }
            .title{
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 6px;
            }
            .sub{
                font-size: 13px;
                color: var(--text-sub);
                margin-bottom: 12px;
            }
            .price{
                font-size: 18px;
                font-weight: 700;
                color: var(--price-sale);
                margin: 12px 0 4px;
            }
            .rating{
                font-size: 14px;
                color: var(--gold);
                margin-bottom: 10px;
            }
            .buy-button{
                display: block;
                width: 100%;
                text-align: center;
                padding: 10px 0;
                background: var(--tag-text);
                color: #fff;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 600;
                transition: background .25s;
            }
            .buy-button:hover{
                background: #4351ff;
            }
            .star-container{
                display:inline-block;
                vertical-align:middle;
            }
            .star-container svg{
                width:14px;
                height:14px;
                fill:var(--gold);
            }
            /* ==== POP-UP ==== */
            .description{
                position: absolute;
                top: 0;
                width: 300px;
                background: var(--bg-popup);
                color: var(--text-main);
                padding: 20px 22px;
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(0,0,0,.18);
                opacity: 0;
                visibility: hidden;
                pointer-events: none;
                transition: opacity .3s, visibility .3s;
                transition-delay: 0s;
            }
            .description::after{
                content: '';
                position: absolute;
                top: 40px;
                width: 14px;
                height: 14px;
                background: var(--bg-popup);
                transform: rotate(45deg);
                box-shadow: 0 2px 6px rgba(0,0,0,.12);
            }
            .product-item:hover .description{
                opacity: 1;
                visibility: visible;
                transition-delay: .4s;
            }
            .product-item:nth-child(4n+1) .description{
                left: 100%;
                margin-left: 18px;
            }
            .product-item:nth-child(4n+1) .description::after{
                left: -7px;
            }
            .product-item:not(:nth-child(4n+1)) .description{
                right: 100%;
                margin-right: 18px;
            }
            .product-item:not(:nth-child(4n+1)) .description::after{
                right: -7px;
            }
        </style>
    </head>
    <body>
        <h1>Danh Sách Khoá Học</h1>
        <div class="main-layout">
            <!-- SIDEBAR FILTER -->
            <aside class="sidebar">
                <form id="filterForm" action="Course" method="get">
                    <div class="search-box">
                        <input type="text" name="search" id="searchInput" placeholder="Tìm kiếm sản phẩm..." value="${param.search}">
                    </div>
                    <div class="filter-section">
                        <div class="filter-title">Sort by:</div>
                        <select class="sort-select" name="sort" id="sortSelect">
                            <option value="name-asc" ${param.sort == 'name-asc' ? 'selected' : ''}>A-Z</option>
                            <option value="name-desc" ${param.sort == 'name-desc' ? 'selected' : ''}>Z-A</option>
                            <option value="price-asc" ${param.sort == 'price-asc' ? 'selected' : ''}>Giá tăng dần</option>
                            <option value="price-desc" ${param.sort == 'price-desc' ? 'selected' : ''}>Giá giảm dần</option>
                            <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                        </select>
                    </div>
                    <div class="filter-section">
                        <div class="filter-title">Categories</div>
                        <c:forEach var="cate" items="${allCategories}">
                            <div class="subcategory-item">
                                <input type="checkbox" id="cate-${cate}" name="category" value="${cate}"
                                       ${fn:contains(paramValues.category, cate) ? 'checked' : ''}>
                                <label for="cate-${cate}">${cate.toUpperCase()}</label>
                            </div>
                        </c:forEach>
                    </div>
                    <button type="submit">Lọc</button>
                </form>
            </aside>
            <!-- DANH SÁCH KHÓA HỌC BÊN PHẢI -->
            <div class="course-content">
                <div class="product-list">
                    <c:forEach var="course" items="${courses}">
                        <div class="product-item">
                            <div class="thumb">
                                <img src="${empty course.imageUrl ? 'images/placeholder.png' : course.imageUrl}"
                                     alt="${course.name}">
                            </div>
                            <span class="course-tag">Khóa học</span>
                            <div class="title">${course.name}</div>
                            <div class="sub">Jikan/${course.category}</div>
                            <div class="rating">
                                <span class="star-container">
                                    <svg viewBox="0 0 28 27"><path d="M13.09 1.05c.35-.79 1.47-.79 1.82 0l3.27 7.34c.15.33.46.56.82.6l7.99.84c.86.09 1.21 1.15.57 1.72l-6 5.38c-.27.24-.4.6-.32.96l1.63 7.86c.18.85-.71 1.5-1.44 1.06l-6.73-3.9a1 1 0 0 0-.99 0l-6.73 3.9c-.73.44-1.62-.21-1.44-1.06l1.63-7.86a1 1 0 0 0-.32-.96l-6-5.38c-.64-.57-.29-1.63.57-1.72l7.99-.84c.36-.04.67-.27.82-.6l3.27-7.34Z"/></svg>
                                </span>
                                4.8
                            </div>
                            <div class="price">
                                <fmt:formatNumber value="${course.price}" type="currency"
                                                  currencySymbol="₫" groupingUsed="true"/>
                            </div>
                            <form action="views/vnpay/payment.jsp" method="get">
                                <input type="hidden" name="courseId" value="${course.idCourse}">
                                <input type="hidden" name="courseName" value="${course.name}">
                                <input type="hidden" name="courseCategory" value="${course.category}">
                                <input type="hidden" name="coursePrice" value="${course.price}">
                                <button type="submit" class="buy-button">Mua ngay</button>
                            </form>
                            <div class="description">
                                <h3 style="margin-top:0;font-size:20px;font-weight:700;">${course.name}</h3>
                                <p style="font-size:14px;line-height:1.6;margin-bottom:12px;">${course.description}</p>
                                <ul style="padding-left:16px;margin:0 0 8px;">
                                    <li style="margin-bottom:6px;">Tần suất: ${course.frequency}</li>
                                    <li>Thời lượng: ${course.duration}</li>
                                </ul>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <script>
            document.getElementById('sortSelect').addEventListener('change', function () {
                document.getElementById('filterForm').submit();
            });
            document.querySelectorAll('input[name="category"]').forEach(function (checkbox) {
                checkbox.addEventListener('change', function () {
                    document.getElementById('filterForm').submit();
                });
            });
            document.getElementById('searchInput').addEventListener('keypress', function (e) {
                if (e.key === 'Enter')
                    document.getElementById('filterForm').submit();
            });
        </script>
    </body>
</html>
