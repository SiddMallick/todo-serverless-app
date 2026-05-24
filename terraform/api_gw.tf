resource "aws_api_gateway_rest_api" "todo_api_dev" {
  name = "todo-app-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    env         = "dev"
    Application = "todo_app"
  }
}

# /todos
resource "aws_api_gateway_resource" "todos_resource" {
  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id
  parent_id   = aws_api_gateway_rest_api.todo_api_dev.root_resource_id

  path_part = "todos"
}

# /todos/{todo_id}
resource "aws_api_gateway_resource" "todo_id" {
  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id
  parent_id   = aws_api_gateway_resource.todos_resource.id # As we need /todos/{todo_id}

  path_part = "{todo_id}"
}

resource "aws_api_gateway_method" "create_todo_post" {

  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id
  resource_id = aws_api_gateway_resource.todos_resource.id
  http_method = "POST"

  authorization = "NONE"

}

resource "aws_api_gateway_integration" "create_todo_lambda" {
  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id
  resource_id = aws_api_gateway_resource.todos_resource.id

  http_method = aws_api_gateway_method.create_todo_post.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.create_todo_lambda_dev.invoke_arn

}

resource "aws_lambda_permission" "allow_apigw_create_todo" {

  statement_id = "AllowExecutionFromAPIGatewayCreateTodo"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.create_todo_lambda_dev.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.todo_api_dev.execution_arn}/*/*"
}

resource "aws_api_gateway_method" "get_todos_lambda" {
  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id
  resource_id = aws_api_gateway_resource.todos_resource.id

  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_todos_lambda" {
  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id
  resource_id = aws_api_gateway_resource.todos_resource.id

  http_method = aws_api_gateway_method.get_todos_lambda.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.get_todo_lambda_dev.invoke_arn

}

resource "aws_lambda_permission" "allow_apigw_get_todo" {

  statement_id = "AllowExecutionFromAPIGatewayGetTodo"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.get_todo_lambda_dev.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.todo_api_dev.execution_arn}/*/*"
}


resource "aws_api_gateway_method" "get_todo_by_id" {
  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id
  resource_id = aws_api_gateway_resource.todo_id.id

  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.todo_id" = true
  }
}

resource "aws_api_gateway_integration" "get_todo_by_id" {
  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id
  resource_id = aws_api_gateway_resource.todo_id.id

  http_method = aws_api_gateway_method.get_todo_by_id.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"
  uri  = aws_lambda_function.get_todo_by_id_lambda_dev.invoke_arn

}

resource "aws_lambda_permission" "allow_apigw_get_todo_id" {

  statement_id = "AllowExecutionFromAPIGatewayGetTodoID"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.get_todo_by_id_lambda_dev.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.todo_api_dev.execution_arn}/*/*"
}



resource "aws_api_gateway_method" "delete_todo_by_id" {
  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id
  resource_id = aws_api_gateway_resource.todo_id.id

  http_method   = "DELETE"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.todo_id" = true
  }
}

resource "aws_api_gateway_integration" "delete_todo_by_id" {
  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id
  resource_id = aws_api_gateway_resource.todo_id.id

  http_method = aws_api_gateway_method.delete_todo_by_id.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"
  uri  = aws_lambda_function.delete_todo_lambda_dev.invoke_arn

}

resource "aws_lambda_permission" "allow_apigw_delete_todo_id" {

  statement_id = "AllowExecutionFromAPIGatewayDeleteTodoId"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.delete_todo_lambda_dev.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.todo_api_dev.execution_arn}/*/*"
}


resource "aws_api_gateway_deployment" "todo_api_dev_deployment" {
  depends_on = [
    aws_api_gateway_integration.create_todo_lambda,
    aws_api_gateway_integration.delete_todo_by_id,
    aws_api_gateway_integration.get_todo_by_id,
    aws_api_gateway_integration.get_todos_lambda
  ]

  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.todo_api_dev.id,

      aws_api_gateway_method.create_todo_post.id,
      aws_api_gateway_method.get_todos_lambda.id,
      aws_api_gateway_method.get_todo_by_id.id,
      aws_api_gateway_method.delete_todo_by_id.id,

      aws_api_gateway_integration.create_todo_lambda.id,
      aws_api_gateway_integration.get_todos_lambda.id,
      aws_api_gateway_integration.get_todo_by_id.id,
      aws_api_gateway_integration.delete_todo_by_id.id
    ]))
  }

}

resource "aws_api_gateway_stage" "dev" {
  rest_api_id = aws_api_gateway_rest_api.todo_api_dev.id

  deployment_id = aws_api_gateway_deployment.todo_api_dev_deployment.id

  stage_name = "dev"
}


# Create custom domain for APIGW
resource "aws_acm_certificate" "todo_api_cert" {
  domain_name = "todo-apis.treeoftools.click"

  validation_method = "DNS"

  tags = {
    env         = "dev"
    Application = "todo_app"
  }
}

resource "aws_route53_record" "todo_api_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.todo_api_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id

  name = each.value.name
  type = each.value.type

  records = [each.value.record]

  ttl = 60
}

resource "aws_acm_certificate_validation" "todo_api_cert_validation" {
  certificate_arn = aws_acm_certificate.todo_api_cert.arn

  validation_record_fqdns = [
    for record in aws_route53_record.todo_api_cert_validation :
    record.fqdn
  ]
}

resource "aws_api_gateway_domain_name" "todo_api_domain" {
  depends_on = [
    aws_acm_certificate_validation.todo_api_cert_validation
  ]

  domain_name = "todo-apis.treeoftools.click"

  regional_certificate_arn = aws_acm_certificate.todo_api_cert.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  security_policy = "TLS_1_2"
}

resource "aws_api_gateway_base_path_mapping" "todo_api_mapping" {
  api_id     = aws_api_gateway_rest_api.todo_api_dev.id
  stage_name = aws_api_gateway_stage.dev.stage_name

  domain_name = aws_api_gateway_domain_name.todo_api_domain.domain_name

  base_path = ""
}

resource "aws_route53_record" "todo_api_alias" {
  zone_id = data.aws_route53_zone.main.zone_id

  name = "todo-apis.treeoftools.click"

  type = "A"

  alias {
    name                   = aws_api_gateway_domain_name.todo_api_domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.todo_api_domain.regional_zone_id
    evaluate_target_health = false
  }
}




