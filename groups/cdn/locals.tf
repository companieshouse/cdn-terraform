locals {
  cloudfront_s3_origin_id = "${var.environment}-${var.service}"
}
