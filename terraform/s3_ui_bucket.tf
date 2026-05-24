resource "aws_s3_bucket" "todo_frontend_bucket" {
  bucket = "todo-ui-dev-tf.treeoftools.click"

  tags = {
    Name        = "todo-ui-dev-tf.treeoftools.click"
    env = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "todo_frontend_bucket" {
  bucket = aws_s3_bucket.todo_frontend_bucket.id

  block_public_acls = true
  block_public_policy = true

  ignore_public_acls = true
  restrict_public_buckets = true

}

resource "aws_s3_bucket_versioning" "todo_frontend_bucket" {
  bucket = aws_s3_bucket.todo_frontend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "todo_frontend" {
  bucket = aws_s3_bucket.todo_frontend_bucket.id

  policy = jsonencode(
    {
        Version = "2012-10-17"

        Statement = [
            {
                Sid = "AllowCFServicePrincipal"
                Effect = "Allow"

                Principal = {
                    Service = "cloudfront.amazonaws.com"
                }

                Action = ["s3:GetObject"]

                Resource = "${aws_s3_bucket.todo_frontend_bucket.arn}/*"

                Condition = {
                    StringEquals = {
                        "AWS:SourceArn" = aws_cloudfront_distribution.todo_frontend_distribution.arn
                    }
                }
            }
        ]
    }
  )
}


resource "aws_route53_record" "todo_frontend_alias" {
  zone_id = data.aws_route53_zone.main.zone_id

  name = "todo-ui-dev-tf.treeoftools.click"

  type = "A"

  alias {
    name = aws_cloudfront_distribution.todo_frontend_distribution.domain_name

    zone_id = aws_cloudfront_distribution.todo_frontend_distribution.hosted_zone_id

    evaluate_target_health = false
  }
}