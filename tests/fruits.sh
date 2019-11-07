#!/usr/bin/env bash

test_target_returns_status_200_OK() {
  actual=$(curl -sI http://target:8080/fruits)
  echo "$actual" | grep -q '200'
}

test_target_returns_content_type_JSON() {
  actual=$(curl -sI http://target:8080/fruits)
  echo "$actual" | grep -q 'Content-Type: application/json'
}

test_target_returns_reponse_body_with_fruits_from_fruit_service() {
  actual=$(curl -s http://target:8080/fruits)
  expected=$(cat mocks/fruits.json)
  # echo "$actual"
  # echo "$expected"

  diff <(echo "$actual" | jq -S .) <(echo "$expected" | jq -S .)
}