<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thanh Toán Đơn Hàng</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #1a2b3c;  /* Màu nền xanh dương đậm */
                color: #f4f4f4;  /* Màu chữ sáng */
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            th, td {
                padding: 10px;
                border: 1px solid #444;  /* Đổi màu đường biên sang màu tối */
                text-align: center;
            }

            th {
                background-color: #2c3e50;  /* Nền của header xanh dương */
                color: #fff;  /* Màu chữ sáng cho header */
            }

            .total {
                font-weight: bold;
                color: #f4f4f4;  /* Màu chữ cho tổng */
            }

            button {
                padding: 10px 15px;
                background-color: #3498db;  /* Màu nền nút xanh dương */
                color: white;
                border: none;
                cursor: pointer;
                margin-top: 20px;
                border-radius: 5px;
            }

            button:hover {
                background-color: #2980b9;  /* Màu nền khi hover */
            }

            button:focus {
                outline: none;  /* Bỏ viền khi nút được chọn */
            }

        </style>
    </head>
    <body>
        <h2>Sản Phẩm Thanh Toán</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên Sản Phẩm</th>
                    <th>Tác Giả</th>
                    <th>Giá</th>
                </tr>
            </thead>
            <tbody>
                <!-- Lấy thông tin sản phẩm từ request -->
                <tr>
                    <td>${param.productId}</td>
                    <td>${param.productTitle}</td>
                    <td>${param.productAuthor}</td>
                    <td>${param.productPrice} VND</td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="3" class="total">Tổng Tiền:</td>
                    <td class="total">${param.productPrice} VND</td>
                </tr>
            </tfoot>
        </table>

        <form action="payment" method="post">
            <input type="hidden" name="totalBill" value="${param.productPrice}">
            <input type="hidden" name="productId" value="${param.productId}">
            <input type="hidden" name="productTitle" value="${param.productTitle}">
            <input type="hidden" name="productAuthor" value="${param.productAuthor}">
            <button type="submit">Đặt Mua</button>
        </form>
    </body>
</html>

