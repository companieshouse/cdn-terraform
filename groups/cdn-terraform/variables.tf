variable "aws_account" {
  type        = string
  description = "The name of the AWS account"
}

variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be created"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "cloudfront_distribution_arn" {
  type        = string
  description = "ARN of the CloudFront distribution"
}

variable "default_ttl" {
  type        = number 
  description = "The default TTL (Time to Live) value"
  default     = 300
}

variable "environment" {
  type        = string
  description = "The environment name to be used when creating AWS resources"
}

variable "min_ttl" {
  type        = number
  description = "The minimum TTL value"
  default     = 300
}

variable "max_ttl" {
  type        = number
  description = "The maximum TTL value"
  default     = 300
}

variable "service" {
  type        = string
  description = "The service name to be used when creating AWS resources"
  default     = "cdn-terraform"
}