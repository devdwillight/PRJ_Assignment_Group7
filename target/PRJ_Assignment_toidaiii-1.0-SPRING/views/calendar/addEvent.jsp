<%-- 
    Document   : addCalendar
    Created on : Jul 10, 2025, 11:11:25 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Calendar" %>
<%
    List<Calendar> calendars = (List<Calendar>) request.getAttribute("calendars");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thêm sự kiện mới</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <div class="w-full max-w-3xl mx-auto pt-6">

            <form id="addEventForm" action="event" method="post" class="bg-white rounded-xl shadow p-8 space-y-6">
                <input type="hidden" name="action" value="create" />

                <!-- Tiêu đề + nút lưu -->
                <div class="flex items-center gap-3">

                    <a href="<%=request.getContextPath()%>/home" class="text-gray-500 hover:text-red-500 transition-colors" title="Quay lại">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </a>
                    <input type="text" name="title" required placeholder="Thêm tiêu đề"
                           class="border rounded px-4 py-2 flex-1 text-xl font-semibold focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                    <button type="submit"
                            class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 font-semibold">Lưu</button>
                </div>

                <!-- Các trường còn lại giữ nguyên như bạn đã có, mỗi trường là 1 flex items-center gap-2, có icon SVG bên trái, label nhỏ, input/select đẹp, bo góc, bg-gray-100 -->
                <!-- Ngày giờ -->
                <div class="flex flex-wrap gap-2 px-10">
                    <div class="flex items-center gap-2">
                        <div>
                            <label class="block text-sm font-medium mb-1">Ngày bắt đầu</label>
                            <input type="date" name="startDate" required
                                   class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                        </div>
                    </div>
                    <div class="flex items-center gap-2">
                        <div>
                            <label class="block text-sm font-medium mb-1">Giờ bắt đầu</label>
                            <input type="time" name="startTime"
                                   class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                        </div>
                    </div>
                    <div class="flex items-center mt-6">
                        <span class=" text-gray-500">-</span>
                    </div>
                    <div class="flex items-center gap-1">
                        <div>
                            <label class="block text-sm font-medium mb-1">Ngày kết thúc</label>
                            <input type="date" name="endDate"
                                   class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                        </div>
                    </div>
                    <div class="flex items-center gap-2">
                        <div>
                            <label class="block text-sm font-medium mb-1">Giờ kết thúc</label>
                            <input type="time" name="endTime"
                                   class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                        </div>
                    </div>
                </div>

                <!-- Cả ngày & lặp lại -->
                <div class="flex items-center gap-6 px-10">
                    <label class="inline-flex items-center">
                        <input type="checkbox" name="allDay" value="on" class="accent-blue-600 mr-2"> Cả ngày
                    </label>
                    <div class="flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16" /></svg>
                        <select name="isRecurring"
                                class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                            <option value="0">Không lặp lại</option>
                            <option value="1">Lặp lại</option>
                        </select>

                    </div>
                </div>

                <!-- Vị trí -->
                <div class="flex items-center gap-4">
                    <jsp:include page="../../assets/location_on.svg"/>
                    <input type="text" name="location" placeholder="Vị trí"
                           class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                </div>

                <!-- Nhắc nhở -->
                <div class="flex items-center gap-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V4a2 2 0 10-4 0v1.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" /></svg>
                    <div class="flex-1">
                        <div class="flex gap-2 items-center">
                            <select name="remindMethod"
                                    class="border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                                <option value="0">Thông báo</option>
                                <option value="1">Email</option>
                            </select>
                            <input type="number" name="remindBefore" value="30" min="0"
                                   class="border rounded px-3 py-2 w-20 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100" />
                            <select name="remindUnit"
                                    class="border rounded px-3 py-2 w-28 focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                                <option value="minutes">phút</option>
                                <option value="hours">giờ</option>
                                <option value="days">ngày</option>
                                <option value="weeks">tuần</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Chọn lịch -->
                <div class="flex items-center gap-4">
                    <jsp:include page="../../assets/Calendar_bl.svg"/>
                    <div class="flex-1">
                        <label class="block text-sm font-medium mb-1">Chọn lịch</label>
                        <select name="calendarId" required
                                class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                            <% if (calendars != null)
                                    for (Calendar c : calendars) {%>
                            <option value="<%=c.getIdCalendar()%>"><%=c.getName()%></option>
                            <% }%>
                            <option value="add_new">+ Thêm lịch mới...</option>
                        </select>
                    </div>
                </div>

                <!-- Màu sắc -->
                <div class="flex items-center gap-4">
                    <jsp:include page="../../assets/color_picker.svg"/>
                    <div class="flex-1">
                        <label class="block text-sm font-medium mb-1">Màu sắc</label>
                        <select name="color"
                                class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100">
                            <option value="#3b82f6">Xanh dương</option>
                            <option value="#ef4444">Đỏ</option>
                            <option value="#10b981">Xanh lá</option>
                            <option value="#f59e0b">Cam</option>
                            <option value="#8b5cf6">Tím</option>
                            <option value="#ec4899">Hồng</option>
                            <option value="#f59e0b">Vàng</option>
                            <option value="#6366f1">Xanh tím</option>
                        </select>
                    </div>
                </div>

                <!-- Mô tả -->
                <div class="flex items-center gap-4">
                    <jsp:include page="../../assets/Status_list.svg"/>
                    <div class="flex-1">
                        <label class="block text-sm font-medium mb-1">Mô tả</label>
                        <textarea name="description" rows="3"
                                  class="border rounded px-3 py-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-400 bg-gray-100"></textarea>
                    </div>
                </div>
            </form>
        </div>
    </body>
</html>
