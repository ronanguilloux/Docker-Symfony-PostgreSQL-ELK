# Symfony-PostgreSQL-ELK

A complete stack for running Symfony 2 atop Nginx, PHP-FPM, PostgreSQL and ELK.
Each of them running in containers, using `docker-compose` tool.

## Installation

First, clone this repository:

```bash
$ git clone git@github.com:ronanguilloux/docker-symfony.git
```

Next, put your Symfony application into `symfony` folder and do not forget to add `symfony.dev` in your `/etc/hosts` file.

Then, at first launch, just type:

```bash
$ make
$ make install
```

This command run `docker build` (docker images setup), `docker-compose up`, then initialize (empty) `symfony` postgresql db using `psql`.

Next time, since your images are already built, you'll just have to type:

```bash
$ make run
```

This command run docker-compose and output your working IP (useful to any OS X + `boot2docker` users).

You are done, you can now visit your Symfony application on the following URL: [http://symfony.dev](http://symfony.dev)

You can also access Kibana on [http://symfony.dev:81](http://symfony.dev:81)

## FAQ

### How may I use `composer` command

```bash
$ docker exec -ti $(docker ps -f name=php -q) composer
```

### How may I use Symfony's  `php app/console` command?

```bash
$ docker exec -ti $(docker ps -f name=php -q) php /var/www/symfony/app/console cache:clear
```

### How may I use Postgre's `psql` command?

```bash
$ docker exec -ti $(docker ps -f name=postgre -q) psql -U postgres
```

### This is sorcery, tell me how it works!?

Have a look at the `docker-compose.yml` file, here are the `docker-compose` built images:

* `application`: This is the Symfony application code container,
* `postgres`: This is the PostgreSQL database container,
* `php`: This is the PHP-FPM container in which the application volume is mounted,
* `nginx`: This is the Nginx webserver container in which application volume is mounted too,
* `elk`: This is a ELK stack container which uses Logstash to collect logs, send them into Elasticsearch and visualize them with Kibana.

This results in the following running containers:

```bash
$ docker-compose ps
        Name                      Command               State              Ports
        -------------------------------------------------------------------------------------------
        docker_application_1   /bin/bash                        Up
        docker_elk_1           /usr/bin/supervisord -n -c ...   Up      0.0.0.0:81->80/tcp
        docker_nginx_1         nginx                            Up      443/tcp, 0.0.0.0:80->80/tcp
        docker_php_1           php5-fpm -F                      Up      9000/tcp
        docker_postgres_1      /docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp
```

## How to build my Docker images separately?

```bash
$ docker build -t symfony/application application
$ docker build -t symfony/php-fpm php-fpm
$ docker build -t symfony/nginx nginx
$ docker build -t symfony/postgres postgres
```

## How may I read my logs?

You can access Nginx and Symfony application logs in the following directories into your host machine:

* `logs/nginx`
* `logs/symfony`

## Use Kibana!

You can also use Kibana to visualize Nginx & Symfony logs by visiting `http://symfony.dev:81`.

### I have a RAM issue using `composer`

PHP's package manager, `composer`, internally increases the memory_limit to 1G. To get the current memory_limit value, run:

```bash
$ docker exec -ti $(docker ps -f name=php -q) php -r "echo ini_get('memory_limit').PHP_EOL;"
```

## License, Copyright & Contributeurs

(c) 2015 LiberTIC

- [MIT (X11)](http://en.wikipedia.org/wiki/MIT_License)
- Made in Nantes, France

## Credits

Inspirated by [eko/docker-symfony](https://github.com/eko/docker-symfony)
