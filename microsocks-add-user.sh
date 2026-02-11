#!/bin/bash
# microsocks-add-user.sh
# Добавление нового пользователя для MicroSocks и генерация ссылки для Telegram

AUTH_FILE="/etc/microsocks-auth.conf"
PORT=1080

if ! command -v curl >/dev/null 2>&1; then
  apt update
  apt install -y curl
fi

echo "Введите имя нового пользователя:"
read username
echo "Введите пароль:"
read -s password

# Добавляем пользователя в файл авторизации
echo "${username} ${password}" >> "$AUTH_FILE"
chmod 600 "$AUTH_FILE"

# Получаем внешний IP сервера
external_ip=$(curl -s ifconfig.me)

echo "=========================================="
echo "Добавлен новый пользователь для MicroSocks"
echo "Пользователь: $username"
echo "Пароль: $password"
echo "=========================================="
echo "Ссылка для Telegram:"
echo "tg://socks?server=${external_ip}&port=${PORT}&user=${username}&pass=${password}"
echo "=========================================="
