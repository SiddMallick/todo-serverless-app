output "lambda_functions" {

  value = {
    for k, v in aws_lambda_function.todo_lambda_functions :
    k => v.function_name
  }
}