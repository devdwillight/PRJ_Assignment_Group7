<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home Page</title>
        <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    </head>
    <body>
        <!-- Header -->
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container">
                <a class="navbar-brand" href="#">Employee Portal</a>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item">
                            <span class="nav-link">Welcome, 
                                <%= session.getAttribute("googleName") != null ? session.getAttribute("googleName") : (session.getAttribute("user_email") != null ? session.getAttribute("user_email") : "Guest")%>
                            </span>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Main content -->
        <section class="py-5">
            <div class="container">
                <h1 class="display-4 text-center">Welcome to the Employee Portal</h1>
                <p class="text-center">This is a secure page that only employees can access after logging in.</p>
            </div>
        </section>

        <!-- Logout Form -->
        <form action="logout" method="POST">
            <input type="hidden" name="action" value="logout" />
            <input type="submit" value="Logout" class="btn btn-danger" />
        </form>
    </body>
</html>
