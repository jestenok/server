-- telegram
create schema telegram;

-- jira
CREATE database jiradb;

-- airflow
CREATE database airflow;

-- monitoring
CREATE SCHEMA monitoring;
SET SCHEMA 'monitoring';

DROP TABLE IF EXISTS metrics;

CREATE TABLE metrics (
    timestamp timestamp(0) NOT NULL,
    cpu_usage decimal(5, 2) NOT NULL,
    mem_available bigint NOT NULL,
    cpu_temp int NOT NULL,
    time_of_proc decimal(5, 2) NOT NULL,
    adminer_status int,
    site_status int,
    jira_status int,
    airflow_status int,
    telegram_status int,

    PRIMARY KEY (timestamp)
) ;

-- grafana


-- users
-- GRANT ALL ON DATABASE server TO grafana;
-- GRANT ALL ON SCHEMA monitoring TO grafana;
-- GRANT ALL ON TABLE monitoring.metrics TO grafana;