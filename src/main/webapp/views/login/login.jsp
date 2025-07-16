<%-- Document : login Created on : Jul 10, 2025, 1:25:59 PM Author : DELL --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Log In</title>
        <!-- Tailwind CDN -->
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <%
        if (session != null && session.getAttribute("user_email") != null) {
            // Nếu đã đăng nhập thì chuyển hướng đến trang home.jsp
            response.sendRedirect(request.getContextPath() + "home");
            return; // Dừng lại, không cần tiếp tục xử lý trong trang login.jsp
        }
    %>
    <body class="min-h-screen flex items-center justify-center bg-white">
        <div class="w-full h-screen flex">
            <!-- Left: Login Form -->
            <div class="w-full md:w-1/2 flex flex-col justify-center items-center px-8 bg-white">
                <div class="w-full max-w-md">
                    <h2 class="text-3xl font-bold mb-8">Log In</h2>
                    <form name="login" method="post" action="<%=request.getContextPath()%>/login">
                        <input type="hidden" name="action" value="login" />
                        <div class="mb-4">
                            <div
                                class="flex items-center border border-gray-300 rounded-lg px-3 py-2 bg-white focus-within:ring-2 focus-within:ring-blue-400 gap-2">
                                <!-- User Icon -->
                                <jsp:include page="../../assets/User.svg" />
                                <input type="email" placeholder="Your email" name="email" id="email"
                                       class="w-full outline-none bg-transparent" required 
                                       <% Cookie[] cookies = request.getCookies();
                                           if (cookies != null) {
                                               for (Cookie cookie
                                                       : cookies) {
                                                   if ("user_email".equals(cookie.getName())) {
                                                       out.print("value='" + cookie.getValue() + "'");
                                                   }
                                               }
                                           }
                                       %>
                                       />
                            </div>
                        </div>
                        <div class=" mb-2">
                            <div
                                class="flex items-center border border-gray-300 rounded-lg px-3 py-2 bg-white focus-within:ring-2 focus-within:ring-blue-400 gap-2">
                                <!-- Key Icon -->
                                <jsp:include page="../../assets/Key.svg" />
                                <input type="password" placeholder="Password"
                                       class="w-full outline-none bg-transparent" name="password" id="password"  required
                                       <%
                                           // Xóa value="" cố định và thay bằng logic đọc cookie
                                           if (cookies != null) {
                                               for (Cookie cookie : cookies) {
                                                   if ("user_password".equals(cookie.getName())) {
                                                       out.print("value='" + cookie.getValue() + "'");
                                                       break; // Thoát khỏi vòng lặp khi tìm thấy
                                                   }
                                               }
                                           }
                                       %> />
                            </div>
                        </div>
                        <div class="flex items-center justify-between mb-4 px-2" >
                            <div class="flex items-center">
                                <!--  Remember me -->
                                <input id="remember_me" name="remember_me" type="checkbox" class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                                <label for="remember_me" class="ml-2 block text-sm text-gray-700 select-none cursor-pointer">Remember me</label>
                            </div>
                            <!--Forgot Password-->
                            <a href="requestPassword" class="text-blue-400 text-sm hover:underline">Forgot password?</a>
                        </div>
                           <%-- Hiển thị thông báo lỗi đẹp --%>
                            <c:if test="${not empty mess}">
                                <span class="block text-xs text-red-500 mt-1">${mess}</span>
                            </c:if>
                        <!--Login-->
                        <button type="submit" class="w-full bg-blue-500 text-white py-3 rounded-lg font-semibold hover:bg-blue-600 transition mb-4">Log In</button>
                    </form>
                    <div class="flex items-center my-4">
                        <div class="flex-grow h-px bg-gray-200"></div>
                        <span class="mx-2 text-gray-400">or</span>
                        <div class="flex-grow h-px bg-gray-200"></div>
                    </div>
                    <a
                        href="https://accounts.google.com/o/oauth2/auth?scope=email
                        profile openid&redirect_uri=http://localhost:9999/PRJ_Assignment_toidaiii/login&response_type=code&client_id=1097365484665-9av0b9o7gjpq7j5co0ecf8dbipsbpvkd.apps.googleusercontent.com&prompt=consent"
                        class="w-full flex items-center justify-center border py-3 rounded-lg hover:bg-gray-100 transition mb-6">
                        <!--Icon logo Google-->
                        <img src="<%=request.getContextPath()%>/assets/Google.svg" alt="Google" class="w-5 h-5 mr-2">
                        Google
                    </a>
                    
                    <div class="text-center text-gray-500 text-sm">
                        Don’t have an account?
                        <a href="signup" class="text-blue-500 font-semibold hover:underline">Sign Up</a>
                    </div>
                        <div class="mt-6 text-center">
                    <a href="jikan" class="text-gray-500 hover:text-blue-600 text-sm transition">&larr; Back to <span class="font-semibold">Jikan</span></a>
                </div>
                </div>
            </div>
            <!-- Right: Full Background Image with Quote -->
            <div class="hidden md:flex w-1/2 h-full relative items-center justify-center
                 bg-[url('<%=request.getContextPath()%>/assets/table-bg.jpg')]
                 bg-cover bg-center">
                <div class="absolute inset-0 bg-white bg-opacity-20"></div>
                <div class="relative z-10 w-4/5 mx-auto text-center">
                    <span class="text-6xl text-gray-200 absolute -mt-8 -ml-8 select-none left-0 top-0">“</span>
                    <p class="text-2xl font-light text-gray-700 mb-2 leading-snug mt-8">
                        Time stays <span class="font-semibold text-blue-500">long enough</span> for anyone who
                        will <span class="font-semibold text-blue-500">use it</span>.
                    </p>
                    <p class="text-right text-gray-600 mt-4 font-medium">– Leonardo da Vinci</p>
                </div>
            </div>
        </div>
    </body>

</html>