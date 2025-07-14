<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.model.Course" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <style>
        /* ======= TONE MÀU CHUNG ======= */
        :root{
            --bg-page:     #f5f6fa;   /* xám rất nhạt (nền) */
            --bg-card:     #ffffff;   /* nền thẻ khóa học */
            --bg-popup:    #ffffff;   /* nền pop‑up */
            --bg-thumb:    #e5e7eb;   /* màu chờ load ảnh */
            --bg-tag:      #e3e6ff;   /* nền nhãn */
            --tag-text:    #5263ff;   /* chữ nhãn */
            --text-main:   #2d2d2d;   /* chữ chính */
            --text-sub:    #6b7280;   /* chữ phụ xám */
            --gold:        #facc15;   /* sao đánh giá */
            --price-sale:  #ff4d4f;   /* giá đang bán */
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
            margin-bottom: 30px;
            font-size: 32px;
        }

        .product-list{
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
        }

        /* ======= CARD ======= */
        .product-item{
            background: var(--bg-card);
            padding: 18px;
            border-radius: 10px;
            text-align: left;
            box-shadow: 0 3px 8px rgba(0,0,0,.08);
            border: 1px solid #e2e8f0;
            transition: transform .25s ease, box-shadow .25s ease;
            position: relative;
            z-index: 1;
        }
        .product-item:hover{
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0,0,0,.15);
            z-index: 100;
        }

        /* ======= ẢNH ======= */
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

        /* ======= NHÃN “Khóa học” ======= */
        .course-tag{
            display: inline-block;
            font-size: 12px;
            background: var(--bg-tag);
            color: var(--tag-text);
            padding: 2px 8px;
            border-radius: 4px;
            margin-bottom: 6px;
        }

        /* ======= POP‑UP ======= */
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
            transition: opacity .3s ease, visibility .3s ease;
            transition-delay: 0s;
        }
        /* mũi tên (arrow) */
        .description::after{
            content: '';
            position: absolute;
            top: 40px;
            width: 14px; height: 14px;
            background: var(--bg-popup);
            transform: rotate(45deg);
            box-shadow: 0 2px 6px rgba(0,0,0,.12);
        }

        .product-item:hover .description{
            opacity: 1;
            visibility: visible;
            transition-delay: .4s;   /* hiện sau 0.4s */
        }

        /* Cột đầu (4n+1) → pop‑up bên phải */
        .product-item:nth-child(4n+1) .description{
            left: 100%; margin-left: 18px;
        }
        .product-item:nth-child(4n+1) .description::after{
            left: -7px;               /* arrow bên trái pop‑up */
        }

        /* Cột còn lại → pop‑up bên trái */
        .product-item:not(:nth-child(4n+1)) .description{
            right: 100%; margin-right: 18px;
        }
        .product-item:not(:nth-child(4n+1)) .description::after{
            right: -7px;              /* arrow bên phải pop‑up */
        }

        /* ======= TEXT ======= */
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

        /* ======= NÚT ======= */
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
            display:inline-block;vertical-align:middle;
        }
        .star-container svg{width:14px;height:14px;fill:var(--gold);}
    </style>
</head>

<body>
    <h1>Danh Sách Khoá Học</h1>

    <div class="product-list">
        <c:forEach var="course" items="${courses}">
            <div class="product-item">

                <div class="thumb">
                    <img src="${empty course.imageUrl ? 'images/placeholder.png' : course.imageUrl}"
                         alt="${course.name}">
                </div>

                <span class="course-tag">Khóa học</span>

                <div class="title">${course.name}</div>
                <div 
                    class="sub">Jikan/${course.category}
                </div>

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
                    <input type="hidden" name="courseId"    value="${course.idCourse}">
                    <input type="hidden" name="courseName"  value="${course.name}">
                    <input type="hidden" name="courseCategory"  value="${course.category}">
                    <input type="hidden" name="coursePrice" value="${course.price}">
                    <button type="submit" class="buy-button">Mua ngay</button>
                </form>

                <!-- POP‑UP -->
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
</body>
</html>
