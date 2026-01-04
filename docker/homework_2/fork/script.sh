#!/bin/bash

REPO_URL="https://github.com/Khurmatov/education.git"
TARGET_DIR="/opt"

if [ -d "$TARGET_DIR" ]; then
  echo "Обновление репозитория..."
  cd /opt/docker/homework_2/fork
  git pull
else
  echo "Клонирование репозитория..."
  git clone $REPO_URL $TARGET_DIR
  cd /opt/docker/homework_2/fork
fi

echo "Запуск проекта..."
docker compose up -d

echo "Данные скопированы"