variable "env" {
  description = "Environment name (SIT, UAT, PROD)"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_s3_bucket" {
  description = "S3 bucket containing Lambda zip"
  type        = string
}

variable "lambda_s3_key" {
  description = "S3 key for Lambda zip"
  type        = string
}

variable "schedule_expression" {
  description = "EventBridge schedule expression"
  type        = string
}
