#!/bin/bash

docker stop k3sdb && docker rm k3sdb
docker run --name k3sdb -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root123 -e MYSQL_DATABASE=k3sdb -d mysql

