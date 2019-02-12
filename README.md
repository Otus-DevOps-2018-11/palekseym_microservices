# palekseym_microservices
palekseym microservices repository

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
