resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.service}.${var.aws_account}.ch.gov.uk"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_cloudfront_policy.json
}

resource "aws_s3_bucket" "cdn_log_bucket" {
  bucket = "chs_cdn_server_access_logging"
}
resource "aws_s3_bucket_logging" "s3_cdn_logging" {
  bucket = aws_s3_bucket.s3_bucket.id

  target_bucket = aws_s3_bucket.cdn_log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.cdn_log_bucket.id
  acl    = "log-delivery-write"
}

data "aws_iam_policy_document" "s3_ssl_policy" {
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    actions = [
      "s3:*",
    ]
    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "s3_cloudfront_policy" {
  statement {

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]
  }
}
