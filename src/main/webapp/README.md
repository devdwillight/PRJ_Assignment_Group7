# Google Calendar Style - Professional Calendar

Một giao diện calendar chuyên nghiệp giống Google Calendar với thiết kế hiện đại, màu sắc sống động và animation mượt mà.

## 🎨 Tính năng

### ✨ Giao diện chuyên nghiệp
- Thiết kế giống Google Calendar với layout hiện đại
- Màu sắc sống động với gradient và shadow effects
- Responsive design cho mọi thiết bị
- Font Roboto chuyên nghiệp

### 🎭 Animation mượt mà
- Slide animations khi chuyển tháng
- Hover effects với scale và shadow
- Pulse animation cho logo
- Bounce animation cho calendar items
- Glow effect cho ngày hiện tại
- Success animation khi tạo sự kiện

### 📅 Chức năng chính
- **Navigation**: Chuyển tháng trước/sau với animation
- **Tạo sự kiện**: Modal form với validation
- **Quản lý lịch**: 4 loại lịch khác nhau (Chính, Công việc, Cá nhân, Gia đình)
- **Mini Calendar**: Xem nhanh tháng hiện tại
- **Local Storage**: Lưu trữ sự kiện trong browser
- **Notifications**: Thông báo thành công/lỗi

### ✅ Todo List
- **Thêm công việc**: Click nút "+" để thêm todo mới
- **Đánh dấu hoàn thành**: Click checkbox để toggle trạng thái
- **Xóa công việc**: Hover và click nút xóa
- **Animation**: Slide animation khi thêm/xóa todo
- **Local Storage**: Tự động lưu trữ todo list

### 🤖 Chatbot Assistant
- **Trợ lý thông minh**: Hỗ trợ tạo sự kiện, quản lý todo
- **Giao diện chat**: Thiết kế giống messenger
- **Responsive**: Minimize/maximize chatbot
- **Tương tác tự nhiên**: Hiểu và trả lời các câu hỏi
- **Animation**: Smooth transitions và effects

### 🎯 Tương tác
- Click vào ngày để tạo sự kiện
- Click vào sự kiện để xem chi tiết
- Toggle hiển thị các loại lịch
- Keyboard shortcuts (ESC để đóng modal)
- Chat với trợ lý AI

## 🚀 Cách sử dụng

### 1. Mở calendar
Mở file `calendar.html` trong trình duyệt web.

### 2. Tạo sự kiện
- Click nút "Tạo sự kiện" hoặc click vào ngày bất kỳ
- Điền thông tin: tiêu đề, ngày, thời gian, mô tả, loại lịch
- Click "Lưu" để tạo sự kiện

### 3. Quản lý Todo List
- Click nút "+" trong phần Todo List
- Nhập nội dung công việc và nhấn Enter
- Click checkbox để đánh dấu hoàn thành
- Hover và click nút xóa để xóa công việc

### 4. Sử dụng Chatbot
- Click vào chatbot ở góc phải dưới
- Nhập câu hỏi như "Tạo sự kiện", "Quản lý todo"
- Chatbot sẽ hướng dẫn bạn cách sử dụng

### 5. Quản lý lịch
- Click vào các loại lịch trong sidebar để ẩn/hiện
- Mỗi loại lịch có màu sắc riêng biệt

### 6. Navigation
- Sử dụng nút mũi tên để chuyển tháng
- Click vào các view options (Tháng/Tuần/Ngày)

## 🎨 Màu sắc

### Lịch chính: #4285f4 (Xanh dương)
### Công việc: #ea4335 (Đỏ)
### Cá nhân: #34a853 (Xanh lá)
### Gia đình: #fbbc04 (Vàng)

## 📱 Responsive

Calendar được thiết kế responsive và hoạt động tốt trên:
- Desktop (1400px+)
- Tablet (768px - 1399px)
- Mobile (< 768px)

## 🛠️ Cấu trúc file

```
src/main/webapp/
├── calendar.html          # File HTML chính
├── css/
│   └── calendar.css       # Styles và animations
├── js/
│   └── calendar.js        # Logic và functionality
└── README.md             # Hướng dẫn sử dụng
```

## 🔧 Tùy chỉnh

### Thay đổi màu sắc
Chỉnh sửa các biến CSS trong file `calendar.css`:

```css
/* Header gradient */
background: linear-gradient(135deg, #4285f4 0%, #34a853 100%);

/* Button gradient */
background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
```

### Thêm loại lịch mới
1. Thêm HTML trong sidebar
2. Thêm CSS class cho màu sắc
3. Cập nhật JavaScript để xử lý

### Animation timing
Điều chỉnh thời gian animation trong CSS:

```css
transition: all 0.3s ease;  /* Thay đổi 0.3s */
```

## 🌟 Tính năng nâng cao

### Sample Events
Calendar tự động tạo 3 sự kiện mẫu khi lần đầu sử dụng:
- Họp nhóm dự án (Công việc)
- Sinh nhật bạn (Cá nhân)
- Đi chơi gia đình (Gia đình)

### Sample Todos
Todo list tự động tạo 3 công việc mẫu:
- Hoàn thành báo cáo dự án
- Gọi điện cho khách hàng (đã hoàn thành)
- Chuẩn bị cho cuộc họp ngày mai

### Local Storage
Tất cả sự kiện và todo được lưu trong localStorage của browser, không mất dữ liệu khi refresh trang.

### Chatbot Commands
Chatbot hiểu các lệnh:
- "Tạo sự kiện" / "Thêm sự kiện"
- "Todo" / "Công việc"
- "Lịch" / "Calendar"
- "Xin chào" / "Hello"
- "Cảm ơn" / "Thanks"

### Keyboard Shortcuts
- `ESC`: Đóng modal và todo input
- `Enter`: Lưu sự kiện/todo (khi focus vào form)
- `Enter`: Gửi tin nhắn chatbot

## 🎯 Tương thích

- Chrome 60+
- Firefox 55+
- Safari 12+
- Edge 79+

## 📝 Ghi chú

- Calendar sử dụng font Roboto từ Google Fonts
- Icons sử dụng Font Awesome 6
- Tất cả animations được tối ưu cho performance
- Code được viết theo ES6+ standards
- Todo list và chatbot hoạt động độc lập
- Dữ liệu được lưu trữ locally trong browser

## 🔮 Tính năng tương lai

- [ ] Đồng bộ với Google Calendar API
- [ ] Nhắc nhở thông báo
- [ ] Chia sẻ lịch với người khác
- [ ] Export/Import dữ liệu
- [ ] Theme tùy chỉnh
- [ ] Multi-language support

---

**Tác giả**: Professional Calendar Team  
**Phiên bản**: 2.0  
**Ngày tạo**: 2024 