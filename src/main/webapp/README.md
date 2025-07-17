
---

# Jikan Calendar - Hệ Thống Quản Lý Lịch Chuyên Nghiệp

## 📝 Giới thiệu

Jikan Calendar là một hệ thống quản lý lịch, sự kiện, công việc và khóa học chuyên nghiệp, hỗ trợ nhiều loại lịch, phân quyền người dùng, tích hợp AI Agent hỗ trợ quản lý thời gian, và thanh toán trực tuyến qua VNPAY. Dự án được phát triển bởi PRJ_Group7.

## 🚀 Tính năng chính

- Quản lý nhiều loại lịch: Lịch chính, Công việc, Cá nhân, Gia đình
- Tạo, sửa, xóa sự kiện, công việc, todo
- Quản lý khóa học, đơn hàng, người dùng
- Đăng ký, đăng nhập, quên mật khẩu, xác thực Google
- Tích hợp AI Agent hỗ trợ lên lịch thông minh
- Thanh toán khóa học qua VNPAY
- Giao diện hiện đại, responsive, animation mượt mà
- Phân quyền quản trị viên/người dùng
- Thống kê, báo cáo, thông báo
- Lưu trữ dữ liệu an toàn với MySQL

## 🗂️ Cấu trúc dự án

```
src/main/java/com/
├── agent/           # AI Agent, xử lý thông minh
├── constant/        # Hằng số, cấu hình
├── controller/      # Servlet điều hướng, xử lý request
├── dao/             # Data Access Object, truy xuất DB
├── database/        # Kết nối, thông tin DB
├── entity/          # Định nghĩa Entity (JPA)
├── model/           # Model trung gian
├── service/         # Business Logic
├── vnpay/           # Tích hợp VNPAY
src/main/webapp/
├── assets/          # Ảnh, icon, SVG
├── css/             # File CSS
├── js/              # File JavaScript
├── views/           # Giao diện JSP
├── calendar.html    # Giao diện calendar tĩnh
├── index.jsp        # Trang chủ động
├── WEB-INF/         # Cấu hình web.xml, beans.xml
```

## ⚙️ Công nghệ sử dụng

- Java Servlet, JSP, JDBC
- MySQL
- HTML5, CSS3, JavaScript (ES6+)
- Font Awesome, Google Fonts
- VNPAY Payment Gateway
- AI Agent (LLM)
- Responsive Design

## 💡 Hướng dẫn cài đặt & chạy

1. Clone dự án về máy:
   ```bash
   git clone <repo-url>
   ```
2. Import vào IDE (NetBeans/IntelliJ/Eclipse)
3. Cấu hình database trong `src/main/resources/application.properties` hoặc `DBinformation.java`
4. Import file `Calendar.sql` vào MySQL
5. Build project với Maven:
   ```bash
   mvn clean install
   ```
6. Deploy lên server (Tomcat/Glassfish)
7. Truy cập: `http://localhost:8080/PRJ_Assignment_Group7/`

## 🧑‍💻 Đăng nhập & phân quyền

- Đăng ký tài khoản mới hoặc đăng nhập bằng Google
- Quản trị viên có thể quản lý người dùng, khóa học, đơn hàng
- Người dùng có thể tạo/sửa/xóa sự kiện, công việc, todo, đăng ký khóa học

## 💳 Thanh toán VNPAY

- Chọn khóa học, tiến hành thanh toán qua VNPAY
- Xem lịch sử đơn hàng, trạng thái thanh toán

## 🤖 AI Agent

- Hỗ trợ lên lịch thông minh, nhắc nhở, tổng hợp lịch trình
- Chatbot hỗ trợ người dùng quản lý thời gian

## 📁 Tài liệu & cấu hình

- `README.md`: Hướng dẫn sử dụng
- `Calendar.sql`: Cấu trúc & dữ liệu mẫu database
- `pom.xml`: Cấu hình Maven
- `src/main/resources/META-INF/persistence.xml`: Cấu hình JPA

## 📱 Responsive

- Hỗ trợ tốt trên Desktop, Tablet, Mobile

## 📝 Ghi chú

- Sử dụng font Roboto, icon Font Awesome
- Tối ưu animation, hiệu năng
- Code chuẩn hóa, dễ mở rộng

---

**Tác giả**: PRJ_Group7  
**Phiên bản**: 1.0  
**Ngày tạo**: 2025

---
