#!/usr/bin/env bash

test_target_returns_status_200_OK() {
  actual=$(curl -sI http://target:8080/)
  echo "$actual" | grep -q '200'
}

test_target_returns_reponse_body_with_hello_world() {
  actual=$(curl -si http://target:8080/)
  echo "$actual" | grep -q 'Hello World'
}