<%-- 
    Document   : resetPassword
    Created on : Jul 2, 2025, 4:06:24 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Reset password</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
            }
        </style>
    </head>
    <body class="bg-gray-50 min-h-screen flex items-center justify-center">
        <div class="fixed inset-0 -z-10 flex items-center justify-center">
            <img src="/assets/calendar-bg.jpg" alt="background" class="w-full h-full object-cover opacity-30">
        </div>
        <div class="relative z-10 flex flex-col items-center justify-center w-full min-h-screen">
            <div class="bg-white rounded-2xl shadow-xl px-8 py-10 w-full max-w-md flex flex-col items-center">
                <div class="flex flex-col items-center mb-6">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#222" class="w-12 h-12 mb-2">
                        <jsp:include page="../../assets/Key.svg" />
                    </svg>
                    <h2 class="text-2xl font-bold text-gray-900 text-center">Set new password</h2>
                    <p class="text-gray-500 text-center text-sm mt-1">Your new password must be different to previously used passwords.</p>
                </div>
                <form action="resetPassword" method="POST" class="w-full flex flex-col gap-4">
                    <input type="hidden" class="form-control" value="${email}" name="email" id="email" />
                    <div class="flex flex-col gap-1">
                        <div class="relative">
                            <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#a3a3a3" class="w-5 h-5">
                                    <jsp:include page="../../assets/Key.svg" />
                                </svg>
                            </span>
                            <input type="password" name="password" id="password" placeholder="Password" required minlength="8"
                                   class="pl-10 pr-3 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-400 focus:outline-none w-full text-gray-900 placeholder-gray-400 text-base">
                        </div>
                        <span class="text-xs text-gray-400 ml-1">Must be at least 8 characters.</span>
                    </div>
                    <div class="flex flex-col gap-1">
                        <div class="relative">
                            <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#a3a3a3" class="w-5 h-5">
                                  <jsp:include page="../../assets/Key.svg" />
                                </svg>
                            </span>
                            <input type="password" name="confirm_password" id="confirm_password" placeholder="Repeat Password" required minlength="8"
                                   class="pl-10 pr-3 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-400 focus:outline-none w-full text-gray-900 placeholder-gray-400 text-base">
                        </div>
                    </div>
                    <button type="submit" class="mt-2 bg-blue-500 hover:bg-blue-600 text-white font-semibold py-3 rounded-lg transition-colors w-full">Reset password</button>
                    <p class="text-red-500 text-center text-sm mt-2">${mess}</p>
                </form>
                <div class="mt-6 text-center">
                    <a href="login.jsp" class="text-gray-500 hover:text-blue-600 text-sm transition">&larr; Back to <span class="font-semibold">Log In</span></a>
                </div>
            </div>
        </div>
    </body>
</html>
