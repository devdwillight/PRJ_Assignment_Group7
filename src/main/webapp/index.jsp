<%-- 
    Document   : index
    Created on : Jun 21, 2025, 2:32:53 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <jsp:include page="views/base/header.jsp" />
    <body>
        <section id="home" class="relative w-full h-screen flex items-center justify-center bg-cover bg-center" style="background-image: url('assets/home-bg.jpg');">
            <div class="absolute inset-0 bg-black bg-opacity-80"></div>
            <div class="relative z-10 flex flex-col items-center text-center text-white px-4">
                <h1 class="text-4xl md:text-5xl font-bold mb-2 tracking-wide">JiKan</h1>
                <h2 class="text-xl md:text-2xl font-semibold mb-4">manage your time well</h2>
                <p class="italic text-base md:text-lg max-w-2xl mb-8">
                    Time is a priceless resource—free to everyone, yet impossible to own. You can spend it, use it, or waste it, but you can never store or retrieve it once it's gone. Every second matters, because lost time is lost forever.
                </p>
                <img src="assets/software-img.png" alt="JiKan App Screenshot" class="mx-auto w-full max-w-2xl" />
            </div>
        </section>
        <section id="features" class="bg-white py-16">
            <div class="max-w-6xl mx-auto px-4">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-12 text-center">
                    <!-- Course Scheduling -->
                    <div>
                        <div class="flex justify-center mb-4">
                            <!-- Calendar Icon SVG -->
                            <jsp:include page="/assets/Calendar.svg" />
                        </div>
                        <h3 class="font-bold text-lg mb-2">Course Scheduling</h3>
                        <p class="text-gray-500 text-sm">
                            Automatically sync your course enrollment with your calendar. Never miss a class – view, plan, and manage your entire learning journey in one place.
                        </p>
                    </div>
                    <!-- Collaboration -->
                    <div>
                        <div class="flex justify-center mb-4">
                            <!-- Share Icon SVG -->
                            <jsp:include page="/assets/Share.svg"/>
                        </div>
                        <h3 class="font-bold text-lg mb-2">Collaboration</h3>
                        <p class="text-gray-500 text-sm">
                            With shared calendars, everyone stays aligned — view common schedules, co-manage events, assign roles (view/edit), and avoid conflicts. Perfect for classrooms, project teams, or multi-user learning environments.
                        </p>
                    </div>
                    <!-- Task Management -->
                    <div>
                        <div class="flex justify-center mb-4">
                            <!-- Check Icon SVG -->
                            <jsp:include page="/assets/Checkcircle.svg"/>
                        </div>
                        <h3 class="font-bold text-lg mb-2">Task Management</h3>
                        <p class="text-gray-500 text-sm">
                            Create to-dos, assign deadlines, set priorities, and track progress — all directly within your calendar. Stay organized and focused with tasks that sync with your schedule.
                        </p>
                    </div>
                </div>
            </div>
        </section>
        <section id="ai" class="bg-[#f7f7f7] py-20">
            <div class="max-w-7xl mx-auto px-4 flex flex-col md:flex-row items-center gap-12">
                <!-- Left: Text content -->
                <div class="flex-1">
                    <h2 class="text-3xl md:text-4xl font-bold mb-4">AI Support Features</h2>
                    <p class="text-gray-500 text-base md:text-lg mb-6 max-w-xl">
                        Based on your availability, workload, and priorities, our intelligent engine suggests the most optimal time slots. Say goodbye to scheduling conflicts and decision fatigue.
                    </p>
                    <ul class="space-y-4">
                        <li class="flex items-center text-gray-700 text-base">
                            <span class="inline-flex items-center justify-center w-7 h-7 rounded-full bg-sky-100 mr-3">
                                <jsp:include page="assets/rightarrow.svg"/>
                            </span>
                            Let AI optimize your calendar for focus and balance.
                        </li>
                        <li class="flex items-center text-gray-700 text-base">
                            <span class="inline-flex items-center justify-center w-7 h-7 rounded-full bg-sky-100 mr-3">
                                <jsp:include page="assets/rightarrow.svg"/>
                            </span>
                            Smart time suggestions tailored to your day.
                        </li>
                        <li class="flex items-center text-gray-700 text-base">
                            <span class="inline-flex items-center justify-center w-7 h-7 rounded-full bg-sky-100 mr-3">
                                <jsp:include page="assets/rightarrow.svg"/>
                            </span>
                            Intelligent scheduling that adapts to your routine.
                        </li>
                    </ul>
                </div>
                <!-- Right: Placeholder for image or custom content -->
                <div class="flex-1 flex justify-center">
                    <div class="w-full max-w-md h-80 bg-white border border-gray-300 rounded-xl flex items-center justify-center">
                        <img src="assets/calendbot.png" alt="CalendBot" class="h-64"/>
                    </div>
                </div>
            </div>
        </section>
        <section id="pricing" class="bg-[#f9fbfd] py-20">
            <div class="max-w-6xl mx-auto px-4">
                <h2 class="text-3xl md:text-4xl font-bold text-center mb-12 tracking-wide">OUR PRICING</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-10">
                    <!-- Basic Plan -->
                    <div class="bg-white rounded-xl shadow-sm flex flex-col items-center pb-8">
                        <div class="w-full bg-sky-400 rounded-t-xl py-6 flex flex-col items-center">
                            <span class="text-white font-bold text-xl tracking-wider">BASIC PLAN</span>
                            <span class="text-white font-semibold text-base text-lg mt-1">FREE</span>
                        </div>
                        <ul class="text-black-700 text-center text-md mt-6 mb-8 space-y-4 px-6">
                            <li>Create & edit basic events</li>
                            <li>Daily/weekly/monthly views</li>
                            <li>One personal calendar</li>
                            <li>Basic Google/Outlook sync</li>
                        </ul>
                        <button class="border border-sky-400 text-sky-400 px-8 py-1 rounded transition hover:bg-sky-50 font-medium">SIGN UP</button>
                    </div>
                    <!-- Plus Plan -->
                    <div class="bg-white rounded-xl shadow-sm flex flex-col items-center pb-8">
                        <div class="w-full bg-sky-400 rounded-t-xl py-6 flex flex-col items-center">
                            <span class="text-white font-bold  text-xl tracking-wider">PLUS PLAN</span>
                            <span class="text-white font-bold text-base text-lg mt-1">$11</span>
                            <span class="text-white font-semibold text-xs">monthly</span>
                        </div>
                        <ul class="text-black-700 text-center text-md mt-6 mb-8 space-y-4 px-6">
                            <li>Includes everything in Free</li>
                            <li>Shared calendars</li>
                            <li>Smart scheduling suggestions (AI)</li>
                            <li>Multiple calendars</li>
                            <li>Full-featured mobile & desktop access</li>
                        </ul>
                        <button class="border border-sky-400 text-sky-400 px-8 py-1 rounded transition hover:bg-sky-50 font-medium">SIGN UP</button>
                    </div>
                    <!-- Pro Plan -->
                    <div class="bg-white rounded-xl shadow-sm flex flex-col items-center pb-8">
                        <div class="w-full bg-sky-400 rounded-t-xl py-6 flex flex-col items-center">
                            <span class="text-white font-bold  text-xl tracking-wider">Pro PLAN</span>
                            <span class="text-white font-bold text-base text-lg mt-1">$22</span>
                            <span class="text-white font-semibold text-xs">monthly</span>
                        </div>
                        <ul class="text-gray-700 text-center text-sm mt-6 mb-8 space-y-2 px-6">
                            <li>Includes everything in Pro</li>
                            <li>Group or departmental calendars</li>
                            <li>Permission management</li>
                            <li>Activity analytics</li>
                            <li>Integrations with Slack, Zoom, Google Meet</li>
                        </ul>
                        <button class="border border-sky-400 text-sky-400 px-8 py-1 rounded transition hover:bg-sky-50 font-medium">SIGN UP</button>
                    </div>
                </div>
            </div>
        </section>
        <section id="using" class="bg-[#f7f7f7] py-20">
            <div class="max-w-7xl mx-auto px-4 flex flex-col md:flex-row items-center gap-12">
                <!-- Left: Text content -->
                <div class="flex-1 flex flex-col items-center md:items-start text-center md:text-left">
                    <h2 class="text-3xl md:text-4xl font-bold mb-4 tracking-wide">USING OUR JiKan</h2>
                    <p class="text-gray-500 text-base md:text-lg mb-8 max-w-md">
                        Take control of your time with our intelligent calendar system — built for learners, teams, and professionals. From smart scheduling to shared calendars and task tracking, everything you need is just one click away.
                    </p>
                    <a href="login.jsp" class="bg-sky-400 hover:bg-sky-500 text-white font-bold px-10 py-3 rounded-xl transition w-48 text-center">
                        SIGN IN
                    </a>
                </div>
                <!-- Right: Image -->
                <div class="flex-1 flex justify-center">
                    <img src="assets/software-img.png" alt="JiKan App Screenshot" class="mx-auto w-full max-w-2xl" />
                </div>
            </div>
        </section>
        <section id="contact" class="relative w-full min-h-[600px] flex items-center justify-center bg-cover bg-center" style="background-image: url('assets/contact-bg.jpg');">
            <div class="absolute inset-0 bg-black bg-opacity-70"></div>
            <div class="relative z-10 w-full max-w-6xl mx-auto flex flex-col md:flex-row items-center justify-between px-4 py-20 gap-12">
                <!-- Left: Contact Info -->
                <div class="flex-1 text-white">
                    <h2 class="text-3xl md:text-4xl font-bold mb-4 text-center md:text-left">CONTACT US</h2>
                    <p class="mb-6 text-gray-200 text-base md:text-lg text-center md:text-left">
                        We’d love to hear from you!<br>
                        Whether you have a question about features, pricing, or need support, our team is here to help.
                    </p>
                    <ul class="space-y-5 text-base">
                        <li class="flex items-center">
                            <span class="inline-flex items-center justify-center w-9 h-9 rounded-full bg-sky-500 bg-opacity-20 mr-4">
                                <!-- Location Icon -->
                                <jsp:include page="assets/location.svg"/>
                            </span>
                            FPT University, City DaNa, Viet Nam
                        </li>
                        <li class="flex items-center">
                            <span class="inline-flex items-center justify-center w-9 h-9 rounded-full bg-sky-500 bg-opacity-20 mr-4">
                                <!-- Phone Icon -->
                                <jsp:include page="assets/phone.svg"/>
                            </span>
                            010-010-0110 or 020-020-0220
                        </li>
                        <li class="flex items-center">
                            <span class="inline-flex items-center justify-center w-9 h-9 rounded-full bg-sky-500 bg-opacity-20 mr-4">
                                <!-- Email Icon -->
                                <jsp:include page="assets/email.svg"/>
                            </span>
                            info@company.com
                        </li>
                    </ul>
                </div>
                <!-- Right: Contact Form -->
                <form class="flex-1 bg-white bg-opacity-90 rounded-lg shadow-lg p-8 space-y-6 min-w-[320px] max-w-md mx-auto">
                    <div class="flex gap-4">
                        <input type="text" placeholder="Name" class="w-1/2 px-4 py-3 rounded bg-white border border-gray-300 focus:outline-none focus:ring-2 focus:ring-sky-400" />
                        <input type="email" placeholder="Email" class="w-1/2 px-4 py-3 rounded bg-white border border-gray-300 focus:outline-none focus:ring-2 focus:ring-sky-400" />
                    </div>
                    <input type="text" placeholder="Subject" class="w-full px-4 py-3 rounded bg-white border border-gray-300 focus:outline-none focus:ring-2 focus:ring-sky-400" />
                    <textarea placeholder="Message" rows="4" class="w-full px-4 py-3 rounded bg-white border border-gray-300 focus:outline-none focus:ring-2 focus:ring-sky-400"></textarea>
                    <button type="submit" class="w-full bg-sky-400 hover:bg-sky-500 text-white font-bold py-3 rounded-lg transition text-lg shadow">
                        Send
                    </button>
                </form>
            </div>
        </section>
    </body>
    <jsp:include page="views/base/footer.jsp"/>
</html>
