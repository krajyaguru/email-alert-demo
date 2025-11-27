# Email Alert Demo – Laravel 8 + AWS SNS + Lambda + SQS

End-to-end demo:

> Laravel (PHP 7.4 / Laravel 8) → SNS → Lambda → SQS → Laravel Queue Worker → Email

---

## Prerequisites

- PHP 7.4
- Composer
- Node.js (for Lambda packaging)
- AWS account
- Terraform (v1.x)
- An SMTP setup for Laravel mail (Mailtrap, SES, etc.)

---

## 1. Create Laravel 8 App

```bash
composer create-project laravel/laravel:^8.0 email-alert-demo
cd email-alert-demo


## Architecture

```mermaid
flowchart LR
    A[Laravel Controller / Route<br>/send-demo-alert] --> B[Laravel SNS Service]
    B --> C[AWS SNS Topic]

    C --> D[AWS Lambda<br>sns-email-to-sqs]
    D --> E[AWS SQS Queue<br>email-alerts-queue]

    E --> F[Laravel Queue Worker<br>php artisan queue:work sqs]
    F --> G[Laravel Job<br>ProcessEmailAlert]
    G --> H[Email via SMTP/SES]
