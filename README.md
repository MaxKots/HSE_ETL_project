# Учебный ETL-проект на Apache Airflow, PostgreSQL и MongoDB
О чем этот проект?
Этот проект — учебный пример того, как можно организовать ETL-процесс для переноса данных из MongoDB в PostgreSQL с использованием Apache Airflow. Если коротко, то мы берем сырые данные из MongoDB, обрабатываем их и загружаем в PostgreSQL, чтобы потом можно было легко анализировать.

Что используется?
Apache Airflow — главный по автоматизации. Он управляет всеми процессами: когда данные извлекать, как их обрабатывать и куда загружать.

MongoDB — тут хранятся исходные данные: сессии пользователей, поисковые запросы, история цен, обращения в поддержку и т.д.

PostgreSQL — сюда попадают уже обработанные данные, готовые для аналитики.

Генератор данных — специальный сервис, который заполняет MongoDB случайными данными, чтобы было с чем работать.

Docker — чтобы все это легко развернуть и не париться с настройками.

Python — на нем написаны все скрипты для ETL и генерации данных.

Цель проекта — разобраться, как настраивать и автоматизировать процессы обработки данных, а также научиться строить витрины данных для аналитики.

Как все устроено?
Проект состоит из нескольких частей:

DE2025_ETL_PROJECT/
├── .env                        # Настройки для всех сервисов
├── docker-compose.yml          # Конфигурация Docker Compose
├── README.md                   # Описание проекта
├── PROJECT_TASK.md             # Задание на проект
│
├── airflow/                    # Все, что связано с Airflow
│   ├── Dockerfile              # Докерфайл для Airflow
│   ├── requirements.txt        # Зависимости для Airflow
│   ├── config/
│   │   └── airflow.cfg         # Конфигурация Airflow
│   │
│   ├── dags/                   # DAG'и для Airflow
│   │   ├── sql/                # SQL-запросы для витрин
│   │   │   │
│   │   │   ├── support_efficiency_mart.sql        # Витрина эффективности поддержки
│   │   │   └── users_activity_mart.sql            # Витрина активности пользователей
│   │   │
│   │   ├── user_sessions_etl.py            # DAG для переноса данных о сессиях
│   │   ├── event_logs_etl.py               # DAG для переноса логов событий
│   │   ├── search_queries_etl.py           # DAG для переноса поисковых запросов
│   │   ├── user_recommendations_etl.py     # DAG для переноса рекомендаций
│   │   ├── moderation_queue_etl.py         # DAG для переноса очереди модерации
│   │   ├── support_tickets_etl.py          # DAG для переноса обращений в поддержку
│   │   ├── product_price_history_etl.py    # DAG для переноса истории цен
│   │   ├── mart_users_activity.py          # DAG для витрины активности пользователей
│   │   ├── mart_support_efficiency.py      # DAG для витрины эффективности поддержки
│   │   ├── users_activity_pipeline.py      # Автопайплайн для витрины активности
│   │   └── support_efficiency_pipeline.py  # Автопайплайн для витрины эффективности
│   │
│   ├── logs/                   # Логи Airflow
│   └── plugins/                # Плагины для Airflow  
│
├── data_generator/             # Генератор данных для MongoDB
│   ├── Dockerfile              # Докерфайл для генератора
│   ├── generate_data.py        # Скрипт для генерации данных
│   └── requirements.txt        # Зависимости для генератора
│
└── db/                         # Базы данных
    ├── mongo/                  # MongoDB
    └── postgres/               # PostgreSQL

Как запустить проект?
Клонируем репозиторий:

bash
Copy
git clone git@github.com:MaxKots/HSE_ETL_project.git
cd HSE_ETL_project
Запускаем контейнеры:

bash
docker-compose up -d
Открываем Airflow в браузере:

http://localhost:8080
Запускаем DAG'и:

Заходим в интерфейс Airflow.

Вручную запускаем нужные DAG'и.

Генератор данных
Этот сервис создает тестовые данные в MongoDB. Он заполняет базу случайными значениями, чтобы имитировать реальный поток данных.

Какие данные генерируются?
user_sessions — информация о сессиях пользователей.

product_price_history — история изменения цен на товары.

event_logs — логи событий пользователей.

support_tickets — обращения в поддержку.

user_recommendations — рекомендации товаров.

moderation_queue — очередь на модерацию отзывов.

search_queries — поисковые запросы.

Как запустить генератор?
Генератор автоматически запускается после старта MongoDB и заполняет базу тестовыми данными. Количество записей можно настроить в .env-файле.

Как работают пайплайны?
1. Пайплайны репликации данных
Эти пайплайны переносят данные из MongoDB в PostgreSQL. Каждый DAG отвечает за свою таблицу:

DAG ID	Откуда данные	Куда данные
user_sessions_etl	MongoDB.user_sessions	source.user_sessions
event_logs_etl	MongoDB.event_logs	source.event_logs
search_queries_etl	MongoDB.search_queries	source.search_queries
user_recommendations_etl	MongoDB.user_recommendations	source.user_recommendations
moderation_queue_etl	MongoDB.moderation_queue	source.moderation_queue
support_tickets_etl	MongoDB.support_tickets	source.support_tickets
product_price_history_etl	MongoDB.product_price_history	source.product_price_history
Как это работает?
Извлечение (Extract)

Данные забираются из MongoDB с помощью pymongo.

Трансформация (Transform)

Убираем дубликаты.

Приводим данные к нужным форматам.

Разбиваем сложные структуры на простые таблицы.

Загрузка (Load)

Данные записываются в PostgreSQL.

2. Пайплайны для витрин данных
2.1 Витрина активности пользователей (mart.users_activity_mart)
Что это?
Эта витрина показывает, насколько активны пользователи: сколько у них сессий, сколько запросов они делают, как часто обращаются в поддержку и т.д.

Какие данные есть?

user_id — ID пользователя.

total_sessions — общее количество сессий.

first_session_time — время первой сессии.

last_session_time — время последней сессии.

avg_session_duration_min — средняя длительность сессии.

total_search_queries — количество поисковых запросов.

support_tickets_count — количество обращений в поддержку.

recommended_products_count — количество рекомендаций.

2.2 Витрина эффективности поддержки (mart.support_efficiency_mart)
Что это?
Эта витрина показывает, как быстро и эффективно работает поддержка: сколько тикетов обрабатывается, сколько времени уходит на решение проблем и т.д.

Какие данные есть?

created_date — дата создания тикета.

issue_type — тип проблемы.

total_tickets — общее количество тикетов.

open_tickets — количество открытых тикетов.

closed_tickets — количество закрытых тикетов.

avg_resolution_time_minutes — среднее время решения.

3. Автопайплайны
3.1 Автопайплайн для витрины активности пользователей.
DAG: run_users_activity_pipeline

Как работает?

Запускает DAG'и репликации данных.

Ждет их завершения.

Запускает DAG для обновления витрины.

3.2 Автопайплайн для витрины эффективности поддержки.
DAG: run_support_efficiency_pipeline

Как работает?

Запускает DAG репликации данных.

Ждет его завершения.

Запускает DAG для обновления витрины.