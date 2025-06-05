# Система бронирования отелей

## 🧱 Стек технологий

* Python 3.8+
* Django 3.2
* Django REST Framework
* MySQL 8.0
* React.js
* Docker & Docker Compose

## 🚀 Развертывание проекта

### 1. Подготовка окружения

#### 1.1. Установка Docker и Docker Compose

1. Скачайте и установите Docker Desktop с официального сайта: <https://www.docker.com/products/docker-desktop/>
2. Проверьте установку:

   ```
   docker --version
   docker-compose --version
   ```

### 2. Клонирование репозитория

1. Откройте командную строку
2. Перейдите в нужную директорию
3. Выполните команду:

   ```
   git clone https://github.com/IgOrPiNgViN/RKSP_Kurs.git
   cd RKSP_Kurs
   ```

### 3. Настройка проекта

#### 3.1. Настройка переменных окружения

1. В корневой директории проекта создайте файл `.env` со следующими параметрами:

   ```
   DEBUG=False
   DJANGO_SETTINGS_MODULE=HotelDB.settings
   MYSQL_DATABASE=bd
   MYSQL_USER=hotel_user
   MYSQL_PASSWORD=1234
   MYSQL_HOST=db
   ALLOWED_HOSTS=78.24.223.206,localhost,127.0.0.1
   ```

### 4. Запуск проекта

#### 4.1. Запуск с помощью Docker Compose

```
docker-compose up -d
```

#### 4.2. Проверка работоспособности

1. Бэкенд API доступен по адресу: <http://localhost:8086>
2. Фронтенд доступен по адресу: <http://localhost:3003>
3. Админ-панель: <http://localhost:8086/admin>

### 5. Структура проекта

```
RKSP_Kurs/
├── HotelDB/           # Django бэкенд
├── hotel-frontend/    # React фронтенд
├── db_init/          # Инициализация базы данных
├── docker-compose.yml # Конфигурация Docker
└── README.md         # Документация
```

### 6. Возможные проблемы и их решение

#### 6.1. Ошибки при запуске контейнеров

- Проверьте, что все порты свободны (8086, 3003, 3307)
* Убедитесь, что Docker Desktop запущен
* Проверьте логи контейнеров:

  ```
  docker-compose logs
  ```

#### 6.2. Проблемы с базой данных

- Проверьте доступность MySQL (порт 3307)
* Проверьте правильность учетных данных в .env файле
* При необходимости пересоздайте контейнеры:

  ```
  docker-compose down -v
  docker-compose up -d
  ```

#### 6.3. Проблемы с фронтендом

* Проверьте, что REACT_APP_API_URL в docker-compose.yml указывает на правильный адрес бэкенда
* Очистите кэш браузера
* Проверьте логи фронтенд контейнера:

  ```
  docker-compose logs frontend
  ```

## 🔐 Авторизация

* JWT (JSON Web Token) аутентификация
* Токены доступа и обновления
* Защищенные эндпоинты требуют Bearer токен

## REST API

### Аутентификация

* POST `/api/token/` - Получение JWT токенов
* POST `/api/token/refresh/` - Обновление токена доступа

### Пользователи

* POST `/api/users/register/` - Регистрация нового пользователя
* GET `/api/users/me/` - Информация о текущем пользователе
* PUT `/api/users/me/` - Обновление данных пользователя

### Отели

* GET `/api/hotels/` - Список отелей
* GET `/api/hotels/{id}/` - Детали отеля
* GET `/api/hotels/{id}/rooms/` - Номера отеля

### Бронирования

* POST `/api/bookings/` - Создание бронирования
* GET `/api/bookings/` - Список бронирований пользователя
* GET `/api/bookings/{id}/` - Детали бронирования
* DELETE `/api/bookings/{id}/` - Отмена бронирования

## 🛡️ Безопасность

* JWT аутентификация
* CORS настройки для фронтенда
* Защита от SQL-инъекций
* Валидация входных данных
* Безопасное хранение паролей (хеширование)

## 🧪 Тестирование

```bash
# Запуск тестов
pytest

# Проверка стиля кода
flake8
```
