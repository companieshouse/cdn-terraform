locals {
  aws_account_id              = data.aws_caller_identity.current.account_id
  cloudfront_shared_origin_id = "${var.service}-${var.aws_account}-shared-origin"
}
