<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh Toán Khóa Học</title>
    <style>
        :root {
            --bg-page:     #f5f6fa;
            --bg-card:     #ffffff;
            --text-main:   #2d2d2d;
            --text-sub:    #6b7280;
            --border:      #e2e8f0;
            --btn:         #5263ff;
            --btn-hover:   #4351ff;
        }

        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: var(--bg-page);
            color: var(--text-main);
        }

        h2 {
            text-align: center;
            font-size: 28px;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: var(--bg-card);
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        th, td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            font-size: 16px;
        }

        th {
            background-color: #f0f4ff;
            color: var(--text-main);
            font-weight: 600;
        }

        tfoot td {
            font-weight: bold;
            background: #fafafa;
            font-size: 17px;
        }

        .total {
            text-align: right;
        }

        form {
            margin-top: 30px;
            text-align: center;
        }

        button {
            padding: 12px 24px;
            background-color: var(--btn);
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            transition: background-color .3s;
        }

        button:hover {
            background-color: var(--btn-hover);
        }

        button:focus {
            outline: none;
        }
    </style>
</head>
<body>

    <h2>Xác Nhận Thanh Toán Khóa Học</h2>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên Khóa Học</th>
                <th>Chuyên Mục</th>
                <th>Giá</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>${param.courseId}</td>
                <td>${param.courseName}</td>
                <td>${param.courseCategory}</td>
                <td>${param.coursePrice} ₫</td>
            </tr>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="3" class="total">Tổng Thanh Toán:</td>
                <td>${param.coursePrice} ₫</td>
            </tr>
        </tfoot>
    </table>

    <form action="<%= request.getContextPath() %>/payment" method="post">
        <input type="hidden" name="totalBill" value="${param.coursePrice}">
        <input type="hidden" name="courseId" value="${param.courseId}">
        <input type="hidden" name="courseName" value="${param.courseName}">
        <input type="hidden" name="courseCategory" value="${param.courseCategory}">
        <button type="submit">Xác Nhận Đặt Mua</button>
    </form>

</body>
</html>
