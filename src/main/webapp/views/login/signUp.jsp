<%-- 
    Document   : signUp
    Created on : Jun 7, 2025, 11:09:00 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sign up Page</title>
        <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    </head>
    <body>
        <section class="py-3 py-md-5 py-xl-8">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-12 col-lg-8 col-xl-6">
                        <div class="mb-5">
                            <h2 class="display-5 fw-bold text-center">Sign Up</h2>
                            <p class="text-center m-0">Already have an account? <a href="login.jsp">Sign in</a></p>
                        </div>
                        <form action="<%=request.getContextPath()%>/SignupServlet" method="POST">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                            </div>
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <div class="mb-3">
                                <label for="repass" class="form-label">Confirm Password</label>
                                <input type="password" class="form-control" id="repass" name="repass" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Sign Up</button>
                            <p class="text-danger">${mess}</p>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </body>
</html>
