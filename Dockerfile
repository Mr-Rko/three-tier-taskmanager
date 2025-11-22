FROM python:3.11-alpine

WORKDIR /app/backend

COPY requirements.txt /app/backend
# Install system dependencies for mysqlclient
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    mariadb-dev \
    pkgconfig \
    curl \
    && rm -rf /var/cache/apk/*
RUN pip install -r requirements.txt
RUN pip install mysqlclient

COPY . /app/backend