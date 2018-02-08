# webissues in Docker

## content:
* webissues (based on php:5.6-fpm-alpine)
* nginx 
* mysql

## installation 

### build image and start a container
```
git clone https://github.com/unimock/webissues-docker.git ./webissues
cd ./webissues
cp docker-compose.yml-template docker-compose.yml
vi docker-compose.yml
cp .env-template .env
vi .env
docker-compose build
docker-compose up -d
docker-compose logs
```

### point your browser to: http://localhost:8084/admin/setup/install.php
* Database Host Name:     db
* Database Name:          webissues
* Database User Name:     webissues
* Database User Password: geheim


