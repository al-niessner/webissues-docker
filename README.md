# webissues

## build

```
docker compose build
docker buildx bake [--push]
```

## installation 

### point browser to: http://localhost:8084/admin/setup/install.php
* Database Host Name:     db
* Database Name:          webissues
* Database User Name:     webissues
* Database User Password: geheim


### export/import/mainten DB

```
docker exec -it webissues-db-1 bash
mysql -u webissues -p
mysql> use webissues
mysql> DROP VIEW effective_rights;
mysql> exit

mysqldump --no-tablespaces -uwebissues -p webissues > /var/lib/mysql/backup.dump
mysql -uwebissues -p webissues                      < /var/lib/mysql/backup.dump
```


