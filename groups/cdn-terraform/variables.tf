variable "default_ttl" {
  description = "The default TTL (Time to Live) value"
  default     = 300
}

variable "min_ttl" {
  description = "The minimum TTL value"
  default     = 300
}

variable "max_ttl" {
  description = "The maximum TTL value"
  default     = 300
}

variable "region" {
  type        = string
  description = "The AWS region in which resources will be created"
}

variable "environment" {
  type        = string
  description = "The environment name to be used when creating AWS resources"
}

variable "service" {
  type        = string
  description = "The service name to be used when creating AWS resources"
  default     = "physical-media-backup"
}

variable "aws_account" {
  type        = string
  description = "The name of the AWS account"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution"
  type        = string
}
