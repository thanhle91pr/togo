#!/bin/bash
set -e
export PGPASSWORD=$POSTGRES_PASSWORD;
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';
  CREATE DATABASE $APP_DB_NAME;
  GRANT ALL PRIVILEGES ON DATABASE $APP_DB_NAME TO $APP_DB_USER;
  \connect $APP_DB_NAME $APP_DB_USER
  BEGIN;
    CREATE TABLE users (
                           id TEXT NOT NULL,
                           password TEXT NOT NULL,
                           max_todo INTEGER DEFAULT 5 NOT NULL,
                           CONSTRAINT users_PK PRIMARY KEY (id)
    );

    INSERT INTO users (id, password, max_todo) VALUES('firstUser', 'example', 5);

    CREATE TABLE tasks (
                           id TEXT NOT NULL,
                           content TEXT NOT NULL,
                           user_id TEXT NOT NULL,
                           created_date TEXT NOT NULL,
                           CONSTRAINT tasks_PK PRIMARY KEY (id),
                           CONSTRAINT tasks_FK FOREIGN KEY (user_id) REFERENCES users(id)
    );
  COMMIT;
  INSERT INTO tasks (id, content, user_id, created_date) VALUES('1', 'content 1', 'firstUser', '2022-03-14');
  INSERT INTO tasks (id, content, user_id, created_date) VALUES('2', 'content 2', 'firstUser', '2022-03-14');
  INSERT INTO tasks (id, content, user_id, created_date) VALUES('3', 'content 3', 'firstUser', '2022-03-14');
  INSERT INTO tasks (id, content, user_id, created_date) VALUES('4', 'content 4', 'firstUser', '2022-03-14');
EOSQL