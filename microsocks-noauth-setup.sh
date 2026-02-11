#!/bin/bash
# microsocks-noauth-setup.sh
# Самый простой SOCKS5 без аутентификации

apt update
apt install -y git build-essential
git clone https://github.com/rofl0r/microsocks.git
cd microsocks
make
cp microsocks /usr/local/bin/

# Создание systemd сервиса
cat > /etc/systemd/system/microsocks.service << EOF
[Unit]
Description=MicroSocks SOCKS5 Proxy
After=network.target

[Service]
ExecStart=/usr/local/bin/microsocks -p 1080
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
echo "MicroSocks запущен на порту 1080 (без аутентификации)"
echo "Порт: 1080"
echo "=========================================="
echo "Ссылка для Telegram:"
echo "tg://socks?server=${external_ip}&port=1080"
echo "=========================================="
