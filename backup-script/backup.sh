#!/bin/bash
# Это "shebang" — говорит системе, что скрипт нужно запускать через Bash

# 1. Включаем "строгий режим"
set -euo pipefail
# -e: остановить скрипт при любой ошибке
# -u: остановить, если используется необъявленная переменная
# -o pipefail: если команда в конвейере (|) упала, остановить весь скрипт

# 2. Переменные
SOURCE_DIR="/etc/nginx"          # Что бэкапим
BACKUP_DIR="/tmp/nginx_backups"  # Куда складываем архивы (пока временно)
LOG_FILE="/var/log/nginx_backup.log" # Куда пишем логи
DATE=$(date +%Y-%m-%d_%H-%M-%S)  # Дата и время в формате ГГГГ-ММ-ДД_ЧЧ-ММ-СС

# 3. Функция логирования
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 4. Создаем папку для бэкапов, если её нет
mkdir -p "$BACKUP_DIR"

# 5. Проверяем, существует ли исходная папка
if [ ! -d "$SOURCE_DIR" ]; then
    log "ОШИБКА: Папка $SOURCE_DIR не существует!"
    exit 1
fi

# 6. Создаем архив
log "Начинаю бэкап папки $SOURCE_DIR..."
tar -czf "$BACKUP_DIR/nginx_backup_$DATE.tar.gz" -C /etc nginx

if [ $? -eq 0 ]; then
    log "УСПЕХ: Бэкап создан: $BACKUP_DIR/nginx_backup_$DATE.tar.gz"
else
    log "ОШИБКА: Не удалось создать бэкап!"
    exit 1
fi

# 7. Ротация: удаляем бэкапы старше 7 дней
log "Удаляю бэкапы старше 7 дней..."
find "$BACKUP_DIR" -name "nginx_backup_*.tar.gz" -mtime +7 -delete
log "Ротация завершена."

log "Скрипт завершил работу."
