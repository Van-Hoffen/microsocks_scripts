#!/bin/bash
# microsocks-auth-setup.sh
# MicroSocks с аутентификацией

apt update
apt install -y git build-essential curl
git clone https://github.com/rofl0r/microsocks.git
cd microsocks
make
cp microsocks /usr/local/bin/

# Создаем файл с логинами и паролями
echo "Введите имя пользователя:"
read username
echo "Введите пароль:"
read -s password

# Создаем файл аутентификации
echo "$username $password" > /etc/microsocks-auth.conf
chmod 600 /etc/microsocks-auth.conf

# Создание systemd сервиса с аутентификацией
cat > /etc/systemd/system/microsocks.service << EOF
[Unit]
Description=MicroSocks SOCKS5 Proxy with Auth
After=network.target

[Service]
ExecStart=/usr/local/bin/microsocks -p 1080 -u /etc/microsocks-auth.conf
Restart=always
User=nobody

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start microsocks
systemctl enable microsocks

# Определяем внешний IP (можно заменить сервис при необходимости)
external_ip=$(curl -s ifconfig.me)

echo "=========================================="
echo "MicroSocks с аутентификацией запущен!"
echo "Порт: 1080"
echo "Пользователь: $username"
echo "Пароль: $password"
echo "=========================================="
echo "Ссылка для Telegram:"
echo "tg://socks?server=${external_ip}&port=1080&user=${username}&pass=${password}"
echo "=========================================="
