# Деплой приложения

## Разворачивание серверного приложения

### Листинг 1 – Клонирование проекта

```bash
git clone https://github.com/IgOrPiNgViN/RKSP_Kurs.git
cd RKSP_Kurs
```

### Листинг 2 – Настройка .env файла

```env
DEBUG=True
SECRET_KEY=<ваш_секретный_ключ>
DB_NAME=hotel_db
DB_USER=<пользователь_mysql>
DB_PASSWORD=<пароль_mysql>
DB_HOST=db
DB_PORT=3306
```

### Листинг 3 – Создание образа

```bash
docker build -t hotel-booking-backend .
```

### Листинг 4 – Запуск контейнера

```bash
docker run -d -p 8000:8000 hotel-booking-backend
```

## Разворачивание клиентского приложения

### Листинг 5 – Клонирование проекта

```bash
git clone https://github.com/IgOrPiNgViN/RKSP_Kurs.git
cd RKSP_Kurs/frontend
```

### Листинг 6 – Создание .env файла

```env
VITE_API_URL=http://<ip_адрес_сервиса>:8000
```

### Листинг 7 – Запуск на сервере

```bash
docker build -t hotel-booking-frontend .
docker run -d -p 80:80 hotel-booking-frontend
```

## Альтернативный способ развертывания с помощью Docker Compose

Для одновременного развертывания всех сервисов (бэкенд, фронтенд и база данных) можно использовать Docker Compose:

```bash
# Запуск всех сервисов
docker-compose up -d

# Остановка всех сервисов
docker-compose down
```

Этот метод автоматически настроит все необходимые переменные окружения и связи между сервисами, определенные в файле `docker-compose.yml`.
