# Ansible Server Setup

Этот репозиторий содержит конфигурацию Ansible для автоматической настройки Ubuntu Server.

## Что настроено:
- Установка базовых утилит (htop, curl, wget, net-tools).
- Установка и запуск Nginx.
- Настройка файрвола UFW (разрешены SSH и HTTP).
- Безопасное хранение пароля `sudo` через **Ansible Vault**.

## Как использовать:
1. Установить Ansible: `pip3 install --user ansible` (или через Homebrew).
2. Настроить `inventory.ini` под свои серверы.
3. Создать `secrets.yml` через `ansible-vault create secrets.yml` (внутри `ansible_become_pass: ваш_пароль`).
4. Запустить: `ansible-playbook site.yml`.
