<%-- 
    Document   : subSiderbar
    Created on : Jul 19, 2025, 11:07:13 AM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Task" %>
<%@ page import="com.model.ToDo" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sub Sidebar</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <%
            List<Task> tasks = (List<Task>) request.getAttribute("tasks");
            List<ToDo> todos = (List<ToDo>) request.getAttribute("todos");
            
            // Tạo map để đếm số todo CHƯA HOÀN THÀNH cho mỗi task
            java.util.Map<Integer, Integer> taskTodoCount = new java.util.HashMap<>();
            if (todos != null) {
                for (ToDo todo : todos) {
                    if (todo.getIdTask() != null && todo.getIdTask().getIdTask() != null) {
                        // Chỉ đếm todo chưa hoàn thành
                        if (todo.getIsCompleted() == null || !todo.getIsCompleted()) {
                            int taskId = todo.getIdTask().getIdTask();
                            taskTodoCount.put(taskId, taskTodoCount.getOrDefault(taskId, 0) + 1);
                        }
                    }
                }
            }
        %>
    </head>
    <body>
        <div class="h-screen w-64 bg-white border-r border-gray-200 flex flex-col p-4 transition-all duration-200">
            <!-- Nút tạo đơn giản -->
            <div class="mb-6">
                <button class="w-full bg-blue-500 text-white rounded-md py-2 flex items-center justify-center gap-2 text-base font-medium focus:outline-none hover:bg-blue-600 transition-colors duration-200 no-drag" id="createBtn">
                    <!-- Plus SVG -->
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Tạo
                </button>
            </div>

            <!-- To-do List dropdown -->
            <div>
                <button class="w-full flex items-center justify-between px-2 py-2 text-base font-semibold text-gray-700 focus:outline-none group no-drag" id="todoDropdownBtn">
                    To-do List
                    <svg class="h-4 w-4 ml-2 transition-transform duration-200 group-[.open]:rotate-180" fill="none" viewBox="0 0 20 20" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 8l4 4 4-4" />
                    </svg>
                </button>
                <ul id="todoDropdownContent" class="space-y-1 pl-2 mt-2">
                    <% if (tasks != null)
                        for (Task t : tasks) {
                            int todoCount = taskTodoCount.getOrDefault(t.getIdTask(), 0);
                            String accentColor = (t.getColor() != null) ? t.getColor() : "#10b981";
                    %>
                    <li class="flex items-center justify-between w-full">
                        <div class="flex items-center gap-2 flex-1">
                            <input type="checkbox" 
                                   class="w-4 h-4 cursor-pointer accent-green-500 checked:bg-green-500 checked:border-green-500 no-drag" 
                                   data-task-id="<%= t.getIdTask()%>" 
                                   checked
                                   data-accent-color="<%= accentColor %>">
                            <span class="text-gray-700"><%= t.getName()%></span>
                        </div>
                        <span class="bg-gray-200 text-gray-600 text-xs px-2 py-1 rounded-full min-w-5 text-center"><%= todoCount %></span>
                    </li>
                    <% }%>
                </ul>
                <!-- Nút tạo danh sách mới -->
                <div class="mt-auto pt-4">
                    <button id="addTaskBtn" class="w-full flex items-center gap-2 px-3 py-2 text-gray-600 hover:text-gray-800 hover:bg-gray-100 rounded-md transition-colors duration-150 text-sm no-drag">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                        </svg>
                        Tạo danh sách mới
                    </button>
                </div>

            </div>

        </div>

        <script>
            // Nút tạo đơn giản - gọi trực tiếp showAddTodoModal
            const createBtn = document.getElementById('createBtn');

            createBtn.onclick = function (e) {
                e.stopPropagation();

                // Gọi showAddTodoModal function từ calendar.jsp
                if (window.showAddTodoModal) {
                    window.showAddTodoModal();
                } else {
                    console.log('showAddTodoModal function not found');
                }
            };

            // Accordion cho To-do List
            const todoBtn = document.getElementById('todoDropdownBtn');
            const todoContent = document.getElementById('todoDropdownContent');

            // Mặc định mở
            let todoOpen = true;

            function setAccordion(btn, content, open) {
                if (open) {
                    content.classList.remove('hidden');
                    btn.classList.add('open');
                } else {
                    content.classList.add('hidden');
                    btn.classList.remove('open');
                }
            }

            setAccordion(todoBtn, todoContent, true);

            todoBtn.onclick = function () {
                todoOpen = !todoOpen;
                setAccordion(todoBtn, todoContent, todoOpen);
            };

            // Hàm cập nhật số lượng todo cho một task cụ thể
            function updateTodoCount(taskId, increment) {
                const checkbox = document.querySelector(`[data-task-id="${taskId}"]`);
                if (!checkbox) {
                    console.warn(`Không tìm thấy checkbox với taskId: ${taskId}`);
                    return;
                }
                
                const taskItem = checkbox.closest('li');
                if (!taskItem) {
                    console.warn(`Không tìm thấy li element cho taskId: ${taskId}`);
                    return;
                }
                
                const countElement = taskItem.querySelector('span:last-child');
                if (!countElement) {
                    console.warn(`Không tìm thấy count element cho taskId: ${taskId}`);
                    return;
                }
                
                let currentCount = parseInt(countElement.textContent) || 0;
                
                if (increment) {
                    currentCount++;
                } else {
                    currentCount = Math.max(0, currentCount - 1);
                }
                
                countElement.textContent = currentCount;
                console.log(`Cập nhật count cho task ${taskId}: ${currentCount}`);
            }

            // Export hàm để task.jsp có thể gọi
            window.updateTodoCount = updateTodoCount;
            
            // Thông báo rằng sidebar đã sẵn sàng
            window.dispatchEvent(new CustomEvent('sidebarReady'));

            document.addEventListener('DOMContentLoaded', function () {
                // Khởi tạo visibleTodos với tất cả taskId đang được check
                document.querySelectorAll('input[type="checkbox"]:checked').forEach(function (checkbox) {
                    if (window.visibleTodos) {
                        window.visibleTodos.add(checkbox.getAttribute('data-task-id'));
                    }
                });
                
                // Set accent color cho checkboxes
                document.querySelectorAll('input[type="checkbox"]').forEach(function (checkbox) {
                    const accentColor = checkbox.getAttribute('data-accent-color');
                    if (accentColor) {
                        checkbox.style.accentColor = accentColor;
                    }
                });
            });

            document.querySelectorAll('input[type="checkbox"]').forEach(function (checkbox) {
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
    </body>
</html>

