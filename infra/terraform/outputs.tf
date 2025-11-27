output "sns_topic_arn" {
  value       = aws_sns_topic.email_alerts.arn
  description = "SNS topic ARN"
}

output "sqs_queue_url" {
  value       = aws_sqs_queue.email_alerts.id
  description = "SQS queue URL"
}

output "lambda_function_name" {
  value       = aws_lambda_function.sns_to_sqs.function_name
  description = "Lambda function name"
}
