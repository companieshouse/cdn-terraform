#trivy:ignore:AVD-AWS-0011 trivy:ignore:AVD-AWS-0013
resource "aws_cloudfront_distribution" "assets" {
  enabled             = true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.assets.bucket_regional_domain_name
    origin_id                = local.cloudfront_s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.assets.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.cloudfront_s3_origin_id

    cache_policy_id          = aws_cloudfront_cache_policy.assets.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.assets.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_control" "assets" {
  name                              = "${var.service}-${var.aws_account}"
  description                       = "Origin access control for access to assets in S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_cache_policy" "assets" {
  name        = "${var.service}-${var.aws_account}"
  min_ttl     = var.min_ttl
  default_ttl = var.default_ttl
  max_ttl     = var.max_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    headers_config {
      header_behavior = "none"
    }

    cookies_config {
      cookie_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }

    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }
}

resource "aws_cloudfront_origin_request_policy" "assets" {
  name = "${var.service}-${var.aws_account}"

  headers_config {
    header_behavior = "none"
  }

  cookies_config {
    cookie_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "none"
  }
}
