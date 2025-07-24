<%-- 
    Document   : profile.jsp
    Created on : Jul 22, 2025, 11:40:53 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body>
        <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-blue-100 py-8">
            <div class="w-full max-w-lg bg-white rounded-2xl shadow-2xl p-8 border border-blue-100">
                <a href="<%= request.getContextPath() %>/calendar" class="inline-block mb-4 px-5 py-2 bg-blue-100 text-blue-700 font-semibold rounded-lg shadow hover:bg-blue-200 transition-all duration-150"><i class="fas fa-arrow-left mr-2"></i>Quay lại trang chủ</a>
                <h2 class="text-3xl font-extrabold mb-8 text-blue-700 text-center tracking-tight">Chỉnh sửa thông tin cá nhân</h2>
                <% if (request.getAttribute("success") != null) { %>
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4 text-center" role="alert">
                    <strong class="font-bold">Thành công!</strong>
                    <span class="block sm:inline"><%= request.getAttribute("success")%></span>
                </div>
                <% } %>
                <form action="user" method="post" enctype="multipart/form-data" class="space-y-5">
                    <input type="hidden" name="action" value="updateProfile"/>
                    <div class="flex flex-col items-center mb-4">
                        <% com.model.User user = (com.model.User)request.getAttribute("userProfile"); %>
                        <% String avatar = user != null ? user.getAvatar() : null; %>
                        <div class="relative">
                            <img src="<%= avatar != null && !avatar.isEmpty() ? avatar : request.getContextPath() + "/assets/User.svg" %>" alt="avatar" class="w-28 h-28 rounded-full border-4 border-blue-200 shadow mb-2 object-cover" />
                            <label class="absolute bottom-2 right-2 bg-blue-600 text-white rounded-full p-2 cursor-pointer hover:bg-blue-700 transition" title="Đổi ảnh đại diện">
                                <input type="file" name="avatar" accept="image/*" class="hidden" />
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536M9 13h6m2 2a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2h10z" /></svg>
                            </label>
                        </div>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block font-semibold mb-1 text-gray-700">Tên đăng nhập</label>
                            <input type="text" name="username" value="<%= user != null ? user.getUsername() : "" %>" class="w-full border border-gray-300 rounded px-3 py-2 bg-gray-100 text-gray-500" readonly />
                        </div>
                        <div>
                            <label class="block font-semibold mb-1 text-gray-700">Email</label>
                            <input type="email" name="email" value="<%= user != null ? user.getEmail() : "" %>" class="w-full border border-gray-300 rounded px-3 py-2" required />
                        </div>
                        <div>
                            <label class="block font-semibold mb-1 text-gray-700">Họ</label>
                            <input type="text" name="firstName" value="<%= user != null && user.getFirstName() != null ? user.getFirstName() : "" %>" class="w-full border border-gray-300 rounded px-3 py-2" />
                        </div>
                        <div>
                            <label class="block font-semibold mb-1 text-gray-700">Tên</label>
                            <input type="text" name="lastName" value="<%= user != null && user.getLastName() != null ? user.getLastName() : "" %>" class="w-full border border-gray-300 rounded px-3 py-2" />
                        </div>
                        <div>
                            <label class="block font-semibold mb-1 text-gray-700">Ngày sinh</label>
                            <input type="date" name="birthday" value="<%= user != null && user.getBirthday() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(user.getBirthday()) : "" %>" class="w-full border border-gray-300 rounded px-3 py-2" />
                        </div>
                        <div>
                            <label class="block font-semibold mb-1 text-gray-700">Số điện thoại</label>
                            <input type="text" name="phone" value="<%= user != null && user.getPhone() != null ? user.getPhone() : "" %>" class="w-full border border-gray-300 rounded px-3 py-2" />
                        </div>
                        <div>
                            <label class="block font-semibold mb-1 text-gray-700">Giới tính</label>
                            <select name="gender" class="w-full border border-gray-300 rounded px-3 py-2">
                                <option value="" <%= user != null && user.getGender() == null ? "selected" : "" %>>Chọn giới tính</option>
                                <option value="Male" <%= user != null && "Male".equals(user.getGender()) ? "selected" : "" %>>Nam</option>
                                <option value="Female" <%= user != null && "Female".equals(user.getGender()) ? "selected" : "" %>>Nữ</option>
                                <option value="Other" <%= user != null && "Other".equals(user.getGender()) ? "selected" : "" %>>Khác</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="w-full bg-gradient-to-r from-blue-500 to-blue-700 text-white py-3 rounded-lg font-bold text-lg shadow hover:from-blue-600 hover:to-blue-800 transition-all duration-200 mt-6">Lưu thay đổi</button>
                </form>
            </div>
        </div>
    </body>
</html>
