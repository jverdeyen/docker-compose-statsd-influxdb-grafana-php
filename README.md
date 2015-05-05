# Docker Compose example - Statsd, InfluxDB, Grafana, PHP app

This repository was created to show of the possibilities of `Docker Compose` (formely known as Fig).

## Getting Started

### Create a Digital Ocean Droplet

Create a new Digital Ocean Droplet and select the following application: `Docker 1.6.0 on 14.04`.
I've tested it with a $80/mo Droplet as I'm only testing this for a few hours. Add your personal public ssh key for easy root access.

Spin up the Droplet and login with ssh:

```
ssh root@x.x.x.x
```

### Docker and Docker Compose

You can easily check the Docker package is installed with:

```
root@docker:~# docker -v
Docker version 1.6.0, build 4749651
```

The Docker Compose package isn't installed by default. We will be using this as a wrapper for Docker to easily link multiple containers.
For example: Our PHP application will be able to send UDP packages to the StatsD container.

```
root@docker:~# docker-compose --version
docker-compose: command not found
```

Install Compose by running the following command:

```
curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

Now you will see Compose is installed properly:

```
root@docker:~# docker-compose --version
docker-compose 1.2.0
```

### Clone the repository

```
cd
git clone repository-url
cd repository-name
```

Replace `repository-url` and `repository-name` with the respective values.

### Run Docker Compose

We can easily start the docker containers with:

```
docker-compose up web
```

You should see an output as following:

```
$ docker-compose up web
Recreating data_influxdb_1...
Recreating data_statsd_1...
Recreating data_grafana_1...
Recreating data_web_1...
Attaching to data_web_1
web_1 | ==> /var/log/apache2/access.log <==
web_1 |
web_1 | ==> /var/log/apache2/error.log <==
web_1 |
web_1 | ==> /var/log/apache2/other_vhosts_access.log <==
web_1 |
web_1 | ==> /var/log/apache2/error.log <==
web_1 | [Tue May 05 12:26:50.386792 2015] [mpm_prefork:notice] [pid 1] AH00163: Apache/2.4.7 (Ubuntu) PHP/5.5.9-1ubuntu4.9 configured -- resuming normal operations
web_1 | [Tue May 05 12:26:50.387051 2015] [core:notice] [pid 1] AH00094: Command line: 'apache2 -D FOREGROUND'
```

Here you can see all the output from the Apache instance.
If you don't want this, you can run Docker Compose as a daemon. The `-d` flag will make sure Docker Compose runs as a daemon.

```
docker-compose up -d web
```

You can see all the container running:

```
$ docker ps

CONTAINER ID        IMAGE                          COMMAND                CREATED              STATUS              PORTS                                                                              NAMES
8a83f36dea7f        data_web:latest                "/run.sh"              About a minute ago   Up About a minute   0.0.0.0:80->80/tcp, 0.0.0.0:8080->8080/tcp                                         data_web_1
a7b167726d9b        grafana/grafana:latest         "/usr/sbin/grafana-s   About a minute ago   Up About a minute   0.0.0.0:3000->3000/tcp                                                             data_grafana_1
040f26d9f887        shakr/statsd-influxdb:latest   "/bin/sh -c '/usr/lo   About a minute ago   Up About a minute   0.0.0.0:8125->8125/udp, 8126/tcp                                                   data_statsd_1
93b9801f917a        tutum/influxdb:latest          "/run.sh"              2 minutes ago        Up 2 minutes        0.0.0.0:8083->8083/tcp, 0.0.0.0:8086->8086/tcp, 0.0.0.0:8090->8090/tcp, 8084/tcp   data_influxdb_1
```

## What's happening?

### Containers and their services

The following containers are started and available:

* Grafana: `x.x.x.x:3000` (admin/admin)
* InfluxDB: `x.x.x.x:8083` (web-admin) and `x.x.x.x:8086` (api) (root/root)
* StatsD: `x.x.x.x:8125`
* Apache: `x.x.x.x:80`

### How to start playing

The normal demo flow of this application is the following.
You can visit the mini PHP application on `http://x.x.x.x` this will output a loading time (simulated by a randomized `usleep`).
This PHP application will send and UDP package with the timing onto the StatsD instance, listening on `x.x.x.x:8125`.
Every x-seconds the StatsD instance will send this data to the InfluxDB. A database named `grafana` was already created.
This time based data in the InfluxDB can be retrieved from Grafana to make some fancy graphs.

The Grafana datasource (InfluxDB) needs to be added manually. This can easily be done by going to `x.x.x.x:3000` use admin/admin as login credentials.
Go to the menu by clicking on the round Grafana logo. `Data Sources` -> `Add New`.

* Name: InfluxDB
* Type: InfluxDB 0.8.x
* Url: http://influxdb:8086
* Database: grafana
* User: root
* Password: root

You can fill up the stats with `siege`.

```
siege http://x.x.x.x
```

You can also add events (ex. deploy) as annotations in Grafana.
Trigger this type of event by `http://x.x.x.x/deploy.php`.


### What's going on?

You can check the Docker Compose logs

```
docker-compose logs
```