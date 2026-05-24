resource "aws_iam_role" "todo_lambda_role" {
  name = "lambda_ddb_access_role_dev"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
  tags = {
    env     = "dev"
    managed = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "ddb_full_access" {
  role       = aws_iam_role.todo_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_exec_role" {
  role       = aws_iam_role.todo_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "create_todo_lambda_archive" {
  type        = "zip"
  source_file = "${path.module}/lambda/create-todo-lambda.py"
  output_path = "${path.module}/lambda/create-todo-lambda.zip"
}

data "archive_file" "delete_todo_lambda_archive" {
  type        = "zip"
  source_file = "${path.module}/lambda/delete-todo-lambda.py"
  output_path = "${path.module}/lambda/delete-todo-lambda.zip"
}

data "archive_file" "get_todo_lambda_archive" {
  type        = "zip"
  source_file = "${path.module}/lambda/get-todo-lambda.py"
  output_path = "${path.module}/lambda/get-todo-lambda.zip"
}

data "archive_file" "get_todo_by_id_lambda_archive" {
  type        = "zip"
  source_file = "${path.module}/lambda/get-todo-by-id-lambda.py"
  output_path = "${path.module}/lambda/get-todo-by-id-lambda.zip"
}


resource "aws_lambda_function" "create_todo_lambda_dev" {
  filename      = data.archive_file.create_todo_lambda_archive.output_path
  function_name = "create-todo-lambda-dev"
  role          = aws_iam_role.todo_lambda_role.arn
  handler       = "create-todo-lambda.lambda_handler"
  code_sha256   = data.archive_file.create_todo_lambda_archive.output_base64sha256

  runtime = "python3.14"

  timeout = 15

  tags = {
    env         = "dev"
    Application = "todo_app_dev"
    managed     = "terraform"
  }
}

resource "aws_lambda_function" "delete_todo_lambda_dev" {
  filename      = data.archive_file.delete_todo_lambda_archive.output_path
  function_name = "delete-todo-lambda-dev"
  role          = aws_iam_role.todo_lambda_role.arn
  handler       = "delete-todo-lambda.lambda_handler"
  code_sha256   = data.archive_file.delete_todo_lambda_archive.output_base64sha256

  runtime = "python3.14"
  timeout = 15

  tags = {
    env         = "dev"
    Application = "todo_app_dev"
    managed     = "terraform"
  }
}



resource "aws_lambda_function" "get_todo_lambda_dev" {
  filename      = data.archive_file.get_todo_lambda_archive.output_path
  function_name = "get-todo-lambda-dev"
  role          = aws_iam_role.todo_lambda_role.arn
  handler       = "get-todo-lambda.lambda_handler"
  code_sha256   = data.archive_file.get_todo_lambda_archive.output_base64sha256

  runtime = "python3.14"
  timeout = 15

  tags = {
    env         = "dev"
    Application = "todo_app_dev"
    managed     = "terraform"
  }
}

resource "aws_lambda_function" "get_todo_by_id_lambda_dev" {
  filename      = data.archive_file.get_todo_by_id_lambda_archive.output_path
  function_name = "get-todo-by-id-lambda-dev"
  role          = aws_iam_role.todo_lambda_role.arn
  handler       = "get-todo-by-id-lambda.lambda_handler"
  code_sha256   = data.archive_file.get_todo_by_id_lambda_archive.output_base64sha256

  runtime = "python3.14"
  timeout = 15

  tags = {
    env         = "dev"
    Application = "todo_app_dev"
    managed     = "terraform"
  }
}
