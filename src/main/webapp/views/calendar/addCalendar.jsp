<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="com.model.Calendar" %>
<%
    Calendar calendar = (Calendar) request.getAttribute("calendar");
    boolean isEdit = (calendar != null);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Chỉnh sửa lịch" : "Thêm lịch mới" %></title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 min-h-screen flex items-center justify-center">
    <div class="bg-white shadow-lg rounded-lg p-8 w-full max-w-md">
        <h2 class="text-2xl font-bold mb-6 text-blue-600 text-center">
            <%= isEdit ? "Chỉnh sửa lịch" : "Thêm lịch mới" %>
        </h2>
        <form action="<%=request.getContextPath()%>/calendar?action=<%= isEdit ? "edit&id="+calendar.getIdCalendar() : "create" %>" method="post" class="space-y-5">
            <div>
                <label for="calendarName" class="block text-gray-700 font-medium mb-1">Tên lịch <span class="text-red-500">*</span></label>
                <input type="text" id="calendarName" name="name" required
                       value="<%= isEdit ? calendar.getName() : "" %>"
                       class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400"
                       placeholder="Nhập tên lịch">
            </div>
            <div>
                <label for="calendarColor" class="block text-gray-700 font-medium mb-1">Màu sắc</label>
                <input type="color" id="calendarColor" name="color"
                       value="<%= isEdit && calendar.getColor() != null ? calendar.getColor() : "#3b82f6" %>"
                       class="w-12 h-8 p-0 border-0 bg-transparent cursor-pointer">
            </div> 
            <div class="flex justify-between mt-6">
                <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold px-6 py-2 rounded-md shadow">
                    <%= isEdit ? "Cập nhật" : "Lưu" %>
                </button>
                <a href="<%=request.getContextPath()%>/home" class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold px-6 py-2 rounded-md shadow">Hủy</a>
            </div>
        </form>
        <% if (isEdit) { %>
        <form action="<%=request.getContextPath()%>/calendar?action=delete&id=<%= calendar.getIdCalendar() %>" method="post" style="display:inline;">
            <button type="submit" onclick="return confirm('Bạn có chắc chắn muốn xóa lịch này?');" class="bg-red-500 hover:bg-red-600 text-white font-semibold px-6 py-2 rounded-md shadow mt-4 w-full">Xóa</button>
        </form>
        <% } %>
    </div>
</body>
</html> 