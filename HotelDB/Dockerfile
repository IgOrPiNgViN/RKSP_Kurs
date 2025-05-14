FROM python:3.12-slim AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y gcc python3-dev default-libmysqlclient-dev build-essential pkg-config netcat-openbsd libmariadb-dev
COPY requirements.txt requirements.txt
RUN python -m venv /opt/venv && /opt/venv/bin/pip install --upgrade pip && /opt/venv/bin/pip install -r requirements.txt \
    && /opt/venv/bin/pip freeze > /app/pip-freeze.txt
ENV PATH="/opt/venv/bin:$PATH"
ENV MYSQLCLIENT_VERSION=2.2.0
FROM python:3.12-slim
ENV PATH="/opt/venv/bin:$PATH"
COPY --from=builder /opt/venv /opt/venv
WORKDIR /app
RUN apt-get update && apt-get install -y default-libmysqlclient-dev libmariadb-dev
COPY . .
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh
RUN useradd -ms /bin/bash appuser && chown -R appuser /app
EXPOSE 8086
CMD ["/bin/bash", "-c", "/wait-for-it.sh db:3306 -- python manage.py migrate && python manage.py collectstatic --noinput && python manage.py runserver 0.0.0.0:8086"] 