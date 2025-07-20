package com.controller.admin;

import com.service.Course.CourseService;
import com.model.Course;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@WebServlet(name = "CourseManageServlet", urlPatterns = {"/admin/courses"})
public class CourseManageServlet extends HttpServlet {

    private final CourseService courseService;

    public CourseManageServlet() {
        this.courseService = new CourseService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Kiểm tra nếu có action=getCourse để lấy thông tin course chi tiết
            String action = request.getParameter("action");
            if ("getCourse".equals(action)) {
                handleGetCourse(request, response);
                return;
            }
            
            // Lấy các tham số tìm kiếm
            String searchName = request.getParameter("searchName");
            String searchCategory = request.getParameter("searchCategory");
            String searchPrice = request.getParameter("searchPrice");
            System.out.println("[DEBUG] searchName=" + searchName + ", searchCategory=" + searchCategory + ", searchPrice=" + searchPrice);
            
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
            
            // Số course mỗi trang
            int pageSize = 15;
            
            List<Course> courseList;
            int totalCourses;
            int totalPages;
            
            // Sử dụng search với pagination
            courseList = courseService.searchCoursesWithPagination(searchName, searchCategory, searchPrice, currentPage, pageSize);
            totalCourses = courseService.countSearchResults(searchName, searchCategory, searchPrice);
            totalPages = (int) Math.ceil((double) totalCourses / pageSize);
            
            // Đảm bảo currentPage không vượt quá totalPages
            if (totalPages > 0 && currentPage > totalPages) {
                currentPage = totalPages;
                courseList = courseService.searchCoursesWithPagination(searchName, searchCategory, searchPrice, currentPage, pageSize);
            }
            
            // Đặt danh sách course vào request attribute
            request.setAttribute("courseList", courseList);
            
            // Đặt thông tin pagination
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCourses", totalCourses);
            request.setAttribute("pageSize", pageSize);
            
            // Đặt lại các giá trị tìm kiếm để hiển thị trong form
            request.setAttribute("searchName", searchName != null ? searchName : "");
            request.setAttribute("searchCategory", searchCategory != null ? searchCategory : "");
            request.setAttribute("searchPrice", searchPrice != null ? searchPrice : "");
            
            // Xử lý thông báo từ URL parameter
            String error = request.getParameter("error");
            String message = request.getParameter("message");
            if (error != null && !error.isEmpty()) {
                request.setAttribute("error", error);
            }
            if (message != null && !message.isEmpty()) {
                request.setAttribute("message", message);
            }
            
            // Forward đến trang manageCourse.jsp
            request.getRequestDispatcher("/views/admin/course/manageCourse.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi, vẫn forward nhưng với danh sách rỗng
            request.setAttribute("courseList", null);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalCourses", 0);
            request.setAttribute("pageSize", 15);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách khóa học: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/course/manageCourse.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            handleDeleteCourse(request, response);
        } else if ("update".equals(action)) {
            handleUpdateCourse(request, response);
        } else if ("add".equals(action)) {
            handleAddCourse(request, response);
        } else {
            // Nếu không có action, chuyển về doGet
            doGet(request, response);
        }
    }

    private void handleDeleteCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            boolean success = courseService.removeCourse(courseId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/courses?message=" + java.net.URLEncoder.encode("Xóa khóa học thành công!", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Không thể xóa khóa học!", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("ID khóa học không hợp lệ!", "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Có lỗi xảy ra: " + e.getMessage(), "UTF-8"));
        }
    }

    private void handleUpdateCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String priceStr = request.getParameter("price");
            String duration = request.getParameter("duration");
            String description = request.getParameter("description");
            String frequency = request.getParameter("frequency");
            String imageUrl = request.getParameter("imageUrl");
            
            // Kiểm tra trường bắt buộc
            if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Vui lòng nhập đầy đủ tên và giá khóa học!", "UTF-8"));
                return;
            }
            
            BigDecimal price = null;
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try {
                    price = new BigDecimal(priceStr);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Giá không hợp lệ!", "UTF-8"));
                    return;
                }
            }
            
            Course course = courseService.getCourseById(courseId);
            if (course != null) {
                course.setName(name);
                course.setCategory(category);
                course.setPrice(price);
                course.setDuration(duration);
                course.setDescription(description);
                course.setFrequency(frequency);
                course.setImageUrl(imageUrl);
                course.setUpdatedAt(new Date());
                
                boolean success = courseService.updateCourse(course);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/courses?message=" + java.net.URLEncoder.encode("Cập nhật khóa học thành công!", "UTF-8"));
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Không thể cập nhật khóa học!", "UTF-8"));
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Không tìm thấy khóa học!", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("ID khóa học không hợp lệ!", "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Có lỗi xảy ra: " + e.getMessage(), "UTF-8"));
        }
    }

    private void handleAddCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String priceStr = request.getParameter("price");
            String duration = request.getParameter("duration");
            String description = request.getParameter("description");
            String frequency = request.getParameter("frequency");
            String imageUrl = request.getParameter("imageUrl");

            if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Vui lòng nhập đầy đủ tên và giá khóa học!", "UTF-8"));
                return;
            }
            
            BigDecimal price = null;
            try {
                price = new BigDecimal(priceStr);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Giá khóa học không hợp lệ!", "UTF-8"));
                return;
            }
            
            Course newCourse = new Course();
            newCourse.setName(name);
            newCourse.setCategory(category);
            newCourse.setPrice(price);
            newCourse.setDuration(duration);
            newCourse.setDescription(description);
            newCourse.setFrequency(frequency);
            newCourse.setImageUrl(imageUrl);
            newCourse.setCreatedAt(new java.util.Date());
            
            // Lưu course
            try {
                courseService.addCourse(newCourse);
                response.sendRedirect(request.getContextPath() + "/admin/courses?message=" + java.net.URLEncoder.encode("Thêm khóa học thành công!", "UTF-8"));
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Lỗi khi thêm khóa học: " + e.getMessage(), "UTF-8"));
            }
            
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=" + java.net.URLEncoder.encode("Có lỗi xảy ra: " + e.getMessage(), "UTF-8"));
        }
    }
    
    private void handleGetCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            Course course = courseService.getCourseById(courseId);
            
            if (course != null) {
                // Trả về JSON response
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                String jsonResponse = String.format(
                    "{\"id\":%d,\"name\":\"%s\",\"category\":\"%s\",\"price\":\"%s\",\"duration\":\"%s\",\"description\":\"%s\",\"frequency\":\"%s\",\"imageUrl\":\"%s\"}",
                    course.getIdCourse(),
                    course.getName() != null ? course.getName().replace("\"", "\\\"") : "",
                    course.getCategory() != null ? course.getCategory().replace("\"", "\\\"") : "",
                    course.getPrice() != null ? course.getPrice().toString() : "",
                    course.getDuration() != null ? course.getDuration().replace("\"", "\\\"") : "",
                    course.getDescription() != null ? course.getDescription().replace("\"", "\\\"").replace("\n", "\\n") : "",
                    course.getFrequency() != null ? course.getFrequency().replace("\"", "\\\"") : "",
                    course.getImageUrl() != null ? course.getImageUrl().replace("\"", "\\\"") : ""
                );
                
                response.getWriter().write(jsonResponse);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid course ID");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }
} 