-- Кейс-задача 2.3: БД «Туризм» (MySQL)
-- 4 справочника + tour_orders

DROP DATABASE IF EXISTS tourism_db;
CREATE DATABASE tourism_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE tourism_db;

-- Справочник: страны
CREATE TABLE countries (
    country_id   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL,
    country_code CHAR(2)      NOT NULL,
    CONSTRAINT pk_countries PRIMARY KEY (country_id),
    CONSTRAINT uq_countries_name UNIQUE (country_name),
    CONSTRAINT uq_countries_code UNIQUE (country_code)
) ENGINE=InnoDB;

CREATE INDEX idx_countries_name ON countries (country_name);

-- Справочник: города
CREATE TABLE cities (
    city_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
    city_name  VARCHAR(100) NOT NULL,
    country_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_cities PRIMARY KEY (city_id),
    CONSTRAINT fk_cities_country
        FOREIGN KEY (country_id) REFERENCES countries (country_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_cities_name_country UNIQUE (city_name, country_id)
) ENGINE=InnoDB;

CREATE INDEX idx_cities_country ON cities (country_id);

-- Справочник: типы туров
CREATE TABLE tour_types (
    tour_type_id   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    type_name      VARCHAR(80)  NOT NULL,
    description    VARCHAR(255) NULL,
    CONSTRAINT pk_tour_types PRIMARY KEY (tour_type_id),
    CONSTRAINT uq_tour_types_name UNIQUE (type_name)
) ENGINE=InnoDB;

-- Справочник: клиенты
CREATE TABLE clients (
    client_id  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    last_name  VARCHAR(80)  NOT NULL,
    first_name VARCHAR(80)  NOT NULL,
    email      VARCHAR(120) NOT NULL,
    phone      VARCHAR(20)  NULL,
    CONSTRAINT pk_clients PRIMARY KEY (client_id),
    CONSTRAINT uq_clients_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE INDEX idx_clients_last_name ON clients (last_name);

-- Заказы туров (переменная информация)
CREATE TABLE tour_orders (
    order_id     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    client_id    INT UNSIGNED  NOT NULL,
    city_id      INT UNSIGNED  NOT NULL,
    tour_type_id INT UNSIGNED  NOT NULL,
    order_date   DATE          NOT NULL,
    start_date   DATE          NOT NULL,
    end_date     DATE          NOT NULL,
    persons_count TINYINT UNSIGNED NOT NULL DEFAULT 1,
    total_price  DECIMAL(12, 2) NOT NULL,
    status       ENUM('new', 'confirmed', 'paid', 'cancelled', 'completed')
                 NOT NULL DEFAULT 'new',
    notes        VARCHAR(500)  NULL,
    CONSTRAINT pk_tour_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_client
        FOREIGN KEY (client_id) REFERENCES clients (client_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_orders_city
        FOREIGN KEY (city_id) REFERENCES cities (city_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_orders_tour_type
        FOREIGN KEY (tour_type_id) REFERENCES tour_types (tour_type_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_orders_dates CHECK (end_date >= start_date),
    CONSTRAINT chk_orders_persons CHECK (persons_count >= 1),
    CONSTRAINT chk_orders_price CHECK (total_price >= 0)
) ENGINE=InnoDB;

CREATE INDEX idx_orders_client    ON tour_orders (client_id);
CREATE INDEX idx_orders_city      ON tour_orders (city_id);
CREATE INDEX idx_orders_tour_type ON tour_orders (tour_type_id);
CREATE INDEX idx_orders_status    ON tour_orders (status);
CREATE INDEX idx_orders_start_date ON tour_orders (start_date);

-- Тестовые данные
INSERT INTO countries (country_name, country_code) VALUES
    ('Россия', 'RU'),
    ('Турция', 'TR'),
    ('Италия', 'IT');

INSERT INTO cities (city_name, country_id) VALUES
    ('Москва', 1),
    ('Санкт-Петербург', 1),
    ('Анталья', 2),
    ('Рим', 3);

INSERT INTO tour_types (type_name, description) VALUES
    ('Пляжный', 'Отдых у моря'),
    ('Экскурсионный', 'Обзорные экскурсии и достопримечательности'),
    ('Горнолыжный', 'Катание на лыжах и сноуборде');

INSERT INTO clients (last_name, first_name, email, phone) VALUES
    ('Иванов', 'Иван', 'ivanov@example.com', '+7-900-111-22-33'),
    ('Петрова', 'Мария', 'petrova@example.com', '+7-900-444-55-66');

INSERT INTO tour_orders (
    client_id, city_id, tour_type_id,
    order_date, start_date, end_date,
    persons_count, total_price, status, notes
) VALUES
    (1, 3, 1, '2026-03-01', '2026-06-10', '2026-06-20', 2, 85000.00, 'confirmed', 'All inclusive'),
    (2, 4, 2, '2026-03-05', '2026-09-01', '2026-09-08', 1, 62000.00, 'new', NULL);

-- Отчётный запрос
SELECT
    o.order_id,
    c.last_name,
    c.first_name,
    ci.city_name,
    co.country_name,
    tt.type_name,
    o.start_date,
    o.end_date,
    o.total_price,
    o.status
FROM tour_orders o
JOIN clients c ON c.client_id = o.client_id
JOIN cities ci ON ci.city_id = o.city_id
JOIN countries co ON co.country_id = ci.country_id
JOIN tour_types tt ON tt.tour_type_id = o.tour_type_id
ORDER BY o.order_id;
