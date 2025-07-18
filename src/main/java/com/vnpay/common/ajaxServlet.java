/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.vnpay.common;

import com.dao.Order.OrderDAO;
import com.model.User;
import com.service.Order.OrderService;
import com.service.UserCourse.UserCourseService;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.model.Orders;
import com.model.User;
import com.service.Order.OrderService;
import java.math.BigDecimal;

/**
 *
 * @author CTT VNPAY
 */
@WebServlet(name = "ajaxServlet", urlPatterns = {"/payment"})
public class ajaxServlet extends HttpServlet {

    OrderService orderService = new OrderService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String bankCode = req.getParameter("bankCode");
        String courseIdStr = req.getParameter("courseId");

        if (req.getParameter("totalBill") == null) {
            resp.sendRedirect("cart");//create cart servlet
            return;
        }

        double amountDouble = Double.parseDouble(req.getParameter("totalBill"));

        // Lấy user_id từ session thay vì gán cứng
        HttpSession session = req.getSession(false); // không tạo mới để tránh session rác
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("views/login/login.jsp");
            return;
        }

        // ====== BẮT ĐẦU CHÈN ĐOẠN CHECK USER ĐÃ MUA CHƯA ======
        UserCourseService userCourseService = new UserCourseService();
        int courseId = Integer.parseInt(courseIdStr);

        if (userCourseService.isUserEnrolled(user.getIdUser(), courseId)) {
            req.setAttribute("mess", "Bạn đã mua khóa học này rồi!");
            req.getRequestDispatcher("views/vnpay/payment.jsp").forward(req, resp);
            return;
        }
        // ====== KẾT THÚC ĐOẠN CHECK ======

        Orders order = new Orders();
        order.setPaymentTime(new java.util.Date());
        order.setPaymentMethod("VNPAY");
        order.setIdUser(user);
        order.setStatus("Processing");
        order.setTotalAmount(amountDouble);

        if (orderService.createOrder(order) == null) {
            resp.getWriter().println("Không thể tạo đơn hàng");
            return;
        }

        int orderId = order.getIdOrder();

        if (orderId < 1) {
            resp.sendRedirect("Course");
            return;
        }
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String orderType = "other";

        long amount = (long) (amountDouble * 100000);
        String vnp_TxnRef = orderId + "_" + courseIdStr + "_" + System.currentTimeMillis();
        String vnp_IpAddr = Config.getIpAddress(req);

        String vnp_TmnCode = Config.vnp_TmnCode;

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");

        if (bankCode != null && !bankCode.isEmpty()) {
            vnp_Params.put("vnp_BankCode", bankCode);
        }
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
        vnp_Params.put("vnp_OrderType", orderType);

        String locate = req.getParameter("language");
        if (locate != null && !locate.isEmpty()) {
            vnp_Params.put("vnp_Locale", locate);
        } else {
            vnp_Params.put("vnp_Locale", "vn");
        }
        vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
        resp.sendRedirect(paymentUrl);
    }
}
