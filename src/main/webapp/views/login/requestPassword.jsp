<%-- 
    Document   : requestPassword
    Created on : Jul 2, 2025, 4:06:36 PM
    Author     : ADMIN
--%>

<%-- 
    Document   : requestPassword
    Created on : Jul 2, 2025, 4:06:36 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quên mật khẩu</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body>
        <section class="min-h-screen flex items-center justify-center bg-cover bg-center bg-no-repeat" style="background-image: url('${pageContext.request.contextPath}/assets/calendar-bg.jpg');">
            <div class="bg-white rounded-xl shadow-lg px-8 py-10 w-full max-w-md mx-auto flex flex-col items-center">
                <div class="flex flex-col items-center mb-6">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-12 h-12 mb-2 text-black">
                    <jsp:include page="../../assets/Key.svg" />
                    </svg>
                    <h2 class="text-2xl font-bold text-center">Forgot Password?</h2>
                    <p class="text-gray-500 text-center text-sm mt-1">No worries, we'll send you reset instructions.</p>
                </div>
                <form action="<%=request.getContextPath()%>/requestPassword" method="POST" class="w-full flex flex-col gap-4">
                    <div class="w-full">
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Your email</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                                  <jsp:include page="../../assets/EmailLog.svg" />
                            </span>
                            <input type="email" name="email" id="email" placeholder="Your email" required class="pl-10 pr-4 py-2 border border-gray-300 rounded-md w-full focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-blue-400 transition" />
                        </div>
                    </div>
                    <button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 rounded-md transition">Reset password</button>
                </form>
                <p class="text-red-500 text-center mt-3">${mess}</p>
                <div class="mt-6 text-center">
                    <a href="login.jsp" class="text-gray-500 hover:text-blue-600 text-sm transition">&larr; Back to <span class="font-semibold">Log In</span></a>
                </div>
            </div>
        </section>
    </body>
</html>