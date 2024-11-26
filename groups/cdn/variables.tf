variable "aws_account" {
  type        = string
  description = "The name of the AWS account"
}

variable "environments" {
  type        = set(string)
  description = "A set of strings representing environment names for which CloudFront distributions will be created"
}

variable "region" {
  type        = string
  description = "The AWS region in which resources will be created"
}

variable "default_ttl" {
  type        = number
  description = "The default TTL (Time to Live) value"
  default     = 300
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
  default     = "chs-cdn"
}

variable "cors_allowed_origins" {
  type        = set(string)
  description = "The origins which are allowed to access assets cross-origin"
}
