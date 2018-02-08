# webissues in Docker

## content:
* webissues
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
#docker-compose build
docker-compose up -d
docker-compose logs
```

### point your browser to: http://localhost:888/install/index.php
* Database Host Name:     mysql
* Database Name:          dotproject
* Database User Name:     dotproject
* Database User Password: dotproject


