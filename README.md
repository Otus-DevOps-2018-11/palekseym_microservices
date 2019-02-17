# palekseym_microservices
palekseym microservices repository

# ДЗ 13. Docker контейнеры
## Задание основное
- Создан новый проект в GCP
- Инструмент gcloud настроил на новый проект
- Через docker-machine создал виртуальную машина с докером в GCP
- Создал правила фаервола в GCP для подключения по порту 9292
- Создал конфигурационный файл mongod.conf для сервера монги
- Создал файл db_config для переменной указывающей приложению на сервер базы данных
- Создал Dockerfile для подготовки образа контейнера
- Подготовил контейнер и разместил его на докер хабе alexeydoc/otus-reddit:1.0
- Проверил работу контейнера alexeydoc/otus-reddit:1.0 на хосте в GCP и локальном хосте

## Задание со *
### Шаблон пакера подготавливающий образ с докером
Шаблон состоит из двух файлов:
Файл шаблона
`docker-monolith/infra/packer/docker.json`

Файл с переменными
`docker-monolith/infra/packer/variables-docker.json` 
Создал роль docker для ansible чтобы установить докер. Роль лежит тут
`docker-monolith/infra/ansible/roles/docker`

### Поднятие инстансов с помощью Terraform, их количество
- Добавил модуль docker-instance в котором описан базовый инстанс. Расположен тут и создает по умолчанию один инстанс (через переменную instance_count можно указать количество)
`docker-monolith/infra/terraform/modules/docker-instance`
- Модуль docker-instance вызывается из файла
`docker-monolith/infra/terraform/stage/main.tf`

### Плейбуки Ansible с использованием динамического инвентори для установки докера и запуска там образа приложения
- Создал плейбук docker.yml для установки докера и зависимостей
`docker-monolith/infra/ansible/playbooks/docker.yml`
- Создал плейбук docker_deploy.yml для запуска контейнера
`docker-monolith/infra/ansible/playbooks/docker_deploy.yml`
- Настроил динамический инвентори по аналогии с предыдущими занятиями. За основу взят скрипт https://github.com/express42/terraform-ansible-example/tree/master/ansible
Используются скрипты:
  - `dynamic_inventory.sh`
  - `terraform.py`

# ДЗ 12. Технология контейнеризации. Введение в Docker
## Задание основное
- Установлен docker
- Настроена интеграция с travis-ci
- Запущен контейнер hello-world
- Проделаны базовая операции
  - Запуск контейнера из образа
  - Остановка контейнера
  - Запуск ранее созданного контейнера
  - Удаление контейнера
  - Удаление образа
- Создан образ palekseym/ubuntu-tmp-file из контейнера
  - Результат вывода команды `docker images` помещен в файл docker-monolith/docker-1.log
- Изучил вывод команд docker inspect контейнера и образа

## Задание со *
Провел сравнение вывода двух команд
```
# Обарз
docker inspect 4c27fa865d4e
# Контейнер
docker inspect 81ae6ebfca76
```
Объяснение отличия образа от контейнер добавлено в файл docker-monolith/docker-1.log
