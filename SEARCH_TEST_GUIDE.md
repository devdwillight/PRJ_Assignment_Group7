# Hướng dẫn Test Chức năng Search User

## Tổng quan
Chức năng search user đã được implement đầy đủ với các tính năng:
- Tìm kiếm theo tên (first name, last name, full name, partial name)
- Tìm kiếm theo email
- Tìm kiếm theo trạng thái (active/inactive)
- Kết hợp nhiều điều kiện tìm kiếm

## Cấu trúc Code đã implement

### 1. Interface và Service Layer
- `IUserService.java` - Thêm method `searchUsers(String name, String email, String status)`
- `UserService.java` - Implement method searchUsers

### 2. DAO Layer
- `IUserDAO.java` - Thêm method `searchUsers(String name, String email, String status)`
- `UserDAO.java` - Implement method searchUsers với JPQL query

### 3. Controller Layer
- `UserManageServlet.java` - Xử lý GET request với parameters searchName, searchEmail, searchStatus

### 4. View Layer
- `manageUser.jsp` - Form tìm kiếm với method GET và action đến servlet

## Cách Test

### Bước 1: Build và Deploy
```bash
mvn clean package
# Deploy WAR file lên Tomcat
```

### Bước 2: Truy cập trang quản lý user
```
http://localhost:8080/PRJ_Assignment_toidaiii/admin/users
```

### Bước 3: Test các trường hợp tìm kiếm

#### Test 1: Tìm theo tên
- Nhập tên vào ô "Tìm theo tên" (ví dụ: "Nguyen")
- Click "Tìm kiếm"
- Kết quả: Hiển thị users có "Nguyen" trong first_name hoặc last_name

#### Test 1.1: Tìm theo full name
- Nhập full name vào ô "Tìm theo tên" (ví dụ: "Nguyen Van A")
- Click "Tìm kiếm"
- Kết quả: Hiển thị users có full name match với "Nguyen Van A"

#### Test 1.2: Tìm theo partial name
- Nhập một phần tên vào ô "Tìm theo tên" (ví dụ: "Ng")
- Click "Tìm kiếm"
- Kết quả: Hiển thị users có "Ng" trong bất kỳ phần nào của tên

#### Test 2: Tìm theo email
- Nhập email vào ô "Tìm theo email" (ví dụ: "gmail.com")
- Click "Tìm kiếm"
- Kết quả: Hiển thị users có "gmail.com" trong email

#### Test 3: Tìm theo trạng thái
- Chọn "Hoạt động" hoặc "Không hoạt động" từ dropdown
- Click "Tìm kiếm"
- Kết quả: Hiển thị users theo trạng thái đã chọn

#### Test 3.1: Tìm theo trạng thái "Tất cả"
- Chọn "Tất cả" từ dropdown (hoặc để trống)
- Click "Tìm kiếm"
- Kết quả: Hiển thị TẤT CẢ users (cả hoạt động và không hoạt động)

#### Test 4: Kết hợp tìm kiếm
- Nhập cả tên, email và chọn trạng thái
- Click "Tìm kiếm"
- Kết quả: Hiển thị users thỏa mãn tất cả điều kiện

#### Test 5: Làm mới
- Click "Làm mới" để xóa tất cả điều kiện tìm kiếm
- Kết quả: Hiển thị tất cả users

## Debug và Troubleshooting

### 1. Kiểm tra Database Connection
Chạy class `DatabaseTest.java` để kiểm tra kết nối database:
```bash
java -cp target/classes com.debug.DatabaseTest
```

### 2. Kiểm tra Logs
Xem logs của Tomcat để tìm lỗi:
- Tomcat logs: `logs/catalina.out`
- Application logs: Console output

### 3. Kiểm tra URL và Parameters
- URL: `/PRJ_Assignment_toidaiii/admin/users`
- Method: GET
- Parameters: searchName, searchEmail, searchStatus

### 4. Các lỗi thường gặp

#### Lỗi 1: Không tìm thấy kết quả
- Kiểm tra dữ liệu trong database
- Kiểm tra query JPQL trong UserDAO
- Kiểm tra case sensitivity

#### Lỗi 2: Lỗi database connection
- Kiểm tra SQL Server có đang chạy không
- Kiểm tra thông tin kết nối trong persistence.xml
- Kiểm tra port 1433 có được mở không

#### Lỗi 3: Lỗi compilation
- Kiểm tra tất cả interfaces và implementations đã được cập nhật
- Clean và rebuild project

## File Test
Sử dụng file `test_search.html` để test nhanh các trường hợp tìm kiếm khác nhau.

## Lưu ý
- Chức năng search sử dụng LIKE query với wildcard `%`
- Tìm kiếm không phân biệt hoa thường
- Kết quả được sắp xếp theo ngày tạo mới nhất
- Form tìm kiếm giữ lại giá trị đã nhập sau khi submit 