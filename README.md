# Hotel Booking System API

Серверная часть системы бронирования отелей. Реализована на Django с использованием Django REST Framework и JWT аутентификации.

## 🧱 Стек технологий

- Python 3.8+
- Django 3.2
- Django REST Framework
- MySQL
- JWT Authentication
- Docker & Docker Compose

## 🚀 Разворачивание

### Клонирование проекта

```bash
git clone <ваш_репозиторий>
cd hotel-booking-system
```

### Настройка .env

```env
DEBUG=True
SECRET_KEY=<ваш_секретный_ключ>
DB_NAME=hotel_db
DB_USER=<пользователь_mysql>
DB_PASSWORD=<пароль_mysql>
DB_HOST=db
DB_PORT=3306
```

### Запуск с помощью Docker Compose

```bash
docker-compose up -d
```

## 🔐 Авторизация

- JWT (JSON Web Token) аутентификация
- Токены доступа и обновления
- Защищенные эндпоинты требуют Bearer токен

## REST API

### Аутентификация

- POST `/api/token/` - Получение JWT токенов
- POST `/api/token/refresh/` - Обновление токена доступа

### Пользователи

- POST `/api/users/register/` - Регистрация нового пользователя
- GET `/api/users/me/` - Информация о текущем пользователе
- PUT `/api/users/me/` - Обновление данных пользователя

### Отели

- GET `/api/hotels/` - Список отелей
- GET `/api/hotels/{id}/` - Детали отеля
- GET `/api/hotels/{id}/rooms/` - Номера отеля

### Бронирования

- POST `/api/bookings/` - Создание бронирования
- GET `/api/bookings/` - Список бронирований пользователя
- GET `/api/bookings/{id}/` - Детали бронирования
- DELETE `/api/bookings/{id}/` - Отмена бронирования

## 🛡️ Безопасность

- JWT аутентификация
- CORS настройки для фронтенда
- Защита от SQL-инъекций
- Валидация входных данных
- Безопасное хранение паролей (хеширование)

## 🧪 Тестирование

```bash
# Запуск тестов
pytest

# Проверка стиля кода
flake8
```

## 📝 Лицензия

MIT
