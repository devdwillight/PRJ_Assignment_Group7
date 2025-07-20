package com.controller.admin;

import com.service.User.UserService;
import com.model.User;
import com.service.UserCourse.UserCourseService;
import com.model.Course;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "UserManageServlet", urlPatterns = {"/admin/users"})
public class UserManageServlet extends HttpServlet {

    private final UserService userService;
    private final UserCourseService userCourseService = new UserCourseService();

    public UserManageServlet() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Kiểm tra nếu có action=getUser để lấy thông tin user chi tiết
            String action = request.getParameter("action");
            if ("getUser".equals(action)) {
                handleGetUser(request, response);
                return;
            }
            
            // Lấy các tham số tìm kiếm
            String searchName = request.getParameter("searchName");
            String searchEmail = request.getParameter("searchEmail");
            String searchStatus = request.getParameter("searchStatus");
            
            // Lấy tham số pagination
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // Số user mỗi trang
            int pageSize = 15;
            
            List<User> userList;
            int totalUsers;
            int totalPages;
            
            // Sử dụng search với pagination
            userList = userService.searchUsersWithPagination(searchName, searchEmail, searchStatus, currentPage, pageSize);
            totalUsers = userService.countSearchResults(searchName, searchEmail, searchStatus);
            totalPages = (int) Math.ceil((double) totalUsers / pageSize);
            
            // Đảm bảo currentPage không vượt quá totalPages
            if (totalPages > 0 && currentPage > totalPages) {
                currentPage = totalPages;
                userList = userService.searchUsersWithPagination(searchName, searchEmail, searchStatus, currentPage, pageSize);
            }
            
            // Đặt danh sách user vào request attribute
            request.setAttribute("userList", userList);

            // Lấy danh sách khóa học đã đăng ký của từng user
            Map<Integer, List<Course>> userCoursesMap = new HashMap<>();
            for (User user : userList) {
                List<Course> courses = userCourseService.getCoursesByUserId(user.getIdUser());
                System.out.println("User " + user.getIdUser() + " courses: " + courses);
                userCoursesMap.put(user.getIdUser(), courses);
            }
            request.setAttribute("userCoursesMap", userCoursesMap);
            
            // Đặt thông tin pagination
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("pageSize", pageSize);
            
            // Đặt lại các giá trị tìm kiếm để hiển thị trong form
            request.setAttribute("searchName", searchName != null ? searchName : "");
            request.setAttribute("searchEmail", searchEmail != null ? searchEmail : "");
            request.setAttribute("searchStatus", searchStatus != null ? searchStatus : "");
            
            // Xử lý thông báo từ URL parameter
            String error = request.getParameter("error");
            String message = request.getParameter("message");
            if (error != null && !error.isEmpty()) {
                request.setAttribute("error", error);
            }
            if (message != null && !message.isEmpty()) {
                request.setAttribute("message", message);
            }
            
            // Forward đến trang manageUser.jsp
            request.getRequestDispatcher("/views/admin/user/manageUser.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi, vẫn forward nhưng với danh sách rỗng
            request.setAttribute("userList", null);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalUsers", 0);
            request.setAttribute("pageSize", 15);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách người dùng: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/user/manageUser.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            handleDeleteUser(request, response);
        } else if ("update".equals(action)) {
            handleUpdateUser(request, response);
        } else if ("add".equals(action)) {
            handleAddUser(request, response);
        } else {
            // Nếu không có action, chuyển về doGet
            doGet(request, response);
        }
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean success = userService.removeUser(userId);
            
            if (success) {
                request.setAttribute("message", "Xóa người dùng thành công!");
            } else {
                request.setAttribute("error", "Không thể xóa người dùng!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID người dùng không hợp lệ!");
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Redirect về trang quản lý user
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String avatar = request.getParameter("avatar");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            boolean active = "true".equals(request.getParameter("active"));
            boolean isAdmin = "true".equals(request.getParameter("isAdmin"));
            
            User user = userService.getUserById(userId);
            if (user != null) {
                user.setFirstName(firstName);
                user.setLastName(lastName);
                user.setEmail(email);
                user.setAvatar(avatar);
                user.setPhone(phone);
                user.setGender(gender);
                user.setActive(active);
                user.setIsAdmin(isAdmin);
                
                boolean success = userService.updateUser(user);
                if (success) {
                    request.setAttribute("message", "Cập nhật người dùng thành công!");
                } else {
                    request.setAttribute("error", "Không thể cập nhật người dùng!");
                }
            } else {
                request.setAttribute("error", "Không tìm thấy người dùng!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID người dùng không hợp lệ!");
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Redirect về trang quản lý user
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void handleAddUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String birthday = request.getParameter("birthday");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String avatar = request.getParameter("avatar");
            boolean active = "true".equals(request.getParameter("active"));
            boolean isAdmin = "true".equals(request.getParameter("isAdmin"));

            // Kiểm tra trường bắt buộc
            if (username == null || username.isEmpty() || password == null || password.isEmpty() || email == null || email.isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập, email và mật khẩu!");
                response.sendRedirect(request.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Vui lòng nhập đầy đủ tên đăng nhập, email và mật khẩu!", "UTF-8"));
                return;
            }
            // Parse birthday
            java.sql.Date birthdayDate = null;
            if (birthday != null && !birthday.isEmpty()) {
                try {
                    birthdayDate = java.sql.Date.valueOf(birthday);
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Ngày sinh không hợp lệ!", "UTF-8"));
                    return;
                }
            }
            // Tạo user mới
            User user = new User();
            // Nếu username trống, tạo username từ email
            if (username == null || username.trim().isEmpty()) {
                username = email.split("@")[0]; // Lấy phần trước @ của email
            }
            
            // Kiểm tra username đã tồn tại chưa
            if (userService.isUsernameTaken(username)) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Tên đăng nhập đã được sử dụng!", "UTF-8"));
                return;
            }
            
            user.setUsername(username);
            user.setPassword(password);
            user.setEmail(email);
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setBirthday(birthdayDate);
            user.setPhone(phone);
            user.setGender(gender);
            user.setAvatar(avatar);
            user.setActive(active);
            user.setIsAdmin(isAdmin);
            
            // Tự động tạo createdAt và updatedAt
            Date now = new Date();
            user.setCreatedAt(now);
            user.setUpdatedAt(now);
            
            User createdUser = userService.createUser(user);
            if (createdUser != null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?message=" + java.net.URLEncoder.encode("Thêm người dùng thành công!", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Không thể thêm người dùng!", "UTF-8"));
            }
            
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Có lỗi xảy ra: " + e.getMessage(), "UTF-8"));
        }
    }
    
    private void handleGetUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            User user = userService.getUserById(userId);
            
            if (user != null) {
                // Trả về JSON response
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                String jsonResponse = String.format(
                    "{\"id\":%d,\"firstName\":\"%s\",\"lastName\":\"%s\",\"email\":\"%s\",\"avatar\":\"%s\",\"phone\":\"%s\",\"gender\":\"%s\",\"active\":%s,\"isAdmin\":%s}",
                    user.getIdUser(),
                    user.getFirstName() != null ? user.getFirstName() : "",
                    user.getLastName() != null ? user.getLastName() : "",
                    user.getEmail() != null ? user.getEmail() : "",
                    user.getAvatar() != null ? user.getAvatar() : "",
                    user.getPhone() != null ? user.getPhone() : "",
                    user.getGender() != null ? user.getGender() : "",
                    user.getActive() != null ? user.getActive().toString() : "false",
                    user.getIsAdmin() != null ? user.getIsAdmin().toString() : "false"
                );
                
                response.getWriter().write(jsonResponse);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }
} 