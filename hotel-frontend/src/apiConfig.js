// Универсальный базовый адрес API
const API_BASE =
    process.env.REACT_APP_API_URL ||
    (window.location.hostname === "localhost"
        ? "http://localhost:8086"
        : "http://78.24.223.206:8086");

export default API_BASE; 