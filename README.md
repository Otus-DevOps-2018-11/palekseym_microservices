# palekseym_microservices
palekseym microservices repository

# ДЗ 16. Устройство Gitlab CI. Построение процесса непрерывной поставки

## Основное задание

- Создал виртуальную машину docker-host-ci с докером через docker-machine
- Настроил инсталацию Gitlab CI
- Разместил исходний код приложения reddit и настроил pipeline
- в pipeline опробованно:
  - автоматическое создание окружений
  - создание окружений stage и production по кнопке
  - cоздание окружений stage и production при условии проставления тега
  - создание окружения динамачески при создании новой ветки

# ДЗ 15. Docker: сети,docker-compose
## Основное задание
- Создал докер хост
<details><summary>Пример</summary>

```
tay@ubuntu:~/repo/palekseym_microservices$ docker-machine ls
NAME          ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER     ERRORS
docker-host   *        google   Running   tcp://34.76.164.240:2376           v18.09.2
```
</details>

- Запустил контейнер с ситевым драйвером None
<details><summary>Пример</summary>

```
tay@ubuntu:~/repo/palekseym_microservices$ docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig
Unable to find image 'joffotron/docker-net-tools:latest' locally
latest: Pulling from joffotron/docker-net-tools
3690ec4760f9: Pull complete
0905b79e95dc: Pull complete
Digest: sha256:5752abdc4351a75e9daec681c1a6babfec03b317b273fc56f953592e6218d5b5
Status: Downloaded newer image for joffotron/docker-net-tools:latest
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```
</details>

- Запустил контейнер в хост сети
<details><summary>Пример</summary>

```
tay@ubuntu:~/repo/palekseym_microservices$  docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig
docker0   Link encap:Ethernet  HWaddr 02:42:CF:54:18:B2
          inet addr:172.17.0.1  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

ens4      Link encap:Ethernet  HWaddr 42:01:0A:84:00:0E
          inet addr:10.132.0.14  Bcast:10.132.0.14  Mask:255.255.255.255
          inet6 addr: fe80::4001:aff:fe84:e%32603/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1460  Metric:1
          RX packets:4985 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3353 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:82673514 (78.8 MiB)  TX bytes:363552 (355.0 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1%32603/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

```
</details>

- Запустил несколько одинаковых контейнеров с использованием драйвера сети host. Запустился только один потомучто в таком режиме контейнер получает доступ к сети "напрямую" через сетевой интерфейс, а на сетевом интерфейсе нельзя открыть два раза один и тот же порт.
<details><summary>Пример</summary>

```
tay@ubuntu:~/repo/palekseym_microservices$ docker run --network host -d nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
6ae821421a7d: Pull complete
da4474e5966c: Pull complete
eb2aec2b9c9f: Pull complete
Digest: sha256:dd2d0ac3fff2f007d99e033b64854be0941e19a2ad51f174d9240dda20d9f534
Status: Downloaded newer image for nginx:latest
250a2f5eb9d96b181647ca7fd90db70ba1eafe9861da6ef06d3b5e4f80464702
tay@ubuntu:~/repo/palekseym_microservices$ docker run --network host -d nginx
37e98f7eafc4104476eb14643f0a605c93f4fe779479c8ceec010f1e95795d68
tay@ubuntu:~/repo/palekseym_microservices$ docker run --network host -d nginx
a33e2380fb9ebbb2436d4c3b384495bd9de4d952e0ed4d014e30e4fa21a00965

tay@ubuntu:~/repo/palekseym_microservices$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES
a33e2380fb9e        nginx               "nginx -g 'daemon of…"   16 seconds ago      Exited (1) 12 seconds ago                       vigorous_engelbart
37e98f7eafc4        nginx               "nginx -g 'daemon of…"   18 seconds ago      Exited (1) 14 seconds ago                       eloquent_kepler
250a2f5eb9d9        nginx               "nginx -g 'daemon of…"   22 seconds ago      Up 19 seconds                                   happy_williamson
```
</details>

- Рассмотрен сетевые namespace при создании контейнеров с none и host драйверами сети.
  - При создании контейнеров с none драйвером на хосте создаются по одному namespace
  <details><summary>Пример</summary>
  
  ```
  tay@ubuntu:~/repo/palekseym_microservices$ docker run --network none -d nginx
  d78f4e49f36df43c0a30c5c912d8984e996512df8e938d6f17cc57b96721dade
  tay@ubuntu:~/repo/palekseym_microservices$ docker run --network none -d nginx
  144a7220595de320cda08831b3d072c30b228b0dcba39c67078975a77faa88d5
  tay@ubuntu:~/repo/palekseym_microservices$ docker run --network none -d nginx
  ```

  ```
  docker-user@docker-host:~$ sudo ip netns
  8e99adbca4c4
  52dd372c681d
  e5c0b42d3d34
  default
  ```
  </details>

  - При создании контейнеров с host драйвером на хосте новых namespace не создается
  <details><summary>Пример</summary>

  ```
  tay@ubuntu:~/repo/palekseym_microservices$ docker run --network host -d nginx
  0922e4ec74c57b0cc4448aa8638f114924d694c354c167d6618ef3080e1ad9a0
  ```

  ```
  docker-user@docker-host:~$ sudo ip netns
  default
  ```
  </details>

- Создал brige-сеть reddit
  <details><summary>Пример</summary>

  ```
  tay@ubuntu:~/repo/palekseym_microservices$ docker network create reddit --driver bridge
  cae3eeaa0e6f92d49aa8c97dfca2e14893e85750841d7d786c1aa71f88590260
  ```
  ```
  tay@ubuntu:~/repo/palekseym_microservices$ docker network ls
  NETWORK ID          NAME                DRIVER              SCOPE
  1c0de91eda0d        bridge              bridge              local
  6343b6669502        host                host                local
  132469d820fb        none                null                local
  cae3eeaa0e6f        reddit              bridge              local
  ```
  </details>

- Поднял приложение состоящее из четырех контейнеров(mongo, post, comment, ui) с прошлого занятия
<details><summary>Пример</summary>

```
tay@ubuntu:~/repo/palekseym_microservices$ docker run -d --rm --network=reddit --network-alias=post_db mongo:latest
(reverse-i-search)`': docker run -d --rm --network=reddit --network-alias^Cost_db mongo:latest
130 tay@ubuntu:~/repo/palekseym_microservices$ docker run -d --rm --network=reddit --network-alias=post alexeydoc/post:2.0
tay@ubuntu:~/repo/palekseym_microservices$ docker run -d --rm --network=reddit --network-alias=comment alexeydoc/comment:2.0
tay@ubuntu:~/repo/palekseym_microservices$ docker run -d --rm --network=reddit --network-alias=post alexeydoc/post:2.0
130 tay@ubuntu:~/repo/palekseym_microservices$ docker run -d --rm --network=reddit -p 9292:9292 alexeydoc/ui:3.0
```
</details>

- Создал две внутрении сети 10.0.1.0/24 и 10.0.2.0/24
<details><summary>Пример</summary>

```
tay@ubuntu:~/repo/palekseym_microservices$ docker network create back_net --subnet=10.0.2.0/24
tay@ubuntu:~/repo/palekseym_microservices$ docker network create front_net --subnet=10.0.1.0/24
```
</details>

- Контейнеры post, comment, ui, mongodb запущенны в разных сетях
<details><summary>Пример</summary>

```
tay@ubuntu:~/repo/palekseym_microservices$ docker run -d --rm --network=front_net --name ui -p 9292:9292 alexeydoc/ui:3.0
tay@ubuntu:~/repo/palekseym_microservices$ docker run -d --rm --network=back_net --name comment alexeydoc/comment:2.0
tay@ubuntu:~/repo/palekseym_microservices$ docker run -d --rm --network=back_net --name post alexeydoc/post:2.0
tay@ubuntu:~/repo/palekseym_microservices$ docker run -d --rm --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest
tay@ubuntu:~/repo/palekseym_microservices$ docker network connect front_net post
tay@ubuntu:~/repo/palekseym_microservices$ docker network connect front_net comment
```
</details>

- Ознакомился с видом сетевого стека хоста
  - Nat таблица
    <details><summary>Пример</summary>

    ```
    docker-user@docker-host:~$ sudo iptables -nL -t nat
    Chain PREROUTING (policy ACCEPT)
    target     prot opt source               destination
    DOCKER     all  --  0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

    Chain INPUT (policy ACCEPT)
    target     prot opt source               destination

    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination
    DOCKER     all  --  0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

    Chain POSTROUTING (policy ACCEPT)
    target     prot opt source               destination
    MASQUERADE  all  --  10.0.1.0/24          0.0.0.0/0
    MASQUERADE  all  --  10.0.2.0/24          0.0.0.0/0
    MASQUERADE  all  --  172.18.0.0/16        0.0.0.0/0
    MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0
    MASQUERADE  tcp  --  10.0.1.2             10.0.1.2             tcp dpt:9292

    Chain DOCKER (2 references)
    target     prot opt source               destination
    RETURN     all  --  0.0.0.0/0            0.0.0.0/0
    RETURN     all  --  0.0.0.0/0            0.0.0.0/0
    RETURN     all  --  0.0.0.0/0            0.0.0.0/0
    RETURN     all  --  0.0.0.0/0            0.0.0.0/0
    DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:9292 to:10.0.1.2:9292
    ```
    </details>

  - Bridge-интерфейсы
    <details><summary>Пример</summary>

    ```
    docker-user@docker-host:~$ ifconfig | grep br
    br-cae3eeaa0e6f Link encap:Ethernet  HWaddr 02:42:7f:76:26:36
    br-e483e596504c Link encap:Ethernet  HWaddr 02:42:35:f0:e3:ed
    br-efb362bda50f Link encap:Ethernet  HWaddr 02:42:1b:36:29:5a
    ```
    </details>

- Создал параметризированный docker-compose файл, а также файл с переменными .env:
  - UI_VER -  версия приложения ui
  - UI_PORT - порт публикации приложения (через этот порт оно доступно для пользователя) 
  - POST_VER - версия приложения post
  - COMMENT_VER - версия приложения comment
  - COMPOSE_PROJECT_NAME - через эту переменную задается базовое имя проекта docker-compose

- Из docker-compose.yml файла запущены контейнеры с разбивкой по разным сетям (алиасам)
  <details><summary>Пример</summary>
  
  ```
  tay@ubuntu:~/repo/palekseym_microservices/src$ docker-compose up -d
  Creating network "my_back_net" with the default driver
  Creating network "my_front_net" with the default driver
  Creating my_comment_1 ... done
  Creating my_ui_1      ... done
  Creating my_post_1    ... done
  Creating my_post_db_1 ... done

  tay@ubuntu:~/repo/palekseym_microservices/src$ docker ps
  CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                  NAMES
  d5560f0ad3a5        mongo:3.2               "docker-entrypoint.s…"   28 seconds ago      Up 25 seconds       27017/tcp              my_post_db_1
  86f3ec0be48b        alexeydoc/post:2.0      "python3 post_app.py"    28 seconds ago      Up 24 seconds                              my_post_1
  9721dcfba1b1        alexeydoc/ui:3.0        "puma"                   28 seconds ago      Up 25 seconds       0.0.0.0:80->9292/tcp   my_ui_1
  0312d6815348        alexeydoc/comment:2.0   "puma"                   29 seconds ago      Up 26 seconds                              my_comment_1

  tay@ubuntu:~/repo/palekseym_microservices/src$ docker network ls
  NETWORK ID          NAME                DRIVER              SCOPE
  e98480dd81fa        bridge              bridge              local
  bf421695dcc8        host                host                local
  9473f0d45995        my_back_net         bridge              local
  16cdd7e191ff        my_front_net        bridge              local
  4bccadb30678        none                null                local
  tay@ubuntu:~/repo/palekseym_microservices/src$
  ```
  </details>

## Задание со *
- Создал файл docker-compose.override.yml для переопределения настроек из docker-compose.yml чтобы можно было изменять код приложений без сборки образов
  <details><summary>Пример</summary>

  ```
  tay@ubuntu:~/repo/palekseym_microservices/src$ docker-compose up -d
  Creating network "my_front_net" with the default driver
  Creating network "my_back_net" with the default driver
  Creating my_post_1    ... done
  Creating my_ui_1      ... done
  Creating my_comment_1 ... done
  Creating my_post_db_1 ... done
  tay@ubuntu:~/repo/palekseym_microservices/src$ docker ps
  CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                  NAMES
  dad4ddc59eb6        mongo:3.2               "docker-entrypoint.s…"   7 seconds ago       Up 3 seconds        27017/tcp              my_post_db_1
  0b3d4dbbeacc        alexeydoc/comment:2.0   "puma --debug -w 2"      7 seconds ago       Up 3 seconds                               my_comment_1
  6dbb4efdd968        alexeydoc/ui:3.0        "puma --debug -w 2"      7 seconds ago       Up 3 seconds        0.0.0.0:80->9292/tcp   my_ui_1
  892b7e8cf252        alexeydoc/post:2.0      "python3 post_app.py"    7 seconds ago       Up 4 seconds                               my_post_1
  ```
  </details>

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
