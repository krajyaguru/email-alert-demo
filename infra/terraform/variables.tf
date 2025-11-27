variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "lambda_zip" {
  type        = string
  description = "Path to the lambda zip file"
}
