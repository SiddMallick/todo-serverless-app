locals {
  lambdas = {
    create_todo = {
      handler       = "lambda_function.lambda_handler"
      function_name = "create-todo-lambda"
    }

    get_todos = {
      handler       = "lambda_function.lambda_handler"
      function_name = "get-todo-lambda"
    }

    get_todo_by_id = {
      handler       = "lambda_function.lambda_handler"
      function_name = "get-todo-by-id-lambda"
    }

    delete_todo = {
      handler       = "lambda_function.lambda_handler"
      function_name = "delete-todo-lambda"
    }
  }
}