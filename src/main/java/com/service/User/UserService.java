/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.service.User;

import com.dao.User.UserDAO;
import com.model.User;
import java.util.List;

/**
 *
 * @author DELL
 */
public class UserService implements IUserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    @Override
    public User createUser(User user) {
        System.out.println("[createUser] → Kiểm tra email đã tồn tại: " + user.getEmail());

        if (userDAO.existsByEmail(user.getEmail())) {
            System.out.println("[createUser] ✖ Email đã được sử dụng.");
            throw new IllegalArgumentException("Email đã được sử dụng.");
        }

        if (!userDAO.insertUser(user)) {
            System.out.println("[createUser] ✖ Lỗi khi lưu người dùng.");
            throw new RuntimeException("Không thể tạo người dùng.");
        }

        System.out.println("[createUser] ✔ Tạo người dùng thành công: " + user);
        return user;
    }

    @Override
    public User getUserById(int id) {
        System.out.println("[getUserById] → ID: " + id);
        User user = userDAO.selectUserByID(id);
        if (user != null) {
            System.out.println("[getUserById] ✔ Tìm thấy: " + user);
        } else {
            System.out.println("[getUserById] ✖ Không tìm thấy người dùng.");
        }
        return user;
    }

    @Override
    public User getUserByEmail(String email) {
        System.out.println("[getUserByEmail] → Email: " + email);
        User user = userDAO.selectUserByEmail(email);
        if (user != null) {
            System.out.println("[getUserByEmail] ✔ Tìm thấy: " + user);
        } else {
            System.out.println("[getUserByEmail] ✖ Không tìm thấy.");
        }
        return user;
    }

    @Override
    public List<User> getAllUsers() {
        System.out.println("[getAllUsers] → Đang lấy danh sách tất cả người dùng...");
        List<User> users = userDAO.selectAllUsers();
        System.out.println("[getAllUsers] ✔ Tổng số: " + users.size());
        return users;
    }

    @Override
    public List<User> getUsersByPage(int pageNumber, int pageSize) {
        System.out.println("[getUsersByPage] → Trang: " + pageNumber + ", Kích thước: " + pageSize);
        List<User> users = userDAO.selectUserByPage(pageNumber, pageSize);
        System.out.println("[getUsersByPage] ✔ Trả về " + users.size() + " người dùng.");
        return users;
    }

    @Override
    public boolean updateUser(User user) {
        System.out.println("[updateUser] → ID: " + user.getIdUser());

        if (!userDAO.existsByID(user.getIdUser())) {
            System.out.println("[updateUser] ✖ Người dùng không tồn tại.");
            return false;
        }

        boolean result = userDAO.updateUser(user);
        System.out.println(result ? "[updateUser] ✔ Cập nhật thành công." : "[updateUser] ✖ Lỗi cập nhật.");
        return result;
    }

    @Override
    public boolean removeUser(int id) {
        System.out.println("[removeUser] → Xóa người dùng với ID: " + id);

        if (!userDAO.existsByID(id)) {
            System.out.println("[removeUser] ✖ Không tồn tại người dùng cần xóa.");
            return false;
        }

        boolean result = userDAO.deleteUser(id);
        System.out.println(result ? "[removeUser] ✔ Đã xóa thành công." : "[removeUser] ✖ Xóa thất bại.");
        return result;
    }

    @Override
    public boolean isEmailTaken(String email) {
        boolean exists = userDAO.existsByEmail(email);
        System.out.println("[isEmailTaken] → Email " + email + " đã " + (exists ? "tồn tại." : "chưa được sử dụng."));
        return exists;
    }

    @Override
    public boolean isUsernameTaken(String username) {
        boolean exists = userDAO.existsByUsername(username);
        System.out.println("[isUsernameTaken] → Username " + username + " đã " + (exists ? "tồn tại." : "chưa được sử dụng."));
        return exists;
    }

    @Override
    public boolean isUserExists(int id) {
        boolean exists = userDAO.existsByID(id);
        System.out.println("[isUserExists] → Người dùng với ID " + id + (exists ? " tồn tại." : " không tồn tại."));
        return exists;
    }

    @Override
    public int countUsers() {
        int count = userDAO.countUser();
        System.out.println("[countUsers] → Tổng số người dùng: " + count);
        return count;
    }

    @Override
    public int countUsersByMonth(int year, int month) {
        int count = userDAO.countUsersByMonth(year, month);
        System.out.println("[countUsersByMonth] → Tháng " + month + "/" + year + ": " + count + " người dùng");
        return count;
    }

    @Override
    public List<User> searchUsers(String name, String email, String status) {
        System.out.println("[searchUsers] → Tìm kiếm: name=" + name + ", email=" + email + ", status=" + status);
        List<User> users = userDAO.searchUsers(name, email, status);
        System.out.println("[searchUsers] ✔ Tìm thấy " + users.size() + " kết quả");
        return users;
    }

    @Override
    public List<User> searchUsersWithPagination(String name, String email, String status, int pageNumber, int pageSize) {
        System.out.println("[searchUsersWithPagination] → Tìm kiếm: name=" + name + ", email=" + email + ", status=" + status + ", page=" + pageNumber + ", size=" + pageSize);
        List<User> users = userDAO.searchUsersWithPagination(name, email, status, pageNumber, pageSize);
        System.out.println("[searchUsersWithPagination] ✔ Trả về " + users.size() + " kết quả");
        return users;
    }

    @Override
    public int countSearchResults(String name, String email, String status) {
        System.out.println("[countSearchResults] → Đếm kết quả: name=" + name + ", email=" + email + ", status=" + status);
        int count = userDAO.countSearchResults(name, email, status);
        System.out.println("[countSearchResults] ✔ Tổng số: " + count);
        return count;
    }

    @Override
    public void updatePassword(String email, String passWord) {
        userDAO.updatePassword(email, passWord);
    }

    @Override
    public User checkLogin(String email, String password) {
        System.out.println("[checkLogin] Đang kiểm tra đăng nhập cho: " + email);
        User user = userDAO.checkLogin(email, password);

        if (user == null) {
            System.out.println("[checkLogin] ✖ Sai email hoặc mật khẩu");
        } else if (Boolean.FALSE.equals(user.getActive())) {
            System.out.println("[checkLogin] ✖ Tài khoản chưa kích hoạt");
            return null;
        } else {
            System.out.println("[checkLogin] ✔ Đăng nhập thành công");
        }

        return user;
    }

    public static void main(String[] args) {
        UserService userService = new UserService();

        String email = "nguyenhuuminhtuan20111@gmail.com";
        String password = "123";

        userService.checkLogin(email, password);
    }
}
