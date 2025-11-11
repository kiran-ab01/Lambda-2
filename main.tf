

provider "aws" {
  region = "us-east-1"
}

# Use existing OIDC role instead of creating a new one
locals {
  lambda_role_arn = "arn:aws:iam::741846357014:role/AWS-Destination-OIDC"
}

# Lambda Function
resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_function_name
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  handler       = "index.handler"
  runtime       = "python3.11"
  role          = local.lambda_role_arn
}

# EventBridge Rule (Schedule)
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "${var.lambda_function_name}-schedule"
  schedule_expression = var.schedule_expression
}

# Permission for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "lambda"
  arn       = aws_lambda_function.lambda.arn
}
