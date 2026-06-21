#!/bin/bash

set -e

rm -rf build
mkdir -p build

LAMBDAS=(
  "create-todo-lambda"
  "get-todo-lambda"
  "get-todo-by-id-lambda"
  "delete-todo-lambda"
)

for lambda in "${LAMBDAS[@]}"
do

  echo "Building $lambda"

  rm -rf package
  mkdir package

  pip install \
    -r lambdas/$lambda/requirements.txt \
    -t package/

  cp lambdas/$lambda/lambda_function.py package/

  cd package

  zip -r ../build/$lambda.zip .

  cd ..

  rm -rf package

done

echo "All Lambda ZIPs built successfully"