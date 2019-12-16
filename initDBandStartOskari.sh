#!/bin/bash
service postgresql start
set -e

psql -v ON_ERROR_STOP=0 --username "postgres" --dbname "postgres" <<-EOSQL
	CREATE USER oskari WITH PASSWORD 'oskari';
	CREATE DATABASE oskaridb;
	GRANT ALL PRIVILEGES ON DATABASE oskaridb TO oskari;
	\c oskaridb;
	CREATE EXTENSION postgis;
EOSQL

sleep 3

cd /data/oskari-server && java -jar ../jetty-distribution-9.4.12.v20180830/start.jar

tail -F /var/log/postgresql/postgresql-10-main.log
