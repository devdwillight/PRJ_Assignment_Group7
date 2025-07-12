// calendar.js

let currentDate = new Date();
let currentView = 'week';
let websocket = null;
let events = []; // Lưu trữ events hiện tại

// Lấy context path động
function getContextPath() {
    const pathname = window.location.pathname;
    // Nếu pathname bắt đầu với /PRJ_Assignment_toidaiii, trả về context path
    if (pathname.startsWith('/PRJ_Assignment_toidaiii')) {
        return 'PRJ_Assignment_toidaiii';
    }
    // Fallback: lấy phần tử đầu tiên của pathname
    return pathname.split('/')[1] || '';
}

// Khởi tạo WebSocket connection
function initWebSocket() {
    try {
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const contextPath = getContextPath();
        const wsUrl = `${protocol}//${window.location.host}/${contextPath}/calendar-realtime`;
        
        websocket = new WebSocket(wsUrl);
        
        websocket.onopen = function(event) {
            console.log('WebSocket connected');
        };
        
        websocket.onmessage = function(event) {
            console.log('Received WebSocket message:', event.data);
            handleWebSocketMessage(event.data);
        };
        
        websocket.onclose = function(event) {
            console.log('WebSocket disconnected');
            // Thử kết nối lại sau 5 giây
            setTimeout(initWebSocket, 5000);
        };
        
        websocket.onerror = function(error) {
            console.error('WebSocket error:', error);
        };
    } catch (error) {
        console.error('Failed to initialize WebSocket:', error);
    }
}

// Xử lý message từ WebSocket
function handleWebSocketMessage(message) {
    try {
        const data = JSON.parse(message);
        
        switch(data.type) {
            case 'event_created':
            case 'event_updated':
            case 'event_deleted':
                // Refresh calendar data khi có thay đổi event
                if (currentView === 'week') {
                    fetchWeekData(currentDate);
                }
                showNotification(data.message || 'Calendar updated');
                break;
                
            case 'reminder':
                showNotification(data.message || 'Reminder: ' + data.title);
                break;
                
            default:
                console.log('Unknown message type:', data.type);
        }
    } catch (error) {
        console.error('Error parsing WebSocket message:', error);
    }
}

// Hiển thị notification
function showNotification(message) {
    // Tạo notification element
    const notification = document.createElement('div');
    notification.className = 'fixed top-4 right-4 bg-blue-500 text-white px-6 py-3 rounded-lg shadow-lg z-50 transform transition-transform duration-300 translate-x-full';
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    // Animate in
    setTimeout(() => {
        notification.classList.remove('translate-x-full');
    }, 100);
    
    // Animate out và remove sau 3 giây
    setTimeout(() => {
        notification.classList.add('translate-x-full');
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Cập nhật label tháng/năm
function updateMonthYearLabel() {
    const monthNames = [
        "Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6",
        "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"
    ];
    const label = document.getElementById('currentMonthYear');
    if (label) {
        label.textContent = monthNames[currentDate.getMonth()] + ', ' + currentDate.getFullYear();
    }
}

// Gọi API lấy data tuần
function fetchWeekData(date) {
    console.log('Fetching week data for:', date.toISOString());
    
    // Hiển thị loading
    showLoading(true);
    
    const contextPath = getContextPath();
    const url = contextPath ? `/${contextPath}/Calendar` : '/Calendar';
    
    console.log('Context path:', contextPath);
    console.log('Full URL:', url + '?date=' + date.toISOString() + '&view=week');
    
    fetch(url + '?date=' + date.toISOString() + '&view=week')
        .then(function(res) {
            console.log('Response status:', res.status);
            if (!res.ok) {
                throw new Error('HTTP error! status: ' + res.status);
            }
            return res.json();
        })
        .then(function(data) {
            console.log('Received data:', data);
            if (data.status === 'success') {
                renderWeekFromServer(data);
                // Sau khi render xong, lấy events
                fetchEvents(date, 'week');
            } else {
                throw new Error(data.message || 'Failed to load calendar data');
            }
        })
        .catch(function(error) {
            console.error('Error fetching week data:', error);
            // Fallback: render với dữ liệu mặc định
            renderWeekFromServer(generateDefaultWeekData(date));
            showNotification('Không thể tải dữ liệu từ server, sử dụng dữ liệu mặc định');
        })
        .finally(function() {
            showLoading(false);
        });
}

// Gọi API lấy events
function fetchEvents(date, view) {
    const contextPath = getContextPath();
    const url = contextPath ? `/${contextPath}/Calendar` : '/Calendar';
    
    fetch(url + '?action=getEvents&date=' + date.toISOString() + '&view=' + view)
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.status === 'success') {
                events = data.events || [];
                renderEvents();
            }
        })
        .catch(function(error) {
            console.error('Error fetching events:', error);
        });
}

// Gọi API lấy data tháng
function fetchMonthData(date) {
    console.log('Fetching month data for:', date.toISOString());
    
    showLoading(true);
    
    const contextPath = getContextPath();
    const url = contextPath ? `/${contextPath}/Calendar` : '/Calendar';
    
    fetch(url + '?date=' + date.toISOString() + '&view=month')
        .then(function(res) {
            if (!res.ok) {
                throw new Error('HTTP error! status: ' + res.status);
            }
            return res.json();
        })
        .then(function(data) {
            console.log('Received month data:', data);
            if (data.status === 'success') {
                if (typeof renderMonthView === 'function') {
                    renderMonthView(data);
                }
                fetchEvents(date, 'month');
            } else {
                throw new Error(data.message || 'Failed to load month data');
            }
        })
        .catch(function(error) {
            console.error('Error fetching month data:', error);
            showNotification('Không thể tải dữ liệu tháng');
        })
        .finally(function() {
            showLoading(false);
        });
}

// Gọi API lấy data ngày
function fetchDayData(date) {
    console.log('Fetching day data for:', date.toISOString());
    
    showLoading(true);
    
    const contextPath = getContextPath();
    const url = contextPath ? `/${contextPath}/Calendar` : '/Calendar';
    
    fetch(url + '?date=' + date.toISOString() + '&view=day')
        .then(function(res) {
            if (!res.ok) {
                throw new Error('HTTP error! status: ' + res.status);
            }
            return res.json();
        })
        .then(function(data) {
            console.log('Received day data:', data);
            if (data.status === 'success') {
                if (typeof renderDayView === 'function') {
                    renderDayView(data);
                }
                fetchEvents(date, 'day');
            } else {
                throw new Error(data.message || 'Failed to load day data');
            }
        })
        .catch(function(error) {
            console.error('Error fetching day data:', error);
            showNotification('Không thể tải dữ liệu ngày');
        })
        .finally(function() {
            showLoading(false);
        });
}

// Render events lên calendar
function renderEvents() {
    // Xóa events cũ
    document.querySelectorAll('.calendar-event').forEach(function(el) {
        el.remove();
    });
    
    events.forEach(function(event) {
        const eventElement = createEventElement(event);
        const cell = findEventCell(event);
        if (cell) {
            cell.appendChild(eventElement);
        }
    });
}

// Tạo element cho event
function createEventElement(event) {
    const eventDiv = document.createElement('div');
    eventDiv.className = 'calendar-event absolute left-0 right-0 mx-1 px-2 py-1 text-xs text-white rounded cursor-pointer hover:opacity-80 transition-opacity';
    eventDiv.style.backgroundColor = event.color || '#4285f4';
    eventDiv.style.top = '2px';
    eventDiv.style.bottom = '2px';
    eventDiv.style.zIndex = '20';
    eventDiv.textContent = event.title;
    
    // Thêm sự kiện click để edit/delete
    eventDiv.addEventListener('click', function(e) {
        e.stopPropagation();
        showEventModal(event);
    });
    
    return eventDiv;
}

// Tìm cell phù hợp cho event
function findEventCell(event) {
    const startDate = new Date(event.start);
    const startHour = startDate.getHours();
    const startDay = startDate.getDay();
    
    return document.getElementById(`cell-${startHour}-${startDay}`);
}

// Hiển thị modal tạo/sửa event
function showEventModal(event) {
    if (event === undefined) event = null;
    
    const modal = document.createElement('div');
    modal.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
    
    let title = event ? 'Sửa sự kiện' : 'Tạo sự kiện mới';
    let eventTitle = event ? event.title : '';
    let eventStart = event ? event.start.replace('Z', '') : '';
    let eventEnd = event ? event.end.replace('Z', '') : '';
    let submitText = event ? 'Cập nhật' : 'Tạo';
    
    let colorOptions = '';
    const colors = [
        {value: '#4285f4', name: 'Xanh dương'},
        {value: '#34a853', name: 'Xanh lá'},
        {value: '#fbbc04', name: 'Vàng'},
        {value: '#ea4335', name: 'Đỏ'},
        {value: '#9c27b0', name: 'Tím'}
    ];
    
    colors.forEach(function(color) {
        let selected = '';
        if (event && event.color === color.value) {
            selected = ' selected';
        }
        colorOptions += '<option value="' + color.value + '"' + selected + '>' + color.name + '</option>';
    });
    
    let deleteButton = '';
    if (event) {
        deleteButton = '<button type="button" id="deleteBtn" class="px-4 py-2 text-red-600 border border-red-300 rounded-md hover:bg-red-50">Xóa</button>';
    }
    
    modal.innerHTML = 
        '<div class="bg-white rounded-lg p-6 w-96 max-w-full mx-4">' +
        '<h3 class="text-lg font-semibold mb-4">' + title + '</h3>' +
        '<form id="eventForm">' +
        '<div class="mb-4">' +
        '<label class="block text-sm font-medium text-gray-700 mb-2">Tiêu đề</label>' +
        '<input type="text" id="eventTitle" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" value="' + eventTitle + '" required>' +
        '</div>' +
        '<div class="mb-4">' +
        '<label class="block text-sm font-medium text-gray-700 mb-2">Ngày bắt đầu</label>' +
        '<input type="datetime-local" id="eventStart" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" value="' + eventStart + '" required>' +
        '</div>' +
        '<div class="mb-4">' +
        '<label class="block text-sm font-medium text-gray-700 mb-2">Ngày kết thúc</label>' +
        '<input type="datetime-local" id="eventEnd" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" value="' + eventEnd + '" required>' +
        '</div>' +
        '<div class="mb-4">' +
        '<label class="block text-sm font-medium text-gray-700 mb-2">Màu sắc</label>' +
        '<select id="eventColor" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">' +
        colorOptions +
        '</select>' +
        '</div>' +
        '<div class="flex justify-end gap-2">' +
        '<button type="button" id="cancelBtn" class="px-4 py-2 text-gray-600 border border-gray-300 rounded-md hover:bg-gray-50">Hủy</button>' +
        deleteButton +
        '<button type="submit" class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600">' + submitText + '</button>' +
        '</div>' +
        '</form>' +
        '</div>';
    
    document.body.appendChild(modal);
    
    // Xử lý sự kiện
    const form = modal.querySelector('#eventForm');
    const cancelBtn = modal.querySelector('#cancelBtn');
    const deleteBtn = modal.querySelector('#deleteBtn');
    
    cancelBtn.addEventListener('click', function() {
        document.body.removeChild(modal);
    });
    
    if (deleteBtn) {
        deleteBtn.addEventListener('click', function() {
            if (confirm('Bạn có chắc muốn xóa sự kiện này?')) {
                deleteEvent(event.id);
                document.body.removeChild(modal);
            }
        });
    }
    
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = {
            title: modal.querySelector('#eventTitle').value,
            start: modal.querySelector('#eventStart').value + 'Z',
            end: modal.querySelector('#eventEnd').value + 'Z',
            color: modal.querySelector('#eventColor').value
        };
        
        if (event) {
            formData.id = event.id;
            updateEvent(formData);
        } else {
            createEvent(formData);
        }
        
        document.body.removeChild(modal);
    });
}

// Tạo event mới
function createEvent(eventData) {
    const contextPath = getContextPath();
    const url = contextPath ? `/${contextPath}/Calendar` : '/Calendar';

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            action: 'createEvent',
            title: eventData.title,
            start: eventData.start,
            end: eventData.end,
            color: eventData.color
        })
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.status === 'success') {
            showNotification('Tạo sự kiện thành công!');
            fetchWeekData(currentDate); // Refresh calendar
        } else {
            showNotification('Lỗi: ' + data.message);
        }
    })
    .catch(function(error) {
        console.error('Error creating event:', error);
        showNotification('Lỗi khi tạo sự kiện');
    });
}

// Cập nhật event
function updateEvent(eventData) {
    const contextPath = getContextPath();
    const url = contextPath ? `/${contextPath}/Calendar` : '/Calendar';

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            action: 'updateEvent',
            id: eventData.id,
            title: eventData.title,
            start: eventData.start,
            end: eventData.end,
            color: eventData.color
        })
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.status === 'success') {
            showNotification('Cập nhật sự kiện thành công!');
            fetchWeekData(currentDate); // Refresh calendar
        } else {
            showNotification('Lỗi: ' + data.message);
        }
    })
    .catch(function(error) {
        console.error('Error updating event:', error);
        showNotification('Lỗi khi cập nhật sự kiện');
    });
}

// Xóa event
function deleteEvent(eventId) {
    const contextPath = getContextPath();
    const url = contextPath ? `/${contextPath}/Calendar` : '/Calendar';

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            action: 'deleteEvent',
            id: eventId
        })
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.status === 'success') {
            showNotification('Xóa sự kiện thành công!');
            fetchWeekData(currentDate); // Refresh calendar
        } else {
            showNotification('Lỗi: ' + data.message);
        }
    })
    .catch(function(error) {
        console.error('Error deleting event:', error);
        showNotification('Lỗi khi xóa sự kiện');
    });
}

// Hiển thị/ẩn loading
function showLoading(show) {
    let loadingEl = document.getElementById('calendarLoading');
    if (!loadingEl) {
        loadingEl = document.createElement('div');
        loadingEl.id = 'calendarLoading';
        loadingEl.className = 'fixed inset-0 bg-white bg-opacity-75 flex items-center justify-center z-40';
        loadingEl.innerHTML = `
            <div class="flex items-center space-x-2">
                <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
                <span class="text-gray-600">Đang tải...</span>
            </div>
        `;
        document.body.appendChild(loadingEl);
    }
    loadingEl.style.display = show ? 'flex' : 'none';
}

// Tạo dữ liệu mặc định khi API không hoạt động
function generateDefaultWeekData(date) {
    const days = [];
    const hours = [];
    
    // Tạo 7 ngày trong tuần
    const startOfWeek = new Date(date);
    startOfWeek.setDate(date.getDate() - date.getDay()); // Bắt đầu từ Chủ nhật
    
    for (let i = 0; i < 7; i++) {
        const dayDate = new Date(startOfWeek);
        dayDate.setDate(startOfWeek.getDate() + i);
        
        const dayLabels = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
        const isToday = dayDate.toDateString() === new Date().toDateString();
        
        days.push({
            date: dayDate.toISOString().split('T')[0],
            label: dayLabels[i],
            dayOfMonth: dayDate.getDate(),
            isToday: isToday
        });
    }
    
    // Tạo 24 giờ
    for (let i = 0; i < 24; i++) {
        hours.push(i);
    }
    
    return { days, hours };
}

// Render tuần từ data server trả về
function renderWeekFromServer(data) {
    console.log('Rendering week from server data:', data);
    
    const weekDaysHeader = document.getElementById('weekDaysHeader');
    const weekGridBody = document.getElementById('weekGridBody');
    
    console.log('Week days header element:', weekDaysHeader);
    console.log('Week grid body element:', weekGridBody);
    
    if (!weekDaysHeader || !weekGridBody) {
        console.error('Required DOM elements not found');
        return;
    }

    // Kiểm tra dữ liệu hợp lệ
    if (!data || !data.days || !data.hours) {
        console.error('Invalid data structure:', data);
        return;
    }

    // Render header ngày/thứ
    weekDaysHeader.innerHTML = '';
    data.days.forEach(function(day) {
        let dayClass = 'py-2 flex-1 flex flex-col items-center';
        if (day.isToday) {
            dayClass += ' bg-blue-100 rounded';
        }
        
        let dayNumberClass = 'text-2xl font-bold';
        if (day.isToday) {
            dayNumberClass += ' text-red-500';
        } else {
            dayNumberClass += ' text-blue-600';
        }
        
        weekDaysHeader.innerHTML += 
            '<div class="' + dayClass + '">' +
            '<span class="' + dayNumberClass + '">' + day.dayOfMonth + '</span>' +
            '<span class="text-xs text-gray-500 mt-1 uppercase tracking-wide">' + day.label + '</span>' +
            '</div>';
    });

    // Render body (24 dòng giờ, 7 cột ngày)
    let body = '';
    data.hours.forEach(function(h) {
        body += '<div class="grid grid-cols-8 border-b min-h-[48px] relative">';
        body += '<div class="py-2 text-right pr-2 text-gray-400 text-xs sticky left-0 bg-white z-10">' + h + ':00</div>';
        for (let d = 0; d < 7; d++) {
            let isToday = data.days[d] && data.days[d].isToday;
            let cellClass = 'border-l min-h-[48px] bg-white hover:bg-blue-50 relative cursor-pointer';
            if (isToday) {
                cellClass += ' bg-blue-50';
            }
            body += '<div class="' + cellClass + '" id="cell-' + h + '-' + d + '" onclick="handleCellClick(' + h + ', ' + d + ', \'' + data.days[d].date + '\')"></div>';
        }
        body += '</div>';
    });
    weekGridBody.innerHTML = body;
}

// Xử lý click vào cell
function handleCellClick(hour, day, date) {
    const startTime = new Date(date);
    startTime.setHours(hour, 0, 0, 0);
    
    const endTime = new Date(startTime);
    endTime.setHours(hour + 1, 0, 0, 0);
    
    const eventData = {
        title: '',
        start: startTime.toISOString(),
        end: endTime.toISOString(),
        color: '#4285f4'
    };
    
    showEventModal(eventData);
}

// Chuyển view
function selectView(view) {
    currentView = view;
    document.getElementById('currentViewLabel').textContent =
        view === 'day' ? 'Ngày' : (view === 'week' ? 'Tuần' : 'Tháng');
    document.getElementById('calendarDay').style.display = (view === 'day') ? 'block' : 'none';
    document.getElementById('calendarWeek').style.display = (view === 'week') ? 'block' : 'none';
    document.getElementById('calendarMonth').style.display = (view === 'month') ? 'block' : 'none';
    updateMonthYearLabel();
    
    // Load data cho view tương ứng
    if (view === 'week') {
        fetchWeekData(currentDate);
    } else if (view === 'month') {
        fetchMonthData(currentDate);
    } else if (view === 'day') {
        fetchDayData(currentDate);
    }
}

// Định nghĩa ngoài cùng file
function renderEvents() {
    // Xóa events cũ
    document.querySelectorAll('.calendar-event').forEach(function(el) {
        el.remove();
    });
    events.forEach(function(event) {
        const eventElement = createEventElement(event);
        const cell = findEventCell(event);
        if (cell) {
            cell.appendChild(eventElement);
        }
    });
}

// Gán sự kiện cho các nút
window.onload = function() {
    console.log('calendar.js loaded');
    console.log('Current URL:', window.location.href);
    console.log('Pathname:', window.location.pathname);
    
    var prevBtn = document.getElementById('prevBtn');
    if (prevBtn) {
        prevBtn.onclick = function() {
            if (currentView === 'week') {
                currentDate.setDate(currentDate.getDate() - 7);
                fetchWeekData(currentDate);
            } else if (currentView === 'month') {
                currentDate.setMonth(currentDate.getMonth() - 1);
                fetchMonthData(currentDate);
            } else if (currentView === 'day') {
                currentDate.setDate(currentDate.getDate() - 1);
                fetchDayData(currentDate);
            }
            updateMonthYearLabel();
        };
    }
    var nextBtn = document.getElementById('nextBtn');
    if (nextBtn) {
        nextBtn.onclick = function() {
            if (currentView === 'week') {
                currentDate.setDate(currentDate.getDate() + 7);
                fetchWeekData(currentDate);
            } else if (currentView === 'month') {
                currentDate.setMonth(currentDate.getMonth() + 1);
                fetchMonthData(currentDate);
            } else if (currentView === 'day') {
                currentDate.setDate(currentDate.getDate() + 1);
                fetchDayData(currentDate);
            }
            updateMonthYearLabel();
        };
    }
    var todayBtn = document.getElementById('todayBtn');
    if (todayBtn) {
        todayBtn.onclick = function() {
            currentDate = new Date();
            if (currentView === 'week') {
                fetchWeekData(currentDate);
            } else if (currentView === 'month') {
                fetchMonthData(currentDate);
            } else if (currentView === 'day') {
                fetchDayData(currentDate);
            }
            updateMonthYearLabel();
        };
    }
    // Dropdown logic
    var dropdownBtn = document.getElementById('dropdownBtn');
    var dropdownContent = document.getElementById('dropdownContent');
    if (dropdownBtn && dropdownContent) {
        dropdownBtn.onclick = function(e) {
            e.stopPropagation();
            dropdownContent.classList.toggle('hidden');
        };
        document.body.onclick = function() {
            dropdownContent.classList.add('hidden');
        };
        var dropdownItems = document.querySelectorAll('#dropdownContent > div');
        dropdownItems.forEach(function(item) {
            item.onclick = function() {
                selectView(this.textContent.toLowerCase());
                dropdownContent.classList.add('hidden');
            };
        });
    }
    // Khi load trang
    updateMonthYearLabel();
    var calendarWeek = document.getElementById('calendarWeek');
    console.log('Calendar week element:', calendarWeek);
    console.log('Calendar week display style:', calendarWeek ? calendarWeek.style.display : 'element not found');
    
    if (calendarWeek && calendarWeek.style.display === 'block') {
        console.log('Starting to fetch week data...');
        fetchWeekData(currentDate);
    } else {
        console.log('Calendar week not visible, not fetching data');
    }
    initWebSocket(); // Khởi tạo WebSocket khi trang được tải
}; 