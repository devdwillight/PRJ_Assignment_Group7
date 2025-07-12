// calendar.js
let currentDate = new Date();
let currentView = 'week';
let websocket = null;
let events = []; // Lưu trữ events hiện tại

// Khởi tạo WebSocket connection
function initWebSocket() {
    try {
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const contextPath = getContextPath();
        const wsUrl = `${protocol}//${window.location.host}/${contextPath}/calendar-realtime`;

        websocket = new WebSocket(wsUrl);

        websocket.onopen = function (event) {
            console.log('WebSocket connected');
        };

        websocket.onmessage = function (event) {
            console.log('Received WebSocket message:', event.data);
            handleWebSocketMessage(event.data);
        };
    } catch (error) {
        console.error('Failed to initialize WebSocket:', error);
    }
}

// Gọi API lấy data tuần
function fetchWeekData(date) {
    const contextPath = getContextPath();
    const url = contextPath ? `/${contextPath}/Calendar` : '/Calendar';
    const fullUrl = url + '?date=' + date.toISOString() + '&view=week';

    showLoading(true);
    fetch(fullUrl)
            .then(function (res) {
                if (!res.ok) {
                    throw new Error('HTTP error! status: ' + res.status);
                }
                return res.json();
            })
            .then(function (data) {
                console.log('Received data:', data);
                if (data.status === 'success') {
                    renderWeekFromServer(data);
                    fetchEvents(date, 'week');
                }
            })
            .catch(function (error) {
                console.error('Error fetching week data:', error);
                renderWeekFromServer(generateDefaultWeekData(date));
            })
            .finally(function () {
                showLoading(false);
            });
}