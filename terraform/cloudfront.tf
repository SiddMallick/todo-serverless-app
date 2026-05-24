resource "aws_cloudfront_origin_access_control" "todo_app_dev_oac" {

  name = "todo-ui-oac"

  origin_access_control_origin_type = "s3"

  signing_behavior = "always"
  signing_protocol = "sigv4"

}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

resource "aws_acm_certificate" "todo_cert" {
  provider = aws.us-east-1

  domain_name       = "*.treeoftools.click"
  validation_method = "DNS"

}

data "aws_route53_zone" "main" {
  name = "treeoftools.click"
}


resource "aws_route53_record" "todo_cert_validation" {

  for_each = {
    for dvo in aws_acm_certificate.todo_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id

  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]

  ttl = 60

}

resource "aws_acm_certificate_validation" "todo_cert" {
  provider = aws.us-east-1

  certificate_arn = aws_acm_certificate.todo_cert.arn

  validation_record_fqdns = [
    for record in aws_route53_record.todo_cert_validation :
    record.fqdn
  ]
}



resource "aws_cloudfront_distribution" "todo_frontend_distribution" {
  enabled = true

  default_root_object = "index.html"

  aliases = [
    "todo-ui-dev-tf.treeoftools.click"
  ]

  origin {
    domain_name              = aws_s3_bucket.todo_frontend_bucket.bucket_regional_domain_name
    origin_id                = "todoFrontendS3"
    origin_access_control_id = aws_cloudfront_origin_access_control.todo_app_dev_oac.id
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    target_origin_id = "todoFrontendS3"

    viewer_protocol_policy = "redirect-to-https"

    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.todo_cert.certificate_arn

    ssl_support_method = "sni-only"

    minimum_protocol_version = "TLSv1.2_2021"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }


}