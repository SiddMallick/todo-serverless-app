resource "aws_s3_bucket" "lambda_artifact_bucket" {
  bucket = var.artifact_bucket
}

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


resource "aws_lambda_function" "todo_lambda_functions" {
  for_each = local.lambdas

  function_name = each.key

  role    = aws_iam_role.todo_lambda_role.arn
  runtime = "python3.14"

  handler = each.value.handler

  s3_bucket = aws_s3_bucket.lambda_artifact_bucket.bucket

  s3_key = var.lambda_s3_keys[each.key]

  source_code_hash = filebase64sha256("../build/${each.value.function_name}.zip")

  publish = true
}

resource "aws_lambda_alias" "dev" {
  for_each = aws_lambda_function.todo_lambda_functions

  name = "dev"

  function_name    = each.value.function_name
  function_version = each.value.version

}


