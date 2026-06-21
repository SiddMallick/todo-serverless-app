#!/bin/bash

BUCKET=todo-lambda-artifacts-bucket

COMMIT=$(git rev-parse --short HEAD)

LAMBDAS=(
  "create-todo-lambda"
  "get-todo-lambda"
  "get-todo-by-id-lambda"
  "delete-todo-lambda"
)

for lambda in "${LAMBDAS[@]}"
do

  aws s3 cp \
    build/$lambda.zip \
    s3://$BUCKET/$lambda/$COMMIT.zip

done