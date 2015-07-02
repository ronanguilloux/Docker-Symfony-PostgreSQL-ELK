# Symfony-PostgreSQL

A complete stack for running Symfony, Nginx, PHP-FPM & PostgreSQL into containers, using docker-compose tool.

## Installation

First, clone this repository:

```bash
$ git clone git@github.com:ronanguilloux/docker-symfony.git
```

Next, put your Symfony application into `symfony` folder and do not forget to add `symfony.dev` in your `/etc/hosts` file.

Then, run:

```bash
$ make
$ make install # to initialize an empty `symfony` db
$ make run
```

You are done, you can visite your Symfony application on the following URL: `http://symfony.dev` (and access Kibana on `http://symfony.dev:81`)

Optionally, you can build your Docker images separately by running:

```bash
$ docker build -t symfony/application application
$ docker build -t symfony/php-fpm php-fpm
$ docker build -t symfony/nginx nginx
$ docker build -t symfony/postgres postgres
```

## How it works?

Here are the `docker-compose` built images:

* `application`: This is the Symfony application code container,
* `postgres`: This is the PostgreSQL database container,
* `php`: This is the PHP-FPM container in which the application volume is mounted,
* `nginx`: This is the Nginx webserver container in which application volume is mounted too,
* `elk`: This is a ELK stack container which uses Logstash to collect logs, send them into Elasticsearch and visualize them with Kibana.

This results in the following running containers:

```bash
> $ docker-compose ps
        Name                      Command               State              Ports
        -------------------------------------------------------------------------------------------
        docker_application_1   /bin/bash                        Up
        docker_elk_1           /usr/bin/supervisord -n -c ...   Up      0.0.0.0:81->80/tcp
        docker_nginx_1         nginx                            Up      443/tcp, 0.0.0.0:80->80/tcp
        docker_php_1           php5-fpm -F                      Up      9000/tcp
```

## Read logs

You can access Nginx and Symfony application logs in the following directories into your host machine:

* `logs/nginx`
* `logs/symfony`

## Use Kibana!

You can also use Kibana to visualize Nginx & Symfony logs by visiting `http://symfony.dev:81`.

## FAQ

### "I have a RAM issue"

PHP's package manager, `composer`, internally increases the memory_limit to 1G. To get the current memory_limit value, run:

```bash
php -r "echo ini_get('memory_limit').PHP_EOL;"
```

## License, Copyright & Contributeurs

(c) 2015 LiberTIC

- [MIT (X11)](http://en.wikipedia.org/wiki/MIT_License)
- Made in Nantes, France

## Credits

Inspirated by [eko/docker-symfony](https://github.com/eko/docker-symfony)