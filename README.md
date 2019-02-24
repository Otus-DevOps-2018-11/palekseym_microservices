# palekseym_microservices
palekseym microservices repository

# ДЗ 14. Docker-образы. Микросервисы
## Основное задание
Созданы 3 докер файла для создания котейнеров
- src/comment/Dockerfile
- src/post-py/Dockerfile
- src/ui/Dockerfile

Выполнил сборку образов
```
sudo docker build -t alexeydoc/post:1.0 ./post-py
sudo docker build -t alexeydoc/comment:1.0 ./comment
sudo docker build -t alexeydoc/ui:1.0 ./ui
```
<details><summary>Результат</summary>

```
tay@ubuntu:~/repo/palekseym_microservices/src$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
alexeydoc/ui        1.0                 306223b2c166        9 seconds ago       828MB
alexeydoc/comment   1.0                 b355f59ee6cf        2 minutes ago       776MB
alexeydoc/post      1.0                 86c7364c9205        6 minutes ago       265MB
mongo               latest              0da05d84b1fe        2 weeks ago         394MB
ruby                2.2                 6c8e6f9667b2        9 months ago        715MB
python              3.6.0-alpine        cb178ebbf0f2        24 months ago       88.6MB
```
</details>

Создал сетья reddit для приложений
<details><summary>Результат</summary>

```
tay@ubuntu:~/repo/palekseym_microservices/src$ sudo docker network list
NETWORK ID          NAME                DRIVER              SCOPE
d73b8567d78f        bridge              bridge              local
14ffa8361cf8        host                host                local
c919371b375f        none                null                local
65e63953322e        reddit              bridge              local
```
</details>

Выполнил сборку образа ui: 2.0

`sudo docker build -t alexeydoc/ui:2.0 ./ui`

<details><summary>Результат</summary>

```
tay@ubuntu:~/repo/palekseym_microservices/src$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
alexeydoc/ui        1.0                 306223b2c166        6 minutes ago       828MB
alexeydoc/ui        2.0                 306223b2c166        6 minutes ago       828MB
alexeydoc/comment   1.0                 b355f59ee6cf        8 minutes ago       776MB
alexeydoc/post      1.0                 86c7364c9205        12 minutes ago      265MB
mongo               latest              0da05d84b1fe        2 weeks ago         394MB
ruby                2.2                 6c8e6f9667b2        9 months ago        715MB
python              3.6.0-alpine        cb178ebbf0f2        24 months ago       88.6MB
```
</details>

Создал том reddit_db для базы данных mongo
```
sudo docker volume create reddit_db
```
<details><summary>Результат</summary>

```
tay@ubuntu:~/repo/palekseym_microservices/src$ sudo docker volume list
DRIVER              VOLUME NAME
local               4e763718d3264300ac5baf2db755874e2acacc2f545dace8b2a54ff7a6a692bb
local               14bc76b62bef2a5dbf4f1592dfe747d0f58ab54184160f00443d7de927ed57f7
local               104b74f620b09d8b4e5ab4d034949ddc4edb8ec6322f7b4dce379e77d89ee2dc
local               f4351f22aa75a05038ae64859711b6a973b8edd772a39cbddf4b953510a6b275
local               reddit_db
```
</details>

Выполнил запуск контейнеров post, comment, post_db с подключенным томом

```
sudo docker run -d --rm --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
sudo docker run -d --rm --network=reddit --network-alias=post alexeydoc/post:1.0 
sudo docker run -d --rm --network=reddit --network-alias=comment alexeydoc/comment:1.0
sudo docker run -d --rm --network=reddit -p 9292:9292 alexeydoc/ui:2.0
```

<details><summary>Результат</summary>

```
tay@ubuntu:~/repo/palekseym_microservices/src$ sudo docker ps
CONTAINER ID        IMAGE                   COMMAND                  CREATED              STATUS              PORTS                    NAMES
6c3a0b40b44e        alexeydoc/ui:2.0        "puma"                   12 seconds ago       Up 11 seconds       0.0.0.0:9292->9292/tcp   kind_euler
9e0ff387534d        alexeydoc/comment:1.0   "puma"                   19 seconds ago       Up 18 seconds                                serene_greider
32774b0044a4        alexeydoc/post:1.0      "python3 post_app.py"    33 seconds ago       Up 32 seconds                                objective_hawking
906c202251c2        mongo:latest            "docker-entrypoint.s…"   About a minute ago   Up About a minute   27017/tcp                quirky_edison
```
</details>

## Первое Здание со *
Выполнил запуск контейнеров с другими сетевыми алиасами
```
sudo docker run -d --rm --network=reddit --network-alias=my_post_db --network-alias=my_comment_db -v reddit_db:/data/db mongo:latest
sudo docker run -d --rm --network=reddit -e "POST_DATABASE_HOST=my_post_db" --network-alias=my_post alexeydoc/post:1.0
sudo docker run -d --rm --network=reddit -e "COMMENT_DATABASE_HOST=my_comment_db" --network-alias=my_comment alexeydoc/comment:1.0
sudo docker run -d --rm --network=reddit -e "POST_SERVICE_HOST=my_post" -e "COMMENT_SERVICE_HOST=my_comment" -p 9292:9292 alexeydoc/ui:2.0
```
<details><summary>Результат</summary>

```
tay@ubuntu:~/repo/palekseym_microservices/src$ sudo docker ps
CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                    NAMES
54c802d4fea4        alexeydoc/ui:2.0        "puma"                   10 seconds ago      Up 9 seconds        0.0.0.0:9292->9292/tcp   lucid_wescoff
e801fcabd583        alexeydoc/comment:1.0   "puma"                   12 seconds ago      Up 11 seconds                                tender_gates
2a9bd990f29e        alexeydoc/post:1.0      "python3 post_app.py"    13 seconds ago      Up 12 seconds                                loving_hertz
9ee95a5ec436        mongo:latest            "docker-entrypoint.s…"   24 seconds ago      Up 23 seconds       27017/tcp                frosty_euler
```
</details>

## Второе Задание со *
Размер контейнеров до оптимизации
```
tay@ubuntu:~/repo/palekseym_microservices/src$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
alexeydoc/ui        1.0                 306223b2c166        About an hour ago   828MB
alexeydoc/ui        2.0                 306223b2c166        About an hour ago   828MB
alexeydoc/comment   1.0                 b355f59ee6cf        About an hour ago   776MB
alexeydoc/post      1.0                 86c7364c9205        About an hour ago   265MB
```
Выполнил отпимизацию post:
- Заменил add на copy
- Объеденил RUN в одну команду
- Добавил параметры отвечающие за очистку кэша после устновки пакетов (--virtual, --no-cache-dir)
```
RUN apk update \
&& apk add --no-cache --virtual .build-deps build-base \
&& pip install --upgrade --no-cache-dir pip \
&& pip install --no-cache-dir -r /app/requirements.txt \
&& apk del .build-deps
```

Выполнил отпимизацию ui на основе alpine:
- Заменил add на copy
- добавлены команды очистки кеша apk

```
RUN apk add --no-cache --virtual .build-deps make gcc libc-dev \
&& gem install bundler --no-ri --no-rdoc -v 1.17.3 \
&& bundle install \
&& apk del .build-deps
```

Выполнил отпимизацию comment на основе alpine
- Заменил add на copy
- добавлены команды очистки кеша apk

```
RUN apk add --no-cache --virtual .build-deps make gcc libc-dev \
&& gem install bundler --no-ri --no-rdoc -v 1.17.3 \
&& bundle install \
&& apk del .build-deps
```

Создал оптемезированные образа

```
sudo docker build -t alexeydoc/comment:2.0 ./comment
sudo docker build -t alexeydoc/ui:3.0 ./ui
sudo docker build -t alexeydoc/post:2.0 ./post-py
```

<details><summary>Результат сравнения размера образа</summary>

До оптимизации

```
tay@ubuntu:~/repo/palekseym_microservices/src$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
alexeydoc/ui        1.0                 306223b2c166        About an hour ago   828MB
alexeydoc/ui        2.0                 306223b2c166        About an hour ago   828MB
alexeydoc/comment   1.0                 b355f59ee6cf        About an hour ago   776MB
alexeydoc/post      1.0                 86c7364c9205        About an hour ago   265MB
```

После оптимизации
```
tay@ubuntu:~/repo/palekseym_microservices/src$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
alexeydoc/post      2.0                 2d831504953a        11 seconds ago      112MB
alexeydoc/ui        3.0                 55c37231ac96        2 minutes ago       155MB
alexeydoc/comment   2.0                 7c8f44addea4        4 minutes ago       152MB
ruby                2.2-alpine          d212148e08f7        11 months ago       107MB
python              3.6.0-alpine        cb178ebbf0f2        24 months ago       88.6MB
```
</details>

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
