<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Calendar" %>
<%@ page import="com.model.Task" %>
<%
    List<Calendar> calendars = (List<Calendar>) request.getAttribute("calendars");
    List<Task> todos = (List<Task>) request.getAttribute("todos");
    String userName = (String) session.getAttribute("googleName");
    if (userName == null) {
        userName = (String) session.getAttribute("user_email");
    }
    if (userName == null)
        userName = "Guest";
%>
<div class="sidebar-container h-screen w-64 bg-white border-r border-gray-200 flex flex-col p-4 transition-all duration-200" id="sidebarContainer">
    <!-- Nút tạo dropdown -->
    <div class="sidebar-create-dropdown relative mb-6">
        <button class="sidebar-create-btn w-full bg-blue-500 text-white rounded-md py-2 flex items-center justify-center gap-2 text-base font-medium focus:outline-none" id="createDropdownBtn">
            <!-- Plus SVG -->
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
            Create
            <!-- Caret-down SVG -->
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-1" fill="none" viewBox="0 0 20 20" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 8l4 4 4-4" /></svg>
        </button>
        <div class="create-dropdown-content absolute left-0 top-full mt-1 bg-white min-w-full shadow-lg rounded-md overflow-hidden z-20 hidden">
            <a href="createEvent.jsp" class="flex items-center gap-2 px-4 py-2 hover:bg-gray-100 text-gray-700">
                <!-- Calendar-plus SVG -->
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><rect x="3" y="4" width="18" height="18" rx="2" ry="2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><line x1="16" y1="2" x2="16" y2="6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><line x1="8" y1="2" x2="8" y2="6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><line x1="3" y1="10" x2="21" y2="10" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><line x1="12" y1="14" x2="12" y2="18" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><line x1="10" y1="16" x2="14" y2="16" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                Create Event
            </a>
            <a href="createTask.jsp" class="flex items-center gap-2 px-4 py-2 hover:bg-gray-100 text-gray-700">
                <!-- Tasks SVG -->
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><rect x="3" y="5" width="18" height="14" rx="2" ry="2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M9 9h6M9 13h6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                Create Task
            </a>
        </div>
    </div>
    <!-- Lịch nhỏ (placeholder) -->
    <div class="sidebar-mini-calendar bg-gray-100 rounded-lg p-4 mb-6 text-center text-gray-400">
        [Mini calendar will be displayed here]
    </div>
    <!-- My Calendar dropdown -->
    <div class="sidebar-section mb-4">
        <button class="w-full flex items-center justify-between px-2 py-2 text-base font-semibold text-gray-700 focus:outline-none group" id="calendarDropdownBtn">
            My Calendar
            <svg class="h-4 w-4 ml-2 transition-transform duration-200 group-[.open]:rotate-180" fill="none" viewBox="0 0 20 20" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 8l4 4 4-4" /></svg>
        </button>
        <ul id="calendarDropdownContent" class="sidebar-calendar-list space-y-1 pl-2 mt-2">
            <% if (calendars != null)
                    for (Calendar c : calendars) {%>
            <li class="flex items-center gap-2 text-gray-700"><span class="inline-block w-3 h-3 rounded-full bg-blue-500"></span> <%= c.getName()%></li>
                <% } %>
        </ul>
    </div>
    <!-- To-do List dropdown -->
    <div class="sidebar-section">
        <button class="w-full flex items-center justify-between px-2 py-2 text-base font-semibold text-gray-700 focus:outline-none group" id="todoDropdownBtn">
            To-do List
            <svg class="h-4 w-4 ml-2 transition-transform duration-200 group-[.open]:rotate-180" fill="none" viewBox="0 0 20 20" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 8l4 4 4-4" /></svg>
        </button>
        <ul id="todoDropdownContent" class="sidebar-todo-list space-y-1 pl-2 mt-2">
            <% if (todos != null)
                    for (Task t : todos) {%>
            <li class="flex items-center gap-2 text-gray-700">
                <!-- Tasks SVG -->
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><rect x="3" y="5" width="18" height="14" rx="2" ry="2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M9 9h6M9 13h6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                    <%= t.getName()%>
            </li>
            <% }%>
        </ul>
    </div>
</div>
<script>
// Dropdown tạo
const createBtn = document.getElementById('createDropdownBtn');
const createDropdown = createBtn.nextElementSibling;
createBtn.onclick = function (e) {
    e.stopPropagation();
    createDropdown.classList.toggle('hidden');
};
document.addEventListener('click', function () {
    createDropdown.classList.add('hidden');
});
// Accordion cho My Calendar và To-do List
const calBtn = document.getElementById('calendarDropdownBtn');
const calContent = document.getElementById('calendarDropdownContent');
const todoBtn = document.getElementById('todoDropdownBtn');
const todoContent = document.getElementById('todoDropdownContent');
// Mặc định mở
let calOpen = true, todoOpen = true;
function setAccordion(btn, content, open) {
    if (open) {
        content.classList.remove('hidden');
        btn.classList.add('open');
    } else {
        content.classList.add('hidden');
        btn.classList.remove('open');
    }
}
setAccordion(calBtn, calContent, true);
setAccordion(todoBtn, todoContent, true);
calBtn.onclick = function() {
    calOpen = !calOpen;
    setAccordion(calBtn, calContent, calOpen);
};
todoBtn.onclick = function() {
    todoOpen = !todoOpen;
    setAccordion(todoBtn, todoContent, todoOpen);
};
</script> 