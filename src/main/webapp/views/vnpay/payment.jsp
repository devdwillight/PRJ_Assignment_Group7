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
            --btn-cancel:  #e74c3c;
            --btn-cancel-hover: #c0392b;
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

        .form-buttons {
            margin-top: 30px;
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            cursor: pointer;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            transition: background-color .3s;
        }

        .btn-primary {
            background-color: var(--btn);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--btn-hover);
        }

        .btn-cancel {
            background-color: var(--btn-cancel);
            color: white;
        }

        .btn-cancel:hover {
            background-color: var(--btn-cancel-hover);
        }

        .error-message {
            color: #e74c3c;
            font-size: 18px;
            margin: 20px 0 20px 0;
            font-weight: bold;
            text-align: left;
        }
    </style>
</head>
<body>

    <h2>Xác Nhận Thanh Toán Khóa Học</h2>

    <c:if test="${not empty mess}">
        <div class="error-message">${mess}</div>
    </c:if>

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

    <div class="form-buttons">
        <a href="<%= request.getContextPath() %>/Course" class="btn btn-cancel">Quay lại danh sách</a>
        <form action="<%= request.getContextPath() %>/payment" method="post" style="display:inline;">
            <input type="hidden" name="totalBill" value="${param.coursePrice}">
            <input type="hidden" name="courseId" value="${param.courseId}">
            <input type="hidden" name="courseName" value="${param.courseName}">
            <input type="hidden" name="courseCategory" value="${param.courseCategory}">
            <button type="submit" class="btn btn-primary">Xác Nhận Đặt Mua</button>
        </form>
    </div>

</body>
</html>
