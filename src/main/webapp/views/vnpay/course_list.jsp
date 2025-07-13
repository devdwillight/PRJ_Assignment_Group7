<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.model.Course" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <style>
        /* ===== TOÀN TRANG SÁNG ===== */
        body{
            font-family: Arial, sans-serif;
            margin: 20px;
            background: #FFF9F0;            /* trắng ngà – vàng rất nhạt */
            color: #333333;                 /* chữ đen mềm */
        }
        h1{
            text-align: center;
            color: #333333;
            margin-bottom: 30px;
            font-size: 32px;
        }

        .product-list{
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }

        /* ===== THẺ KHOÁ HỌC TỐI ===== */
        .product-item{
            background: #2f2f2f;            /* xám đậm */
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,.35);
            transition: transform .3s ease;
            position: relative;
            z-index: 1;
        }
        .product-item:hover{
            transform: scale(1.05);
            z-index: 100;                   /* đè lên card khác khi hover */
        }

        /* ===== ẢNH ===== */
        .thumb{
            width: 100%;
            height: 200px;
            border-radius: 8px;
            overflow: hidden;
            background: #d1d5db;           /* màu chờ load ảnh */
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .thumb img{
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* ===== POP‑UP MÔ TẢ – SÁNG ===== */
        .description{
            text-align: left;
            position: absolute;
            top: 0;
            width: 260px;
            background: #fffbe6;           /* vàng nhạt sáng */
            color: #000000;                /* chữ đen */
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 6px 16px rgba(0,0,0,.25);
            opacity: 0;
            visibility: hidden;
            pointer-events: none;
            transition: opacity .3s ease, visibility .3s ease;
            transition-delay: 0s;
            z-index: 110;
        }
        .product-item:hover .description{
            opacity: 1;
            visibility: visible;
            transition-delay: .5s;         /* xuất hiện sau 0.5 giây */
        }

        /* pop‑up cột 1 → bên phải ; các cột khác → bên trái */
        .product-item:nth-child(4n+1) .description{
            left: 100%;
            margin-left: 10px;
        }
        .product-item:not(:nth-child(4n+1)) .description{
            right: 100%;
            margin-right: 10px;
        }

        /* ===== NỘI DUNG TRONG CARD ===== */
        .product-item h3{
            font-size: 18px;
            color: #f1f1f1;
            margin-top: 15px;
        }
        .product-item p{
            font-size: 14px;
            color: #cccccc;
            margin: 5px 0;
        }
        .product-item .price{
            font-size: 18px;
            color: #facc15;                /* vàng nổi bật cho giá */
            font-weight: bold;
            margin-top: 10px;
        }
        .rating{
            margin-top: 10px;
            color: #facc15;
        }

        .buy-button{
            padding: 10px 15px;
            background: #facc15;           /* nút vàng */
            color: #000;
            border: none;
            cursor: pointer;
            margin-top: 15px;
            border-radius: 5px;
            transition: background .3s;
        }
        .buy-button:hover{
            background: #eab308;
        }

        /* ===== POP‑UP TEXT ===== */
        .description h2{
            font-size: 22px;
            font-weight: bold;
            color: #000;
            margin-bottom: 8px;
        }

        .star-container{
            display: inline-block;
            vertical-align: middle;
        }
        .star-container svg{
            width: 14px;
            height: 14px;
            fill: #facc15;
        }
    </style>
</head>

<body>
    <h1>Danh Sách Khoá Học</h1>

    <div class="product-list">
        <c:forEach var="course" items="${courses}">
            <div class="product-item">
                <!-- Ảnh -->
                <div class="thumb">
                    <img src="${empty course.imageUrl ? 'images/placeholder.png' : course.imageUrl}"
                         alt="${course.name}">
                </div>

                <!-- Thông tin tóm tắt -->
                <h3>${course.name}</h3>
                <p>Chuyên mục: ${course.category}</p>
                <p>Thời lượng: ${course.duration}</p>
                <p class="price">
                    <fmt:formatNumber value="${course.price}" type="currency"
                                      currencySymbol="₫" groupingUsed="true"/>
                </p>

                <!-- Đánh giá (giả lập) -->
                <div class="rating">
                    <span class="star-container">
                        <svg viewBox="0 0 28 27"><path d="M13.09 1.05c.35-.79 1.47-.79 1.82 0l3.27 7.34c.15.33.46.56.82.6l7.99.84c.86.09 1.21 1.15.57 1.72l-6 5.38c-.27.24-.4.6-.32.96l1.63 7.86c.18.85-.71 1.5-1.44 1.06l-6.73-3.9a1 1 0 0 0-.99 0l-6.73 3.9c-.73.44-1.62-.21-1.44-1.06l1.63-7.86a1 1 0 0 0-.32-.96l-6-5.38c-.64-.57-.29-1.63.57-1.72l7.99-.84c.36-.04.67-.27.82-.6l3.27-7.34Z"/></svg>
                    </span>
                    <span>5.0</span>
                </div>

                <!-- POP‑UP chi tiết -->
                <div class="description">
                    <h2>${course.name}</h2>
                    <p>${course.description}</p>
                    <p>Tần suất: ${course.frequency}</p>
                </div>

                <!-- Nút -->
                <form action="payment.jsp" method="get">
                    <input type="hidden" name="courseId"    value="${course.idCourse}">
                    <input type="hidden" name="courseName"  value="${course.name}">
                    <input type="hidden" name="coursePrice" value="${course.price}">
                    <button type="submit" class="buy-button">Đăng ký ngay</button>
                </form>
            </div>
        </c:forEach>
    </div>
</body>
</html>
