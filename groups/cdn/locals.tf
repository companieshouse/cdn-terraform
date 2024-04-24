locals {
  cloudfront_s3_origin_id = "${var.service}-${var.aws_account}"
  aws_account_id          = data.aws_caller_identity.current.account_id
}
