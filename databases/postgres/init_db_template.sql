-- БД, юзер и гранты
CREATE DATABASE ${POSTGRESQL_APP_DB};
CREATE USER ${POSTGRESQL_APP_USER} WITH PASSWORD '${POSTGRESQL_APP_PASSWORD}';
GRANT ALL PRIVILEGES ON DATABASE ${POSTGRESQL_APP_DB} TO ${POSTGRESQL_APP_USER};

-- Подключение к БД
\c ${POSTGRESQL_APP_DB}

-- Создание схемы, изменение дефолтной схемы и гранты
CREATE SCHEMA IF NOT EXISTS ${POSTGRESQL_APP_SCHEMA} AUTHORIZATION ${POSTGRESQL_APP_USER};
CREATE SCHEMA IF NOT EXISTS ${POSTGRESQL_MART_SCHEMA} AUTHORIZATION ${POSTGRESQL_APP_USER};
SET search_path TO ${POSTGRESQL_APP_SCHEMA};

-- Назначение прав на объекты схемы
ALTER DEFAULT PRIVILEGES IN SCHEMA ${POSTGRESQL_APP_SCHEMA} GRANT ALL PRIVILEGES ON TABLES TO ${POSTGRESQL_APP_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA ${POSTGRESQL_APP_SCHEMA} GRANT USAGE ON SEQUENCES TO ${POSTGRESQL_APP_USER};

ALTER DEFAULT PRIVILEGES IN SCHEMA ${POSTGRESQL_MART_SCHEMA} GRANT ALL PRIVILEGES ON TABLES TO ${POSTGRESQL_APP_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA ${POSTGRESQL_MART_SCHEMA} GRANT USAGE ON SEQUENCES TO ${POSTGRESQL_APP_USER};