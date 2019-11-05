#!/usr/bin/env bash

cd tests
docker-compose build
docker-compose up -d
sleep 10
docker-compose run tests *.sh
docker-compose kill
docker-compose down --remove-orphans