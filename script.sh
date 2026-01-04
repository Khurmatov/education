#!/bin/bash

REPO_URL="https://github.com/Khurmatov/education.git"
TARGET_DIR="/opt/docker/homework_2/fork"

if [ -d "$TARGET_DIR" ]; then
  echo "Обновление репозитория..."
  cd $TARGET_DIR
  git pull $REPO_URL
else
  echo "Клонирование репозитория..."
  git clone $REPO_URL $TARGET_DIR
  cd $TARGET_DIR
fi

echo "Запуск проекта..."
docker compose up -d

echo "Данные скопированы"