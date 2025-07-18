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
<!-- Thêm FullCalendar CDN vào đầu file -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/miniCalendar.css">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>

    <style>
        .calendar-checkbox {
            width: 16px;
            height: 16px;
            cursor: pointer;
            accent-color: #3b82f6;
        }

        .calendar-checkbox:checked {
            background-color: #3b82f6;
            border-color: #3b82f6;
        }

        .calendar-color {
            transition: opacity 0.2s ease;
        }

        .calendar-checkbox:not(:checked) ~ .calendar-color {
            opacity: 0.3;
        }

        .calendar-checkbox:not(:checked) ~ label {
            opacity: 0.6;
        }
    </style>
    <div class="sidebar-container h-screen w-64 bg-white border-r border-gray-200 flex flex-col p-4 transition-all duration-200" id="sidebarContainer">
        <!-- Nút tạo dropdown -->
        <div class="sidebar-create-dropdown relative mb-6">
            <button class="sidebar-create-btn w-full bg-blue-500 text-white rounded-md py-2 flex items-center justify-center gap-2 text-base font-medium focus:outline-none" id="createDropdownBtn">
                <!-- Plus SVG -->
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
                Tạo
                <!-- Caret-down SVG -->
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-1" fill="none" viewBox="0 0 20 20" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 8l4 4 4-4" /></svg>
            </button>
            <div class="create-dropdown-content absolute left-0 top-full mt-1 bg-white min-w-full shadow-lg rounded-md overflow-hidden z-20 hidden">
                <button id="createEventBtn" class="w-full flex items-center gap-2 px-4 py-2 hover:bg-gray-100 text-gray-700 text-left">
                    <!-- Calendar-plus SVG -->
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><rect x="3" y="4" width="18" height="18" rx="2" ry="2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><line x1="16" y1="2" x2="16" y2="6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><line x1="8" y1="2" x2="8" y2="6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><line x1="3" y1="10" x2="21" y2="10" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><line x1="12" y1="14" x2="12" y2="18" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><line x1="10" y1="16" x2="14" y2="16" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                     Sự kiện
                </button>
                <a href="#" onclick="showAddTodoModal();return false;" class="flex items-center gap-2 px-4 py-2 hover:bg-gray-100 text-gray-700">
                    <!-- Tasks SVG -->
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><rect x="3" y="5" width="18" height="14" rx="2" ry="2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M9 9h6M9 13h6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                    Việc cần làm
                </a>
            </div>
        </div>
        <!-- Lịch nhỏ (placeholder) -->
        <div class="sidebar-mini-calendar bg-gray-100 rounded-lg p-2 mb-6">
            <div id="miniCalendar"></div>
        </div>
        <!-- My Calendar dropdown -->
        <div class="sidebar-section mb-4">
            <div class="flex items-center justify-between px-2 py-2">
                <button class="flex items-center justify-between text-base font-semibold text-gray-700 focus:outline-none group" id="calendarDropdownBtn">
                    My Calendar
                    <svg class="h-4 w-4 ml-2 transition-transform duration-200 group-[.open]:rotate-180" fill="none" viewBox="0 0 20 20" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 8l4 4 4-4" /></svg>
                </button>
                <div>
                    <button id="addCalendarBtn" class="text-blue-600 hover:text-blue-800 px-1 text-xl" title="Thêm lịch mới">+</button>
                </div>
            </div>
            <ul id="calendarDropdownContent" class="sidebar-calendar-list space-y-1 pl-2 mt-2">
                <% if (calendars != null)
                        for (Calendar c : calendars) {%>
                <li class="flex items-center gap-2 text-gray-700 group relative">
                    <input type="checkbox" 
                           id="calendar_<%= c.getIdCalendar()%>" 
                           class="calendar-checkbox mr-2" 
                           data-calendar-id="<%= c.getIdCalendar()%>"
                           checked
                           style='accent-color: <%= c.getColor() != null ? c.getColor() : "#3b82f6" %>;'>
                    <label for="calendar_<%= c.getIdCalendar()%>" class="cursor-pointer"><%= c.getName()%></label>
                    <button class="calendar-setting-btn hidden group-hover:inline absolute right-0 top-1/2 -translate-y-1/2 px-2" 
                            data-calendar-id="<%= c.getIdCalendar()%>" 
                            title="Cài đặt">
                        &#8942;
                    </button>
                </li>
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
                    <input type="checkbox" class="todo-checkbox" data-task-id="<%= t.getIdTask() %>" checked>
                    <%= t.getName() %>
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

        // Create Event button handler
        const createEventBtn = document.getElementById('createEventBtn');
        if (createEventBtn) {
            createEventBtn.onclick = function (e) {
                e.stopPropagation();
                createDropdown.classList.add('hidden');

                // Call the create event modal function from calendar.jsp
                if (window.showCreateEventModal) {
                    window.showCreateEventModal();
                } else {
                    console.log('Create event modal function not found');
                }
            };
        }
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
        calBtn.onclick = function () {
            calOpen = !calOpen;
            setAccordion(calBtn, calContent, calOpen);
        };
        todoBtn.onclick = function () {
            todoOpen = !todoOpen;
            setAccordion(todoBtn, todoContent, todoOpen);
        };
        document.addEventListener('DOMContentLoaded', function () {
            // Set calendar colors
            document.querySelectorAll('.calendar-color').forEach(function (element) {
                const color = element.getAttribute('data-color');
                if (color) {
                    element.style.backgroundColor = color;
                }
            });

            // Thêm xử lý cho nút thêm calendar
            var addBtn = document.getElementById('addCalendarBtn');
            if (addBtn) {
                addBtn.onclick = function() {
                    window.location.href = '<%=request.getContextPath()%>/calendar?action=create';
                };
            }
            // Thêm xử lý cho nút setting từng calendar
            document.querySelectorAll('.calendar-setting-btn').forEach(function(btn) {
                btn.onclick = function(e) {
                    e.stopPropagation();
                    var id = btn.getAttribute('data-calendar-id');
                    window.location.href = '<%=request.getContextPath()%>/calendar?action=edit&id=' + id;
                };
            });

            // Calendar checkbox functionality
            document.querySelectorAll('.calendar-checkbox').forEach(function (checkbox) {
                checkbox.addEventListener('change', function () {
                    const calendarId = this.getAttribute('data-calendar-id');
                    const isChecked = this.checked;

                    console.log('Calendar checkbox changed:', calendarId, 'checked:', isChecked);

                    // Call function in calendar.jsp to filter events
                    if (window.filterCalendarEvents) {
                        window.filterCalendarEvents(calendarId, isChecked);
                    } else {
                        console.log('filterCalendarEvents function not found in calendar.jsp');
                    }
                });
            });

            // Select All calendars
            var selectAllBtn = document.getElementById('selectAllCalendars');
            if (selectAllBtn) {
                selectAllBtn.addEventListener('click', function () {
                    document.querySelectorAll('.calendar-checkbox').forEach(function (checkbox) {
                        if (!checkbox.checked) {
                            checkbox.checked = true;
                            checkbox.dispatchEvent(new Event('change'));
                        }
                    });
                });
            }

            // Deselect All calendars
            var deselectAllBtn = document.getElementById('deselectAllCalendars');
            if (deselectAllBtn) {
                deselectAllBtn.addEventListener('click', function () {
                    document.querySelectorAll('.calendar-checkbox').forEach(function (checkbox) {
                        if (checkbox.checked) {
                            checkbox.checked = false;
                            checkbox.dispatchEvent(new Event('change'));
                        }
                    });
                });
            }

            var calendarEl = document.getElementById('miniCalendar');
            if (calendarEl) {
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    locale: 'vi',
                    headerToolbar: {
                        left: '',
                        center: 'title',
                        right: 'prev,next'
                    },
                    height: 200,
                    selectable: true,
                    fixedWeekCount: false,
                    showNonCurrentDates: true,
                    dayMaxEventRows: 1,
                    dateClick: function (info) {
                        // Đánh dấu ngày được chọn
                        document.querySelectorAll('.fc-daygrid-day').forEach(function (dayCell) {
                            dayCell.classList.remove('fc-day-selected');
                        });
                        info.dayEl.classList.add('fc-day-selected');
                        // Có thể thêm logic khi click vào ngày ở đây
                    }
                });
                calendar.render();
            }

            // Khởi tạo visibleTodos với tất cả taskId đang được check
            document.querySelectorAll('.todo-checkbox:checked').forEach(function (checkbox) {
                if (window.visibleTodos) {
                    window.visibleTodos.add(checkbox.getAttribute('data-task-id'));
                }
            });
        });

        document.querySelectorAll('.todo-checkbox').forEach(function (checkbox) {
    checkbox.addEventListener('change', function () {
        const taskId = this.getAttribute('data-task-id');
        const isChecked = this.checked;
        // Gọi hàm filterTodoEvents trong calendar.jsp
        if (window.filterTodoEvents) {
            window.filterTodoEvents(taskId, isChecked);
        }
    });
});
    </script> 