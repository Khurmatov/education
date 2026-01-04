#!/bin/bash

REPO_URL="https://github.com/Khurmatov/education/docker/homework 2/fork.git"
TARGET_DIR="/opt"

if [ -d "$TARGET_DIR" ]; then
  echo "Обновление репозитория..."
  cd $TARGET_DIR
  git pull
else
  echo "Клонирование репозитория..."
  git clone $REPO_URL $TARGET_DIR
  cd $TARGET_DIR
fi

echo "Запуск проекта..."
docker compose up -d

echo "Данные скопированы"