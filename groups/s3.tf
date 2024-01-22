resource "aws_s3_bucket" "example" {
  bucket = "${var.service}.${var.environment}.${var.aws_account}.ch.gov.uk"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id

 policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "s3:GetObject",
        Effect    = "Allow",
        Resource  = "arn:aws:s3:::<aws_s3_bucket.example.bucket>/*",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Condition = {
          StringEquals = {
            "aws:SourceArn": "arn:aws:cloudfront::<aws_account_id>:distribution/<cloudfront_distribution-id>"
          }
        }
      }
    ]
  })
}


