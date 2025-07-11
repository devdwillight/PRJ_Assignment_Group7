// calendar.js

let currentDate = new Date();
let currentView = 'week';

// Cập nhật label tháng/năm
function updateMonthYearLabel() {
    const monthNames = [
        "Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6",
        "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"
    ];
    const label = document.getElementById('currentMonthYear');
    label.textContent = `${monthNames[currentDate.getMonth()]}, ${currentDate.getFullYear()}`;
}

// Gọi API lấy data tuần
function fetchWeekData(date) {
    fetch(`/Calendar?date=${date.toISOString()}&view=week`)
        .then(res => res.json())
        .then(data => renderWeekFromServer(data));
}

// Render tuần từ data server trả về
function renderWeekFromServer(data) {
    const weekDaysHeader = document.getElementById('weekDaysHeader');
    const weekGridBody = document.getElementById('weekGridBody');
    if (!weekDaysHeader || !weekGridBody) return;

    // Render header ngày/thứ
    weekDaysHeader.innerHTML = '';
    data.days.forEach(day => {
        weekDaysHeader.innerHTML += `
            <div class="py-2 flex-1 flex flex-col items-center ${day.isToday ? "bg-blue-100 rounded" : ""}">
                <span class="text-2xl font-bold ${day.isToday ? "text-red-500" : "text-blue-600"}">${day.dayOfMonth}</span>
                <span class="text-xs text-gray-500 mt-1 uppercase tracking-wide">${day.label}</span>
            </div>
        `;
    });

    // Render body (23 dòng giờ, 7 cột ngày)
    let body = '';
    data.hours.forEach(h => {
        body += `<div class="grid grid-cols-8 border-b min-h-[48px]">`;
        body += `<div class="py-2 text-right pr-2 text-gray-400 text-xs sticky left-0 bg-white z-10">${h} ${h < 12 ? "AM" : "PM"}</div>`;
        for (let d = 0; d < 7; d++) {
            let isToday = data.days[d].isToday;
            body += `<div class="border-l min-h-[48px] bg-white hover:bg-blue-50 ${isToday ? "bg-blue-50" : ""}" id="cell-${h}-${d}"></div>`;
        }
        body += `</div>`;
    });
    weekGridBody.innerHTML = body;
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
    if (view === 'week') fetchWeekData(currentDate);
    // Nếu muốn hỗ trợ tháng/ngày thì gọi hàm fetchMonthData, fetchDayData tương tự
}

// Gán sự kiện cho các nút
window.onload = function() {
    document.getElementById('prevBtn').onclick = function() {
        if (currentView === 'week') {
            currentDate.setDate(currentDate.getDate() - 7);
            fetchWeekData(currentDate);
        }
        updateMonthYearLabel();
    };
    document.getElementById('nextBtn').onclick = function() {
        if (currentView === 'week') {
            currentDate.setDate(currentDate.getDate() + 7);
            fetchWeekData(currentDate);
        }
        updateMonthYearLabel();
    };
    document.getElementById('todayBtn').onclick = function() {
        currentDate = new Date();
        if (currentView === 'week') fetchWeekData(currentDate);
        updateMonthYearLabel();
    };

    // Dropdown logic
    const dropdownBtn = document.getElementById('dropdownBtn');
    const dropdownContent = document.getElementById('dropdownContent');
    dropdownBtn.onclick = function(e) {
        e.stopPropagation();
        dropdownContent.classList.toggle('hidden');
    };
    document.body.onclick = function() {
        dropdownContent.classList.add('hidden');
    };
    document.querySelectorAll('#dropdownContent > div').forEach(item => {
        item.onclick = function() {
            selectView(this.textContent.toLowerCase());
            dropdownContent.classList.add('hidden');
        };
    });

    // Khi load trang
    updateMonthYearLabel();
    if (document.getElementById('calendarWeek').style.display === 'block') {
        fetchWeekData(currentDate);
    }
}; 