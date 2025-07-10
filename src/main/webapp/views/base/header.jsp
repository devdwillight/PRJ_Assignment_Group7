<%-- 
    Document   : header
    Created on : Jun 14, 2025, 9:29:43 AM
    Author     : DELL
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.model.User" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JiKan Calendar</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://unpkg.com/flowbite@1.3.3/dist/flowbite.min.css" />
        <script src="https://unpkg.com/flowbite@1.3.3/dist/flowbite.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <%
        User user = (User) request.getSession().getAttribute("user");
    %>
    <body>
        <nav class="flex items-center justify-between px-32 py-4 bg-white">
            <!-- Logo -->
            <div class="flex items-center">
                <a href="" class="text-3xl font-extrabold text-blue-400">JiKan</a>
            </div>
            <div class="flex items-center space-x-4">
                <!-- Menu -->
                <div class="flex space-x-8 pr-12">
                    <a href="/" class="text-blue-400 font-bold hover:underline item-header-link">HOME</a>
                    <a href="/features" class="text-blue-400 font-bold hover:underline item-header-link">FEATURES</a>
                    <a href="/pricing" class="text-blue-400 font-bold hover:underline item-header-link">PRICING</a>
                    <a href="/contact" class="text-blue-400 font-bold hover:underline item-header-link">CONTACT</a>
                </div>
                <!-- User/Sign in -->
                <c:choose>
                    <c:when test="${user != null}">
                        <!-- Avatar + Dropdown -->
                        <button type="button" class="flex text-sm bg-gray-800 rounded-full focus:ring-4 focus:ring-gray-300" id="user-menu-button" aria-expanded="false" data-dropdown-toggle="dropdown">
                            <span class="sr-only">Open user menu</span>
                            <img class="w-8 h-8 rounded-full" src='<%=user.getAvatar() != null ? "assets/images/user/" + user.getAvatar() : "/assets/images/default.png"%>' alt="user photo" id="headerAvatar">
                        </button>
                        <div class="hidden z-50 my-4 text-base list-none bg-white rounded divide-y divide-gray-100 shadow" id="dropdown">
                            <div class="py-3 px-4">
                                <span class="block text-sm text-gray-900"><%=user.getUsername()%></span>
                                <span class="block text-sm font-medium text-gray-500 truncate"><%=user.getEmail()%></span>
                            </div>
                            <ul class="py-1" aria-labelledby="dropdown">
                                <li>
                                    <a href="/profile" class="block py-2 px-4 text-md hover:bg-gray-100">Profile</a>
                                </li>
                                <li>
                                    <a href="/logout" class="block py-2 px-4 text-md hover:bg-gray-100">Sign out</a>
                                </li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="/" class="text-gray-400 font-bold mr-2 hover:text-gray-500 transition">LOGIN IN</a>
                        <a href="/login" class="text-white bg-blue-400 px-6 py-3 rounded-xl font-bold hover:bg-blue-500 transition">SIGN IN</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
        <script>
            // Highlight current menu
            $(".item-header-link").each(function () {
                if ($(this).attr('href') == location.pathname) {
                    $(this).addClass("md:bg-transparent text-blue-700");
                } else {
                    $(this).addClass("hover:bg-gray-50 md:hover:bg-transparent md:border-0 md:hover:text-blue-700");
                }
            });
        </script>
    </body>
</html>