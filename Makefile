# `EXEC` var can be use only when you rule does not rely on `run` (that then creates new PID)
EXEC := exec -ti $(shell docker ps -f name=postgres -q) su postgres sh -c
B2DEXISTS := $(shell boot2docker version 2>/dev/null)
DB_NAME := symfony
DB_USER := symfony
DB_PWD := symfony

all:
	docker build -t symfony/application application
	docker build -t symfony/php-fpm php-fpm
	docker build -t symfony/nginx nginx
	docker build -t symfony/postgres postgres

install: run db

# `EXEC_LIVE` must be set at runtime only,
# because of the run rule, that must first end up with new containers PIDs.
db:
	$(eval EXEC_LIVE := exec -ti $(shell docker ps -f name=postgres -q) su postgres sh -c)
	docker ${EXEC_LIVE} "createuser -d -s ${DB_USER}"
	docker ${EXEC_LIVE} "createdb  -T template0 -E UTF8 -O ${DB_USER} ${DB_NAME}"
	docker ${EXEC_LIVE} "psql -c \"GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} to ${DB_USER};\""
	docker ${EXEC_LIVE} "psql -c \"ALTER USER ${DB_USER} PASSWORD '${DB_PWD}';\"";
	
	#PRO MEMORIA: install previous dump: 
	# docker ${EXEC_LIVE} "psql -d ${DB_NAME} -f \/var\/www\/symfony\/doc\/postgresql\/dump.sql";

run:
	docker-compose up -d
ifdef B2DEXISTS
	@echo "Website and Postgresql are running on `boot2docker ip`";
else
	@echo "Website and Postgresql are running";
endif

stop:
	docker-compose stop

# Symfony's PHP App Console
pac:
	docker exec -ti $(docker ps -f name=php -q) php /var/www/symfony/app/console

# ---------------------------------------------
.PHONY: all install run stop db pac
