terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_sns_topic" "email_alerts" {
  name = "${var.project_name}-email-alerts-topic"
}

resource "aws_sqs_queue" "email_alerts" {
  name = "${var.project_name}-email-alerts-queue"
}

resource "aws_sqs_queue_policy" "allow_sns" {
  queue_url = aws_sqs_queue.email_alerts.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.email_alerts.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.email_alerts.arn
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_sqs_policy" {
  name = "${var.project_name}-lambda-sqs-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage"
        ],
        Resource = aws_sqs_queue.email_alerts.arn
      }
    ]
  })
}

resource "aws_lambda_function" "sns_to_sqs" {
  function_name = "${var.project_name}-sns-email-to-sqs"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  filename      = var.lambda_zip

  environment {
    variables = {
      SQS_URL = aws_sqs_queue.email_alerts.id
    }
  }

  # This line was broken in your file – keep it exactly like this
  source_code_hash = filebase64sha256(var.lambda_zip)
}
