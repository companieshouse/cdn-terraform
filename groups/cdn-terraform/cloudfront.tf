resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.example.bucket_regional_domain_name
    origin_id   = "S3-Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Origin"

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Access-Control-Allow-Origin"]
      cookies {
        forward = "none"
      }
    }

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

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "Allow Cloudfront to access the S3 bucket"
}

resource "aws_cloudfront_cache_policy" "example" {
  name = "example-cache-policy"
  min_ttl                        = var.min_ttl
  default_ttl                    = var.default_ttl
  max_ttl                        = var.max_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Origin", "Access-Control-Allow-Origin"]
      }        
    }

    cookies_config {
      cookie_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }

    enable_accept_encoding_gzip    = true
    enable_accept_encoding_brotli  = true
  }
}

resource "aws_cloudfront_origin_request_policy" "example" {
  name = "example-request-policy"

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