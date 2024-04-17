data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "s3_access_logs_bucket_policy" {
  statement {
    sid    = "AllowPutObjectForS3LoggingService"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::${var.aws_account}-${var.region}-s3-access-logs/*"
    ]

    actions = ["s3:PutObject"]

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
  }

  statement {
    sid    = "DenyPutOrDeleteObjectForAllPrincipalsOtherThanS3LoggingService"
    effect = "Deny"

    resources = [
      "arn:aws:s3:::${var.aws_account}-${var.region}-s3-access-logs/*"
    ]

    actions = [
        "s3:PutObject",
        "s3:DeleteObject"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAllValues:StringNotEquals"
      values   = ["logging.s3.amazonaws.com"]
      variable = "aws:PrincipalServiceNamesList"
    }
  }

  statement {
    sid    = "DenyAllWhereSecureTransportNotUsed"
    effect = "Deny"

    resources = [
      "arn:aws:s3:::${var.aws_account}-${var.region}-s3-access-logs/*"
    ]

    actions = ["s3:*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }

  statement {
    sid = "DenyNonSSLRequests"

    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.logs.arn,
      "${aws_s3_bucket.logs.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}


data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "DenyNonSSLRequests"

    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.s3_bucket.arn,
      "${aws_s3_bucket.s3_bucket.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
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

