# Black Box Testing with Docker

## 1. What is blackbox testing ?

Black Box Testing is testing without knowing how the implementation looks like, we just know what output to expect for a given input, we know the functionality but we don't care about the technologies behind it or the implementation details. This makes Black Box Testing a great tool to increase test coverage on legacy code, but it's also a great way to do Test Driven Development on Micro Services.

## 2. Why use docker ?

Docker enables us to run our testing target inside a black box in the most easy way possible. We also make sure that we are testing our service in the same environment as it will run in production.

But we also want to use Docker to run our tests, meaning that no matter what tech stack is used, all we need to run it is Docker.

## 3. How do we test ?

We can use any testing framework we want, but in the end simple curl requests asserting on the response headers and bodies will be all we need.
We can use a simple bash test runner:
- [bast-test](https://github.com/campanda/bash-test)
- [bats](https://github.com/bats-core/bats-core)
- [bash test tools](https://thorsteinssonh.github.io/bash_test_tools/)

We can use bare bone docker or take advantage of docker-compose. In my examples I will use a `docker-compose.yml` to describe my services:

```version: '3.4'
services:
  tests:
    build: .
    volumes:
      - .:/tests
    depends_on:
      - target

  target:
    build: ../${TARGET}/.
    ports:
      - 8080:8080
    depends_on:
      - upstream

  upstream:
    image: campanda/webserver-mock
    volumes:
      - ./mocks:/mocks
    environment:
      - custom_responses_config=/mocks/upstream.yml
```

We run it with `docker-compose up --abort-on-container-exit`,

or with `docker-compose up --abort-on-container-exit --exit-code-from tests` if you want to run the tests on your CI server.

I like to have a little test runner like `run-tests.sh`:
```#!/usr/bin/env bash

cd tests
docker-compose build
docker-compose up -d
sleep 10
docker-compose run tests *.sh
docker-compose kill
docker-compose down --remove-orphans
```


## 4. How do we deal with upstream services ?

When the service we are testing is depending on an other service, we will mock this service in order to control the data it returns and the assertions we want to make.

Docker will make it very easy for us to mock a service, all we have to do is get a Docker container up and running that will run on the same port as the service it tries to mock, listen to the same routes and return the responses we expect.

We can use some existing Docker Images for that:
- [Mock Server](http://www.mock-server.com/mock_server/running_mock_server.html#docker_container)
- [apimock](https://github.com/pierreprinetti/apimock)
- [webserver-mock](https://github.com/campanda/webserver-mock)

## 5. Final thoughts

I really enjoy doing TDD with black box testing and docker when I need to setup a new service, it forces me to think about the consumer and how I want to design the API. It also makes it very easy to refactor or completely rewrite the service in an other language.

Using docker as a setup enables me to solve the question of: how do I build and run this service on my laptop, on the CI server, in production, on my new colleagues laptop etc..

I think this setup is also a good starting point for doing contract driven development.


# Hands-On !

You can find a repository with examples in javascript, java and python here: https://git.io/JeaTP

- run the tests with `TARGET=java ./run-tests.sh` if you want to run against the java service.
- run the tests with `TARGET=javascript ./run-tests.sh` if you want to run against the javascript service.
- run the tests with `TARGET=python ./run-tests.sh` if you want to run against the python service.
