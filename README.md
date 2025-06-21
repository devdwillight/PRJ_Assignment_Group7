# Google Calendar Style - Professional Calendar

Một giao diện calendar chuyên nghiệp giống Google Calendar với thiết kế hiện đại, màu sắc sống động và animation mượt mà.

## 🎨 Tính năng

### ✨ Giao diện chuyên nghiệp
- Thiết kế với layout hiện đại
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
- **Ai Agent**: Trợ lý quản lí thời gian

### 🎯 Tương tác
- Click vào ngày để tạo sự kiện
- Click vào sự kiện để xem chi tiết
- Toggle hiển thị các loại lịch
- Keyboard shortcuts (ESC để đóng modal)

## 🚀 Cách sử dụng

### 1. Mở calendar
Mở file `calendar.html` trong trình duyệt web.

### 2. Tạo sự kiện
- Click nút "Tạo sự kiện" hoặc click vào ngày bất kỳ
- Điền thông tin: tiêu đề, ngày, thời gian, mô tả, loại lịch
- Click "Lưu" để tạo sự kiện

### 3. Quản lý lịch
- Click vào các loại lịch trong sidebar để ẩn/hiện
- Mỗi loại lịch có màu sắc riêng biệt

### 4. Navigation
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

### Local Storage
Tất cả sự kiện được lưu trong localStorage của browser, không mất dữ liệu khi refresh trang.

### Keyboard Shortcuts
- `ESC`: Đóng modal
- `Enter`: Lưu sự kiện (khi focus vào form)

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

---

**Tác giả**: PRJ_Group7 
**Phiên bản**: 1.0  
**Ngày tạo**: 2025
