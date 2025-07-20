<%-- Document : task Created on : Jul 19, 2025, 1:42:06 AM Author : DELL --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Tailwind CSS -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>



<!-- SortableJS -->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">



<style>
    .task-card {
        transition: all 0.3s ease;
    }

    .task-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    }

    .sortable-ghost {
        opacity: 0.5;
        background: #f3f4f6;
    }

    .sortable-chosen {
        background: #ffffff;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }

    .task-item {
        transition: all 0.2s ease;
    }

    .task-item:hover {
        background-color: #f8fafc;
    }
    /* CSS cho drag & drop columns */
    .task-column {
        transition: all 0.3s ease;
    }
    .task-column:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    }
    .column-sortable-ghost {
        opacity: 0.5;
        background: #f3f4f6;
        transform: rotate(5deg);
    }
    .column-sortable-chosen {
        background: #ffffff;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        transform: scale(1.02);
    }
    /* CSS cho layout scroll ngang */
    .task-columns-container {
        display: flex;
        overflow-x: auto;
        gap: 1rem;
        padding: 1rem;
        min-height: calc(100vh - 8rem);
        scrollbar-width: thin;
        scrollbar-color: #cbd5e0 #f7fafc;
    }
    .task-columns-container::-webkit-scrollbar {
        height: 8px;
    }
    .task-columns-container::-webkit-scrollbar-track {
        background: #f7fafc;
        border-radius: 4px;
    }
    .task-columns-container::-webkit-scrollbar-thumb {
        background: #cbd5e0;
        border-radius: 4px;
    }
    .task-columns-container::-webkit-scrollbar-thumb:hover {
        background: #a0aec0;
    }
    .task-column {
        flex: 0 0 320px; /* Cố định chiều rộng mỗi cột */
        min-width: 320px;
        max-width: 320px;
        height: fit-content;
        max-height: calc(100vh - 10rem);
        overflow-y: auto;
    }
    /* CSS cho drag scroll */
    .task-columns-container.dragging {
        cursor: grabbing;
        user-select: none;
    }
    .task-columns-container.dragging .task-column {
        pointer-events: none;
    }
    .task-columns-container.dragging .task-column * {
        pointer-events: none;
    }

    /* Hiệu ứng cho checkbox */
    .todo-status-checkbox {
        transition: all 0.2s ease;
    }
    .todo-status-checkbox:checked {
        transform: scale(1.1);
    }

    /* Hiệu ứng cho task item khi loading */
    .task-item.opacity-50 {
        transition: opacity 0.2s ease;
    }

    /* Hiệu ứng cho việc di chuyển todo */
    .task-item {
        transition: all 0.3s ease;
    }



    /* CSS cho task menu dropdown */
    .task-menu-dropdown {
        transition: all 0.2s ease;
        transform-origin: top right;
    }

    .task-menu-dropdown.show {
        transform: scale(1);
        opacity: 1;
    }

    .task-menu-dropdown.hidden {
        transform: scale(0.95);
        opacity: 0;
    }
</style>

<!-- Main Content Area -->
<div >
    <div class="task-columns-container" id="taskColumns">
        <c:forEach var="col" items="${columns}">
            <div class="task-column bg-white rounded-lg shadow-sm border border-gray-200 cursor-move" data-task-id="${col.idTask}" data-position="${col.position}">
                <div class="p-4 border-b border-gray-200">
                    <div class="flex items-center justify-between">
                        <h3 class="font-semibold text-gray-900">${col.name}</h3>
                        <div class="relative">
                            <button class="task-menu-btn text-gray-400 hover:text-gray-600 p-1 rounded" data-task-id="${col.idTask}" data-task-name="${col.name}">
                                <i class="fas fa-ellipsis-v"></i>
                            </button>
                            <div class="task-menu-dropdown absolute right-0 top-full mt-1 bg-white border border-gray-200 rounded-lg shadow-lg z-40 hidden min-w-32">
                                <button class="rename-task-btn w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 flex items-center space-x-2" data-task-id="${col.idTask}" data-task-name="${col.name}">
                                    <i class="fas fa-edit text-xs"></i>
                                    <span>Đổi tên</span>
                                </button>
                                <button class="delete-task-btn w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-red-50 flex items-center space-x-2" data-task-id="${col.idTask}" data-task-name="${col.name}">
                                    <i class="fas fa-trash text-xs"></i>
                                    <span>Xóa</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="p-4">
                    <!-- Danh sách Todo chưa hoàn thành -->
                    <div class="mb-4">
                        <h4 class="text-sm font-medium text-gray-700 mb-2">Chưa hoàn thành</h4>
                        <div class="sortable-list incomplete-list" id="incomplete-list${col.idTask}">
                            <c:forEach var="todo" items="${col.toDoList}">
                                <c:if test="${empty todo.isCompleted or not todo.isCompleted}">
                                    <div
                                        class="task-item flex items-center space-x-3 p-3 rounded-lg hover:bg-gray-50 cursor-move group"
                                        data-todo-id="${todo.idTodo}">
                                        <input type="checkbox" class="todo-status-checkbox text-blue-500" 
                                               data-todo-id="${todo.idTodo}" 
                                               <c:if test="${todo.isCompleted}">checked</c:if>>
                                               <div class="flex-1">
                                                   <div class="text-sm font-medium">${todo.title}</div>
                                               <c:if test="${not empty todo.dueDate}">
                                                   <div class="flex items-center space-x-2 mt-1">
                                                       <span
                                                           class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                           ${todo.dueDate}
                                                       </span>
                                                   </div>
                                               </c:if>
                                        </div>
                                        <button class="edit-todo-btn opacity-0 group-hover:opacity-100 transition-opacity ml-2 text-gray-400 hover:text-blue-600" data-todo-id="${todo.idTodo}" data-task-id="${col.idTask}">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Danh sách Todo đã hoàn thành -->
                    <div class="mb-4">
                        <h4 class="text-sm font-medium text-gray-500 mb-2">Đã hoàn thành</h4>
                        <div class="sortable-list complete-list" id="complete-list${col.idTask}">
                            <c:forEach var="todo" items="${col.toDoList}">
                                <c:if test="${todo.isCompleted}">
                                    <div
                                        class="task-item flex items-center space-x-3 p-3 rounded-lg hover:bg-gray-50 cursor-move opacity-60 group"
                                        data-todo-id="${todo.idTodo}">
                                        <input type="checkbox" class="todo-status-checkbox text-blue-500" 
                                               data-todo-id="${todo.idTodo}" 
                                               <c:if test="${todo.isCompleted}">checked</c:if>>
                                               <div class="flex-1">
                                                   <div class="text-sm font-medium line-through">${todo.title}</div>
                                               <c:if test="${not empty todo.dueDate}">
                                                   <div class="flex items-center space-x-2 mt-1">
                                                       <span
                                                           class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                           ${todo.dueDate}
                                                       </span>
                                                   </div>
                                               </c:if>
                                        </div>
                                        <button class="edit-todo-btn opacity-0 group-hover:opacity-100 transition-opacity ml-2 text-gray-400 hover:text-blue-600" data-todo-id="${todo.idTodo}" data-task-id="${col.idTask}">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>

                    <button
                        class="openAddTodoModal w-full mt-4 flex items-center justify-center space-x-2 text-gray-500 hover:text-gray-700 py-2 rounded-lg hover:bg-gray-50 transition-colors">
                        <i class="fas fa-plus text-sm"></i>
                        <span class="text-sm">Thêm việc cần làm</span>
                    </button>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Modal Tạo ToDo Mới (Copy từ calendar.jsp) -->
<div id="addTodoModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden z-50">
    <div class="flex items-center justify-center min-h-screen p-4">
        <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
            <div class="flex justify-between items-center p-6 border-b">
                <h3 class="text-lg font-semibold text-gray-900">Tạo ToDo mới</h3>
                <button id="closeAddTodoModal" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            <form id="addTodoForm" class="p-6">
                <div class="mb-4">
                    <label for="todoTitle" class="block text-sm font-medium text-gray-700 mb-1">Tiêu đề
                        *</label>
                    <input type="text" id="todoTitle" name="title" required
                           class="w-full px-3 py-2 border border-gray-300 rounded-md"
                           placeholder="Nhập tiêu đề">
                </div>
                <div class="mb-4">
                    <label for="todoDescription" class="block text-sm font-medium text-gray-700 mb-1">Mô
                        tả</label>
                    <textarea id="todoDescription" name="description" rows="2"
                              class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                </div>
                <div class="grid grid-cols-2 gap-4 mb-4">
                    <div>
                        <label for="todoDueDate" class="block text-sm font-medium text-gray-700 mb-1">Ngày
                            đến hạn *</label>
                        <input type="date" id="todoDueDate" name="dueDate" required
                               class="w-full px-3 py-2 border border-gray-300 rounded-md">
                    </div>
                    <div>
                        <label for="todoDueTime" class="block text-sm font-medium text-gray-700 mb-1">Giờ
                            đến hạn</label>
                        <input type="time" id="todoDueTime" name="dueTime"
                               class="w-full px-3 py-2 border border-gray-300 rounded-md">
                    </div>
                </div>
                <div class="mb-4">
                    <label class="flex items-center">
                        <input type="checkbox" id="todoAllDay" name="isAllDay" class="mr-2">
                        <span class="text-sm text-gray-700">Cả ngày</span>
                    </label>
                </div>
                <div class="mb-4">
                    <label for="todoTaskId"
                           class="block text-sm font-medium text-gray-700 mb-1">Task</label>
                    <select id="todoTaskId" name="taskId"
                            class="w-full px-3 py-2 border border-gray-300 rounded-md" required>

                        <c:forEach var="task" items="${tasks}">
                            <option value="${task.idTask}">${task.name}</option>
                        </c:forEach>
                    </select>
                </div>
            </form>
            <div class="flex justify-end p-6 border-t">
                <button id="saveTodo" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                    Thêm ToDo
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Đổi Tên Task -->
<div id="renameTaskModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden z-50">
    <div class="flex items-center justify-center min-h-screen p-4">
        <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
            <div class="flex justify-between items-center p-6 border-b">
                <h3 class="text-lg font-semibold text-gray-900">Đổi tên Task</h3>
                <button id="closeRenameTaskModal" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            <form id="renameTaskForm" class="p-6">
                <div class="mb-4">
                    <label for="newTaskName" class="block text-sm font-medium text-gray-700 mb-1">Tên Task mới *</label>
                    <input type="text" id="newTaskName" name="newTaskName" required
                           class="w-full px-3 py-2 border border-gray-300 rounded-md"
                           placeholder="Nhập tên task mới">
                </div>
                <input type="hidden" id="renameTaskId" name="taskId">
            </form>
            <div class="flex justify-end space-x-3 p-6 border-t">
                <button id="cancelRenameTask" class="px-4 py-2 text-gray-600 border border-gray-300 rounded-md hover:bg-gray-50">
                    Hủy
                </button>
                <button id="saveRenameTask" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                    Lưu thay đổi
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Edit ToDo -->
<div id="editTodoModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden z-50">
    <div class="flex items-center justify-center min-h-screen p-4">
        <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
            <div class="flex justify-between items-center p-6 border-b">
                <h3 class="text-lg font-semibold text-gray-900">Chỉnh sửa ToDo</h3>
                <button id="closeEditTodoModal" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            <form id="editTodoForm" class="p-6">
                <input type="hidden" id="editTodoId" name="todoId">
                <div class="mb-4">
                    <label for="editTodoTitle" class="block text-sm font-medium text-gray-700 mb-1">Tiêu đề *</label>
                    <input type="text" id="editTodoTitle" name="title" required
                           class="w-full px-3 py-2 border border-gray-300 rounded-md"
                           placeholder="Nhập tiêu đề">
                </div>
                <div class="mb-4">
                    <label for="editTodoDescription" class="block text-sm font-medium text-gray-700 mb-1">Mô tả</label>
                    <textarea id="editTodoDescription" name="description" rows="2"
                              class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                </div>
                <div class="grid grid-cols-2 gap-4 mb-4">
                    <div>
                        <label for="editTodoDueDate" class="block text-sm font-medium text-gray-700 mb-1">Ngày đến hạn *</label>
                        <input type="date" id="editTodoDueDate" name="dueDate" required
                               class="w-full px-3 py-2 border border-gray-300 rounded-md">
                    </div>
                    <div>
                        <label for="editTodoDueTime" class="block text-sm font-medium text-gray-700 mb-1">Giờ đến hạn</label>
                        <input type="time" id="editTodoDueTime" name="dueTime"
                               class="w-full px-3 py-2 border border-gray-300 rounded-md">
                    </div>
                </div>
                <div class="mb-4">
                    <label class="flex items-center">
                        <input type="checkbox" id="editTodoAllDay" name="isAllDay" class="mr-2">
                        <span class="text-sm text-gray-700">Cả ngày</span>
                    </label>
                </div>
            </form>
            <div class="flex justify-between p-6 border-t">
                <button id="deleteEditTodo" class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 flex items-center space-x-2">
                    <i class="fas fa-trash text-xs"></i>
                    <span>Xóa</span>
                </button>
                <button id="saveEditTodo" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                    Lưu thay đổi
                </button>
            </div>
        </div>
    </div>
</div>
<!-- Modal Tạo Task Mới -->
<div id="addTaskModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden z-50">
    <div class="flex items-center justify-center min-h-screen p-4">
        <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
            <div class="flex justify-between items-center p-6 border-b">
                <h3 class="text-lg font-semibold text-gray-900">Tạo Task mới</h3>
                <button id="closeAddTaskModal" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            <form id="addTaskForm" class="p-6">
                <div class="mb-4">
                    <label for="taskName" class="block text-sm font-medium text-gray-700 mb-1">Tên Task *</label>
                    <input type="text" id="taskName" name="name" required class="w-full px-3 py-2 border border-gray-300 rounded-md" placeholder="Nhập tên task">
                </div>
                <div class="mb-4">
                    <label for="taskColor" class="block text-sm font-medium text-gray-700 mb-1">Màu sắc</label>
                    <select id="taskColor" name="color" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                        <option value="#3b82f6">Xanh dương</option>
                        <option value="#ef4444">Đỏ</option>
                        <option value="#10b981">Xanh lá</option>
                        <option value="#f59e0b">Cam</option>
                        <option value="#8b5cf6">Tím</option>
                        <option value="#ec4899">Hồng</option>
                    </select>
                </div>
            </form>
            <div class="flex justify-end p-6 border-t">
                <button id="saveTask" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                    Thêm Task
                </button>
            </div>
        </div>
    </div>
</div>
<script>
    // Biến global để lưu trạng thái filter
    var visibleTodos = new Set();

    // Hàm filter task columns
    function filterTodoEvents(taskId, isVisible) {
        if (isVisible) {
            visibleTodos.add(taskId);
        } else {
            visibleTodos.delete(taskId);
        }

        // Áp dụng filter cho tất cả task columns
        applyTaskFilter();
    }

    // Hàm áp dụng filter
    function applyTaskFilter() {
        const taskColumns = document.querySelectorAll('.task-column');
        let visibleCount = 0;
        let totalCount = taskColumns.length;

        taskColumns.forEach(function (column) {
            const taskId = column.getAttribute('data-task-id');
            const taskName = column.querySelector('h3').textContent;

            if (visibleTodos.size > 0) {
                // Nếu có filter được chọn, chỉ hiện task được check
                if (visibleTodos.has(taskId)) {
                    column.style.display = 'block';
                    visibleCount++;
                } else {
                    column.style.display = 'none';
                }
            } else if (visibleTodos.size === 0 && document.querySelectorAll('.todo-checkbox').length > 0) {
                // Nếu không có filter nào được chọn, hiện tất cả
                column.style.display = 'block';
                visibleCount = totalCount;
            }
        });

        // Hiển thị thông báo filter
        if (visibleTodos.size > 0 && visibleCount < totalCount) {
            console.log(`Đang hiển thị ${visibleCount}/${totalCount} danh sách task`);
        } else if (visibleTodos.size === 0) {
            console.log('Hiển thị tất cả danh sách task');
        }
    }

    // Export hàm để sidebar có thể gọi
    window.filterTodoEvents = filterTodoEvents;
    window.visibleTodos = visibleTodos;

    $(document).ready(function () {
        // Khởi tạo SortableJS cho các task columns (drag & drop columns)
        const taskColumnsContainer = document.getElementById('taskColumns');
        if (taskColumnsContainer) {
            new Sortable(taskColumnsContainer, {
                animation: 300,
                ghostClass: 'column-sortable-ghost',
                chosenClass: 'column-sortable-chosen',
                dragClass: 'column-sortable-drag',
                onEnd: function (evt) {
                    // Cập nhật vị trí columns trong database
                    updateColumnPosition(evt.item, evt.oldIndex, evt.newIndex);
                }
            });
        }

        // Khởi tạo SortableJS cho tất cả các danh sách todo bên trong columns
        const sortableLists = document.querySelectorAll('.sortable-list');

        sortableLists.forEach(function (list) {
            new Sortable(list, {
                group: 'tasks', // Cho phép kéo thả giữa các danh sách
                animation: 150,
                ghostClass: 'sortable-ghost',
                chosenClass: 'sortable-chosen',
                dragClass: 'sortable-drag',
                onEnd: function (evt) {
                    // Xử lý khi kéo thả todo giữa các task lists
                    updateTaskPosition(evt.item, evt.from.id, evt.to.id, evt.newIndex);
                }
            });
        });

        // Xử lý sự kiện checkbox thay đổi trạng thái todo
        $(document).on('change', '.todo-status-checkbox', function () {
            const checkbox = $(this);
            const todoId = checkbox.data('todo-id');
            const isCompleted = checkbox.is(':checked');
            const taskItem = checkbox.closest('.task-item');
            const taskColumn = checkbox.closest('.task-column');
            const taskId = taskColumn.attr('data-task-id');
            const todoTitle = taskItem.find('.text-sm').first().text();

            // Thêm hiệu ứng loading
            taskItem.addClass('opacity-50');

            // Gửi AJAX để cập nhật trạng thái
            $.ajax({
                url: '${pageContext.request.contextPath}/todo',
                type: 'POST',
                dataType: 'json',
                data: {
                    action: 'updateTodoStatus',
                    todoId: todoId,
                    isCompleted: isCompleted
                },
                success: function (response) {
                    if (response.success) {
                        // Bỏ hiệu ứng loading
                        taskItem.removeClass('opacity-50');

                        // Di chuyển todo giữa 2 danh sách
                        moveTodoBetweenLists(taskItem, isCompleted, taskId);


                        // Hiển thị thông báo thành công
                        console.log(isCompleted ?
                                `✅ Đã hoàn thành: "${todoTitle}"` :
                                `🔄 Đã bỏ hoàn thành: "${todoTitle}"`
                                );
                        location.reload();
                    } else {
                        // Revert checkbox nếu có lỗi
                        checkbox.prop('checked', !isCompleted);
                        taskItem.removeClass('opacity-50');
                        alert('❌ Lỗi: ' + response.error);
                    }
                },
                error: function () {
                    // Revert checkbox nếu có lỗi
                    checkbox.prop('checked', !isCompleted);
                    taskItem.removeClass('opacity-50');
                    alert('❌ Lỗi khi cập nhật trạng thái todo');
                }
            });
        });

        // Hàm di chuyển todo giữa 2 danh sách
        function moveTodoBetweenLists(taskItem, isCompleted, taskId) {
            const incompleteList = $(`#taskColumns [data-task-id="${taskId}"] .incomplete-list`);
            const completeList = $(`#taskColumns [data-task-id="${taskId}"] .complete-list`);

            if (isCompleted) {
                // Di chuyển từ incomplete sang complete
                taskItem.addClass('opacity-60');
                taskItem.find('.text-sm').first().addClass('line-through');
                taskItem.find('.inline-flex').removeClass('bg-red-100 text-red-800').addClass('bg-green-100 text-green-800');

                // Thêm hiệu ứng mượt mà khi di chuyển
                taskItem.fadeOut(200, function () {
                    completeList.append(taskItem);
                    taskItem.fadeIn(200);
                });

                // Giảm số lượng todo chưa hoàn thành trong sidebar
                safeUpdateTodoCount(taskId, false);
            } else {
                // Di chuyển từ complete sang incomplete
                taskItem.removeClass('opacity-60');
                taskItem.find('.text-sm').first().removeClass('line-through');
                taskItem.find('.inline-flex').removeClass('bg-green-100 text-green-800').addClass('bg-red-100 text-red-800');

                // Thêm hiệu ứng mượt mà khi di chuyển
                taskItem.fadeOut(200, function () {
                    incompleteList.append(taskItem);
                    taskItem.fadeIn(200);
                });

                // Tăng số lượng todo chưa hoàn thành trong sidebar
                safeUpdateTodoCount(taskId, true);
            }

            // Cập nhật số lượng todo trong sidebar nếu có
            updateTodoCounts();
        }

        // Hàm cập nhật số lượng todo trong sidebar
        function updateTodoCounts() {
            // Nếu có sidebar với todo counts, cập nhật ở đây
            const taskColumns = document.querySelectorAll('.task-column');
            taskColumns.forEach(function (column) {
                const taskId = column.getAttribute('data-task-id');
                const incompleteCount = column.querySelectorAll('.incomplete-list .task-item').length;
                const completeCount = column.querySelectorAll('.complete-list .task-item').length;

                // Có thể cập nhật số lượng trong sidebar nếu cần
                console.log(`Task ${taskId}: ${incompleteCount} incomplete, ${completeCount} complete`);
            });
        }

        // Hàm đảm bảo sidebar đã sẵn sàng trước khi cập nhật count
        function safeUpdateTodoCount(taskId, increment) {
            if (window.updateTodoCount && typeof window.updateTodoCount === 'function') {
                try {
                    window.updateTodoCount(taskId, increment);
                } catch (error) {
                    console.warn('Lỗi khi cập nhật todo count:', error);
                }
            } else {
                // Nếu sidebar chưa sẵn sàng, đợi event
                window.addEventListener('sidebarReady', function () {
                    try {
                        window.updateTodoCount(taskId, increment);
                    } catch (error) {
                        console.warn('Lỗi khi cập nhật todo count:', error);
                    }
                }, {once: true});
            }
        }

        // Hàm cập nhật vị trí columns
        function updateColumnPosition(item, oldIndex, newIndex) {
            const columnName = item.querySelector('h3').textContent;
            const taskId = item.getAttribute('data-task-id');
            const oldPosition = parseInt(item.getAttribute('data-position'));

            // Cập nhật data-position cho item được kéo
            item.setAttribute('data-position', newIndex + 1);

            console.log(`Đã di chuyển cột "${columnName}" từ vị trí ${oldIndex + 1} đến vị trí ${newIndex + 1}`);

            // Gửi AJAX để cập nhật vị trí columns trong database
            $.ajax({
                url: '${pageContext.request.contextPath}/task',
                type: 'POST',
                dataType: 'json',
                data: {
                    action: 'updateColumnPosition',
                    taskId: taskId,
                    oldPosition: oldPosition,
                    newPosition: newIndex + 1
                },
                success: function (response) {
                    if (response.success) {
                        console.log('Cập nhật vị trí column thành công!');
                        // Cập nhật data-position cho tất cả các columns
                        updateAllColumnPositions();
                    } else {
                        console.error('Lỗi cập nhật vị trí:', response.error);
                        alert('Lỗi: ' + response.error);
                        // Revert lại vị trí nếu có lỗi
                        location.reload();
                    }
                },
                error: function () {
                    console.error('Lỗi khi gửi yêu cầu cập nhật vị trí');
                    alert('Lỗi khi cập nhật vị trí');
                    // Revert lại vị trí nếu có lỗi
                    location.reload();
                }
            });
        }

        // Hàm cập nhật data-position cho tất cả columns sau khi reorder
        function updateAllColumnPositions() {
            const columns = document.querySelectorAll('.task-column');
            columns.forEach((column, index) => {
                column.setAttribute('data-position', index + 1);
            });
        }

        // Hàm khởi tạo position cho các task chưa có position (tương thích với dữ liệu cũ)
        function initializePositions() {
            const columns = document.querySelectorAll('.task-column');
            columns.forEach((column, index) => {
                const currentPosition = column.getAttribute('data-position');
                if (!currentPosition || currentPosition === 'null') {
                    column.setAttribute('data-position', index + 1);
                }
            });
        }

        // Gọi hàm khởi tạo position khi trang load
        initializePositions();

        // Khởi tạo filter với tất cả task được check
        initializeTaskFilter();

        // Thêm tính năng drag scroll ngang
        initDragScroll();

        // Hàm khởi tạo filter ban đầu
        function initializeTaskFilter() {
            // Khởi tạo visibleTodos với tất cả taskId đang được check trong sidebar
            if (window.visibleTodos) {
                // Nếu sidebar đã khởi tạo, sử dụng giá trị từ đó
                visibleTodos = window.visibleTodos;
            } else {
                // Nếu chưa có, khởi tạo với tất cả task
                const taskColumns = document.querySelectorAll('.task-column');
                taskColumns.forEach(function (column) {
                    const taskId = column.getAttribute('data-task-id');
                    visibleTodos.add(taskId);
                });
            }

            // Áp dụng filter ban đầu
            applyTaskFilter();
        }

        // Hàm khởi tạo drag scroll
        function initDragScroll() {
            const container = document.getElementById('taskColumns');
            let isDragging = false;
            let startX = 0;
            let scrollLeft = 0;

            // Mouse events
            container.addEventListener('mousedown', function (e) {
                // Chỉ kích hoạt drag scroll khi click vào vùng trống, không phải vào task columns
                if (e.target === container || e.target.classList.contains('task-columns-container')) {
                    isDragging = true;
                    container.classList.add('dragging');
                    startX = e.pageX - container.offsetLeft;
                    scrollLeft = container.scrollLeft;
                }
            });

            container.addEventListener('mousemove', function (e) {
                if (!isDragging)
                    return;
                e.preventDefault();
                const x = e.pageX - container.offsetLeft;
                const walk = (x - startX) * 2; // Tốc độ scroll
                container.scrollLeft = scrollLeft - walk;
            });

            container.addEventListener('mouseup', function () {
                isDragging = false;
                container.classList.remove('dragging');
            });

            container.addEventListener('mouseleave', function () {
                isDragging = false;
                container.classList.remove('dragging');
            });

            // Touch events cho mobile
            container.addEventListener('touchstart', function (e) {
                if (e.target === container || e.target.classList.contains('task-columns-container')) {
                    isDragging = true;
                    container.classList.add('dragging');
                    startX = e.touches[0].pageX - container.offsetLeft;
                    scrollLeft = container.scrollLeft;
                }
            });

            container.addEventListener('touchmove', function (e) {
                if (!isDragging)
                    return;
                e.preventDefault();
                const x = e.touches[0].pageX - container.offsetLeft;
                const walk = (x - startX) * 2;
                container.scrollLeft = scrollLeft - walk;
            });

            container.addEventListener('touchend', function () {
                isDragging = false;
                container.classList.remove('dragging');
            });

            // Ngăn chặn drag scroll khi đang kéo thả task columns
            container.addEventListener('dragstart', function (e) {
                if (e.target.classList.contains('task-column')) {
                    isDragging = false;
                    container.classList.remove('dragging');
                }
            });
        }

        // Hàm cập nhật vị trí task (demo)
        function updateTaskPosition(item, fromList, toList, newIndex) {
            const taskName = item.querySelector('.text-sm').textContent;
            const todoId = item.getAttribute('data-todo-id');

            // Lấy task ID từ list ID (incomplete-list123 -> 123, complete-list123 -> 123)
            const fromTaskId = fromList.replace('incomplete-list', '').replace('complete-list', '');
            const toTaskId = toList.replace('incomplete-list', '').replace('complete-list', '');

            // Nếu kéo thả trong cùng một task, chỉ cập nhật vị trí
            if (fromTaskId === toTaskId) {
                console.log(`Đã di chuyển "${taskName}" trong cùng task`);
                return;
            }

            // Nếu kéo thả sang task khác, gửi AJAX để cập nhật database
            $.ajax({
                url: '${pageContext.request.contextPath}/todo',
                type: 'POST',
                dataType: 'json',
                data: {
                    action: 'updateTodoTask',
                    todoId: todoId,
                    newTaskId: toTaskId
                },
                success: function (response) {
                    if (response.success) {
                        console.log(`Đã di chuyển "${taskName}" từ task ${fromTaskId} sang task ${toTaskId}`);
                        console.log('Di chuyển ToDo thành công!');
                    } else {
                        alert('Lỗi: ' + response.error);
                        console.error('Lỗi di chuyển ToDo:', response.error);
                        // Revert lại vị trí nếu có lỗi
                        location.reload();
                    }
                },
                error: function () {
                    alert('Lỗi khi di chuyển ToDo');
                    console.error('Lỗi khi gửi yêu cầu di chuyển ToDo');
                    // Revert lại vị trí nếu có lỗi
                    location.reload();
                }
            });
        }
    });

    // Hàm mở modal tạo ToDo mới
    function showAddTodoModal(selectedDate, selectedTime, taskId, taskName) {
        // Nếu muốn load lại danh sách task từ server, có thể dùng AJAX ở đây
        // Nếu không, giữ nguyên options đã render bằng JSTL
        $('#addTodoModal').removeClass('hidden');

        // Reset form trước khi fill
        $('#addTodoForm')[0].reset();

        // Set date và time
        if (selectedDate) {
            $('#todoDueDate').val(selectedDate);
        } else {
            $('#todoDueDate').val(new Date().toISOString().split('T')[0]);
        }
        if (selectedTime) {
            $('#todoDueTime').val(selectedTime);
        } else {
            const now = new Date();
            $('#todoDueTime').val(now.toTimeString().slice(0, 5));
        }

        // Chọn task trong modal nếu có taskId
        if (taskId) {
            $('#todoTaskId').val(taskId);

            // Cập nhật tiêu đề modal với tên task
            const modalTitle = $('#addTodoModal h3');
            if (taskName) {
                modalTitle.text(`Tạo ToDo mới - ${taskName}`);
            } else {
                modalTitle.text('Tạo ToDo mới');
            }

            // Disable select task vì đã được chọn tự động
            $('#todoTaskId').prop('disabled', true);
        } else {
            // Nếu không có taskId, enable select và reset tiêu đề
            $('#todoTaskId').prop('disabled', false);
            $('#addTodoModal h3').text('Tạo ToDo mới');
        }
    }
    // Sự kiện mở modal khi bấm nút "Thêm việc cần làm"
    $(document).on('click', '.openAddTodoModal', function (e) {
        e.preventDefault();

        // Lấy taskId từ column chứa nút này
        const taskColumn = $(this).closest('.task-column');
        const taskId = taskColumn.attr('data-task-id');
        const taskName = taskColumn.find('h3').text();

        // Mở modal với task được chọn
        showAddTodoModal(null, null, taskId, taskName);
    });
    // Đóng modal khi bấm nút X
    $('#closeAddTodoModal').on('click', function () {
        $('#addTodoModal').addClass('hidden');
        $('#addTodoForm')[0].reset();
        // Reset trạng thái select task
        $('#todoTaskId').prop('disabled', false);
        $('#addTodoModal h3').text('Tạo ToDo mới');
    });
    // Đóng modal khi click ra ngoài vùng modal
    $('#addTodoModal').on('mousedown', function (e) {
        if (e.target === this || $(e.target).hasClass('flex')) {
            $('#addTodoModal').addClass('hidden');
            $('#addTodoForm')[0].reset();
            // Reset trạng thái select task
            $('#todoTaskId').prop('disabled', false);
            $('#addTodoModal h3').text('Tạo ToDo mới');
        }
    });
    // Sự kiện lưu ToDo
    $('#saveTodo').on('click', function () {
        // Lấy dữ liệu từ form
        const formData = {
            title: $('#todoTitle').val(),
            description: $('#todoDescription').val(),
            dueDate: $('#todoDueDate').val(),
            dueTime: $('#todoDueTime').val(),
            isAllDay: $('#todoAllDay').is(':checked'),
            taskId: $('#todoTaskId').val()
        };
        // Kiểm tra dữ liệu bắt buộc
        if (!formData.title || !formData.dueDate || !formData.taskId) {
            alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
            return;
        }
        // Gửi AJAX lên server để tạo ToDo mới
        $.ajax({
            url: '${pageContext.request.contextPath}/todo',
            type: 'POST',
            dataType: 'json',
            data: {
                action: 'createTodo',
                title: formData.title,
                description: formData.description,
                dueDate: formData.dueDate,
                dueTime: formData.dueTime,
                isAllDay: formData.isAllDay ? 'on' : 'off',
                taskId: formData.taskId
            },
            success: function (response) {
                if (response.success) {
                    alert('ToDo đã được tạo thành công!');
                    $('#addTodoModal').addClass('hidden');
                    $('#addTodoForm')[0].reset();
                    // TODO: Reload lại danh sách ToDo nếu cần
                    location.reload();
                } else {
                    alert('Lỗi: ' + (response.error || 'Không thể tạo ToDo'));
                }
            },
            error: function () {
                alert('Lỗi khi gửi dữ liệu đến server');
            }
        });
    });

    // Xử lý dropdown menu cho task
    $(document).on('click', '.task-menu-btn', function (e) {
        e.preventDefault();
        e.stopPropagation();

        const dropdown = $(this).siblings('.task-menu-dropdown');
        const allDropdowns = $('.task-menu-dropdown');

        // Đóng tất cả dropdown khác
        allDropdowns.not(dropdown).removeClass('show').addClass('hidden');

        // Toggle dropdown hiện tại
        if (dropdown.hasClass('hidden')) {
            dropdown.removeClass('hidden').addClass('show');
        } else {
            dropdown.removeClass('show').addClass('hidden');
        }
    });

    // Đóng dropdown khi click ra ngoài
    $(document).on('click', function (e) {
        if (!$(e.target).closest('.relative').length) {
            $('.task-menu-dropdown').removeClass('show').addClass('hidden');
        }
    });

    // Xử lý nút đổi tên task
    $(document).on('click', '.rename-task-btn', function (e) {
        e.preventDefault();
        e.stopPropagation();

        const taskId = $(this).data('task-id');
        const taskName = $(this).data('task-name');

        // Đóng dropdown
        $('.task-menu-dropdown').removeClass('show').addClass('hidden');

        // Mở modal đổi tên
        showRenameTaskModal(taskId, taskName);
    });

    // Xử lý nút xóa task
    $(document).on('click', '.delete-task-btn', function (e) {
        e.preventDefault();
        e.stopPropagation();

        const taskId = $(this).data('task-id');
        const taskName = $(this).data('task-name');

        // Đóng dropdown
        $('.task-menu-dropdown').removeClass('show').addClass('hidden');

        // Hiển thị confirm dialog
        if (confirm(`Bạn có chắc chắn muốn xóa task "${taskName}"?\n\nLưu ý: Tất cả todos trong task này cũng sẽ bị xóa!`)) {
            deleteTask(taskId, taskName);
        }
    });

    // Hàm hiển thị modal đổi tên task
    function showRenameTaskModal(taskId, taskName) {
        $('#renameTaskModal').removeClass('hidden');
        $('#renameTaskId').val(taskId);
        $('#newTaskName').val(taskName);
        $('#newTaskName').focus();
    }

    // Hàm xóa task
    function deleteTask(taskId, taskName) {
        // Hiển thị loading
        const taskColumn = $(`.task-column[data-task-id="${taskId}"]`);
        taskColumn.addClass('opacity-50');

        // Gửi AJAX để xóa task
        $.ajax({
            url: '${pageContext.request.contextPath}/task',
            type: 'POST',
            dataType: 'json',
            data: {
                action: 'deleteTask',
                taskId: taskId
            },
            success: function (response) {
                if (response.success) {
                    // Xóa task column khỏi giao diện
                    taskColumn.fadeOut(300, function () {
                        $(this).remove();
                    });

                    // Hiển thị thông báo thành công
                    alert(`✅ Đã xóa task: "${taskName}"`);

                    // Refresh trang sau 1 giây
                    setTimeout(function () {
                        window.location.reload();
                    }, 1000);
                } else {
                    // Bỏ loading nếu có lỗi
                    taskColumn.removeClass('opacity-50');
                    alert('Lỗi: ' + (response.error || 'Không thể xóa task'));
                }
            },
            error: function () {
                // Bỏ loading nếu có lỗi
                taskColumn.removeClass('opacity-50');
                alert('Lỗi khi gửi yêu cầu xóa task');
            }
        });
    }

    // Đóng modal đổi tên task
    $('#closeRenameTaskModal, #cancelRenameTask').on('click', function () {
        $('#renameTaskModal').addClass('hidden');
        $('#renameTaskForm')[0].reset();
    });

    // Đóng modal khi click ra ngoài
    $('#renameTaskModal').on('mousedown', function (e) {
        if (e.target === this) {
            $('#renameTaskModal').addClass('hidden');
            $('#renameTaskForm')[0].reset();
        }
    });

    // Lưu thay đổi tên task
    $('#saveRenameTask').on('click', function () {
        const taskId = $('#renameTaskId').val();
        const newTaskName = $('#newTaskName').val().trim();

        if (!newTaskName) {
            alert('Vui lòng nhập tên task mới!');
            return;
        }

        // Gửi AJAX để cập nhật tên task
        $.ajax({
            url: '${pageContext.request.contextPath}/task',
            type: 'POST',
            dataType: 'json',
            data: {
                action: 'updateTaskName',
                taskId: taskId,
                newTaskName: newTaskName
            },
            success: function (response) {
                if (response.success) {
                    // Cập nhật tên task trên giao diện
                    const taskColumn = $(`.task-column[data-task-id="${taskId}"]`);
                    taskColumn.find('h3').text(newTaskName);

                    // Cập nhật data-task-name cho các nút
                    taskColumn.find('.task-menu-btn, .rename-task-btn').attr('data-task-name', newTaskName);

                    // Đóng modal
                    $('#renameTaskModal').addClass('hidden');
                    $('#renameTaskForm')[0].reset();

                    // Hiển thị thông báo thành công
                    alert(`✅ Đã đổi tên task thành: "${newTaskName}"`);

                    location.reload();
                } else {
                    alert('Lỗi: ' + (response.error || 'Không thể đổi tên task'));
                }
            },
            error: function (xhr, status, error) {
                console.error('AJAX Error:', status, error);
                console.error('Response:', xhr.responseText);
                alert('Lỗi khi gửi dữ liệu đến server: ' + error);
            }
        });
    });

    // Xử lý phím Enter trong modal đổi tên
    $('#newTaskName').on('keypress', function (e) {
        if (e.which === 13) { // Enter key
            e.preventDefault();
            $('#saveRenameTask').click();
        }
    });

    // Xử lý nút edit todo
    $(document).on('click', '.edit-todo-btn', function (e) {
        e.preventDefault();
        e.stopPropagation();

        const todoId = $(this).data('todo-id');
        const taskId = $(this).data('task-id');
        const taskItem = $(this).closest('.task-item');

        // Lấy dữ liệu todo từ DOM
        const todoTitle = taskItem.find('.text-sm.font-medium').text();
        const todoDescription = taskItem.find('.text-sm.text-gray-600').text() || '';
        const dueDateSpan = taskItem.find('.inline-flex');
        let dueDate = '';
        let dueTime = '';

        if (dueDateSpan.length > 0) {
            const dateText = dueDateSpan.text().trim().replace(/\n/g, '').replace(/\r/g, '');
            // Giả sử format là "YYYY-MM-DD HH:MM" hoặc "YYYY-MM-DD"
            if (dateText.includes(' ')) {
                const parts = dateText.split(' ');
                dueDate = parts[0].trim();
                dueTime = parts[1].trim();
            } else {
                dueDate = dateText.trim();
            }
        }

        // Lấy dữ liệu đầy đủ từ server
        $.ajax({
            url: '${pageContext.request.contextPath}/todo',
            type: 'POST',
            dataType: 'json',
            data: {
                action: 'getTodoDetail',
                todoId: todoId
            },
            success: function (response) {
                if (response.success && response.todo) {
                    const todo = response.todo;
                    // Làm sạch dữ liệu từ server
                    const dueDateParts = todo.dueDate ? todo.dueDate.split(' ') : ['', ''];
                    showEditTodoModal(
                            todo.idTodo,
                            taskId,
                            todo.title,
                            todo.description,
                            dueDateParts[0] || '',
                            dueDateParts[1] || '',
                            todo.isAllDay
                            );
                } else {
                    // Fallback: sử dụng dữ liệu từ DOM
                    showEditTodoModal(todoId, taskId, todoTitle, todoDescription, dueDate, dueTime, false);
                }
            },
            error: function () {
                // Fallback: sử dụng dữ liệu từ DOM
                showEditTodoModal(todoId, taskId, todoTitle, todoDescription, dueDate, dueTime, false);
            }
        });
    });

    // Hàm hiển thị modal edit todo
    function showEditTodoModal(todoId, taskId, title, description, dueDate, dueTime, isAllDay) {
        // Debug: log dữ liệu trước khi xử lý
        console.log('Raw data:', {todoId, taskId, title, description, dueDate, dueTime, isAllDay});

        $('#editTodoModal').removeClass('hidden');
        $('#editTodoId').val(todoId);
        $('#editTodoTitle').val(title ? title.trim() : '');
        $('#editTodoDescription').val(description ? description.trim() : '');

        // Làm sạch và validate dữ liệu ngày
        const cleanDueDate = dueDate ? dueDate.trim().replace(/\n/g, '').replace(/\r/g, '') : '';
        const cleanDueTime = dueTime ? dueTime.trim().replace(/\n/g, '').replace(/\r/g, '') : '';

        // Chỉ set giá trị nếu định dạng hợp lệ
        if (cleanDueDate && /^\d{4}-\d{2}-\d{2}$/.test(cleanDueDate)) {
            $('#editTodoDueDate').val(cleanDueDate);
            console.log('Set dueDate:', cleanDueDate);
        } else {
            $('#editTodoDueDate').val('');
            console.log('Invalid dueDate:', cleanDueDate);
        }

        if (cleanDueTime) {
            // Xử lý các định dạng time khác nhau
            let timeValue = cleanDueTime;

            // Nếu có format "HH:MM:SS" hoặc "HH:MM:SS.SSS", chỉ lấy "HH:MM"
            if (timeValue.includes(':')) {
                const timeParts = timeValue.split(':');
                if (timeParts.length >= 2) {
                    timeValue = timeParts[0] + ':' + timeParts[1];
                }
            }

            // Validate định dạng HH:MM
            if (/^\d{2}:\d{2}$/.test(timeValue)) {
                $('#editTodoDueTime').val(timeValue);
                console.log('Set dueTime:', timeValue);
            } else {
                $('#editTodoDueTime').val('');
                console.log('Invalid dueTime:', timeValue);
            }
        } else {
            $('#editTodoDueTime').val('');
            console.log('Empty dueTime');
        }

        $('#editTodoAllDay').prop('checked', isAllDay);
        $('#editTodoTitle').focus();
    }

    // Đóng modal edit todo
    $('#closeEditTodoModal').on('click', function () {
        $('#editTodoModal').addClass('hidden');
        $('#editTodoForm')[0].reset();
    });

    // Đóng modal khi click ra ngoài
    $('#editTodoModal').on('mousedown', function (e) {
        if (e.target === this) {
            $('#editTodoModal').addClass('hidden');
            $('#editTodoForm')[0].reset();
        }
    });

    // Lưu thay đổi todo
    $('#saveEditTodo').on('click', function () {
        const todoId = $('#editTodoId').val();
        const title = $('#editTodoTitle').val().trim();
        const description = $('#editTodoDescription').val().trim();
        const dueDate = $('#editTodoDueDate').val();
        const dueTime = $('#editTodoDueTime').val();
        const isAllDay = $('#editTodoAllDay').is(':checked');

        if (!title || !dueDate) {
            alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
            return;
        }

        // Gửi AJAX để cập nhật todo
        $.ajax({
            url: '${pageContext.request.contextPath}/todo',
            type: 'POST',
            dataType: 'json',
            data: {
                action: 'updateTodo',
                todoId: todoId,
                title: title,
                description: description,
                dueDate: dueDate,
                dueTime: dueTime,
                isAllDay: isAllDay ? 'on' : 'off'
            },
            success: function (response) {
                if (response.success) {
                    // Cập nhật giao diện
                    const taskItem = $(`.task-item[data-todo-id="${todoId}"]`);
                    taskItem.find('.text-sm.font-medium').text(title);

                    // Cập nhật ngày đến hạn nếu có
                    const dueDateSpan = taskItem.find('.inline-flex');
                    if (dueDate) {
                        let displayDate = dueDate;
                        if (dueTime && !isAllDay) {
                            displayDate += ' ' + dueTime;
                        }

                        if (dueDateSpan.length > 0) {
                            dueDateSpan.text(displayDate);
                        } else {
                            // Tạo span mới nếu chưa có
                            const newSpan = $(`<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">${displayDate}</span>`);
                            taskItem.find('.flex-1').append(newSpan);
                        }
                    }

                    // Đóng modal
                    $('#editTodoModal').addClass('hidden');
                    $('#editTodoForm')[0].reset();

                    // Hiển thị thông báo thành công
                    alert(`✅ Đã cập nhật todo: "${title}"`);
                } else {
                    alert('Lỗi: ' + (response.error || 'Không thể cập nhật todo'));
                }
            },
            error: function () {
                alert('Lỗi khi gửi dữ liệu đến server');
            }
        });
    });

    // Xử lý nút xóa todo trong modal edit
    $('#deleteEditTodo').on('click', function () {
        const todoId = $('#editTodoId').val();
        const title = $('#editTodoTitle').val().trim();

        if (!todoId) {
            alert('Không tìm thấy thông tin todo để xóa!');
            return;
        }

        // Hiển thị dialog xác nhận
        if (confirm(`Bạn có chắc chắn muốn xóa todo "${title}"?`)) {
            // Gửi AJAX để xóa todo
            $.ajax({
                url: '${pageContext.request.contextPath}/todo',
                type: 'POST',
                dataType: 'json',
                data: {
                    action: 'deleteTodo',
                    todoId: todoId
                },
                success: function (response) {
                    if (response.success) {
                        // Xóa todo item khỏi giao diện
                        const taskItem = $(`.task-item[data-todo-id="${todoId}"]`);
                        const taskColumn = taskItem.closest('.task-column');
                        const taskId = taskColumn.attr('data-task-id');

                        // Thêm hiệu ứng fade out
                        taskItem.fadeOut(300, function () {
                            taskItem.remove();

                            // Cập nhật số lượng todo trong sidebar
                            safeUpdateTodoCount(taskId, false);

                            // Đóng modal
                            $('#editTodoModal').addClass('hidden');
                            $('#editTodoForm')[0].reset();

                            // Hiển thị thông báo thành công
                            alert(`✅ Đã xóa todo: "${title}"`);
                        });
                    } else {
                        alert('Lỗi: ' + (response.error || 'Không thể xóa todo'));
                    }
                },
                error: function () {
                    alert('Lỗi khi gửi dữ liệu đến server');
                }
            });
        }
    });

    // Xử lý phím Enter trong modal edit
    $('#editTodoTitle, #editTodoDueDate').on('keypress', function (e) {
        if (e.which === 13) { // Enter key
            e.preventDefault();
            $('#saveEditTodo').click();
        }
    });
    // Modal tạo Task mới
    function showAddTaskModal() {
        $('#addTaskModal').removeClass('hidden');
        $('#addTaskForm')[0].reset();
    }
    // Sự kiện mở modal khi bấm nút "Tạo danh sách mới"
    $('#addTaskBtn').on('click', function (e) {
        e.preventDefault();
        showAddTaskModal();
    });
    // Đóng modal khi bấm nút X
    $('#closeAddTaskModal').on('click', function () {
        $('#addTaskModal').addClass('hidden');
        $('#addTaskForm')[0].reset();
    });
    // Đóng modal khi click ra ngoài vùng modal
    $('#addTaskModal').on('mousedown', function (e) {
        if (e.target === this || $(e.target).hasClass('flex')) {
            $('#addTaskModal').addClass('hidden');
            $('#addTaskForm')[0].reset();
        }
    });
    // Sự kiện lưu Task
    $('#saveTask').on('click', function () {
        // Lấy dữ liệu từ form
        const formData = {
            name: $('#taskName').val(),
            color: $('#taskColor').val()
        };
        // Kiểm tra dữ liệu bắt buộc
        if (!formData.name) {
            alert('Vui lòng nhập tên Task!');
            return;
        }
        // Gửi AJAX lên server để tạo Task mới
        $.ajax({
            url: 'task',
            type: 'POST',
            dataType: 'json',
            data: {
                action: 'createTask',
                name: formData.name,
                color: formData.color
            },
            success: function (response) {
                if (response.success) {
                    alert('Task đã được tạo thành công!');
                    $('#addTaskModal').addClass('hidden');
                    $('#addTaskForm')[0].reset();
                    location.reload();
                } else {
                    alert('Lỗi: ' + (response.error || 'Không thể tạo Task'));
                }
            },
            error: function () {
                alert('Lỗi khi gửi dữ liệu đến server');
            }
        });
    });

</script>