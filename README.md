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


🧱 Architecture Diagram
flowchart LR
    A[Laravel Controller<br>/send-demo-alert] --> B[Laravel SNS Service]
    B --> C[AWS SNS Topic]

    C --> D[AWS Lambda<br>sns-email-to-sqs]
    D --> E[AWS SQS Queue<br>email-alerts-queue]

    E --> F[Laravel Queue Worker<br>php artisan queue:work sqs]
    F --> G[Laravel Job<br>ProcessEmailAlert]
    G --> H[Email via SMTP / SES]

🚀 Features

✔ Laravel 8 (PHP 7.4 compatible)
✔ Publishes messages to AWS SNS
✔ AWS Lambda processes SNS events
✔ Lambda sends messages to AWS SQS
✔ Laravel queue worker consumes SQS messages
✔ Laravel Job sends email notifications
✔ Terraform deploys SNS, SQS, Lambda, and IAM roles
✔ Clean GitHub-friendly project structure
✔ Ready to run end-to-end demo

📂 Project Structure
email-alert-demo/
├── app/
│   ├── Jobs/ProcessEmailAlert.php
│   ├── Mail/AlertEmail.php
│   └── Services/SnsService.php
├── infra/
│   └── terraform/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars  (ignored)
├── lambda/
│   ├── index.js
│   └── sns-email-to-sqs.zip
├── resources/
│   └── views/emails/alert.blade.php
├── routes/
│   └── web.php
├── README.md
├── .gitignore

🛠 Requirements

PHP 7.4

Composer

Node.js + NPM

AWS CLI

Terraform (v1.x)

An SMTP account (Mailtrap, SES, Gmail, etc.)

🔧 1. Install Laravel Project
composer create-project laravel/laravel:^8.0 email-alert-demo
cd email-alert-demo
composer require aws/aws-sdk-php


Serve app:

php artisan serve

🔧 2. Configure Laravel .env
QUEUE_CONNECTION=sqs

AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_DEFAULT_REGION=ap-south-1

SQS_QUEUE=https://sqs.ap-south-1.amazonaws.com/xxx/email-alerts-queue
AWS_SNS_TOPIC_ARN=arn:aws:sns:ap-south-1:xxx:email-alerts-topic

MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=your_user
MAIL_PASSWORD=your_pass
MAIL_FROM_ADDRESS=no-reply@example.com
MAIL_FROM_NAME="Email Alert Demo"

🔧 3. Deploy AWS Infrastructure (Terraform)
Package Lambda:
cd lambda
zip sns-email-to-sqs.zip index.js

Run Terraform:
cd infra/terraform
terraform init
terraform apply


Terraform creates:

SNS topic

SQS queue

Lambda function

IAM role

SNS → Lambda trigger

Copy the generated topic ARN and queue URL into your .env.

🔧 4. Test Route in Laravel

In routes/web.php:

use App\Services\SnsService;

Route::get('/send-demo-alert', function (SnsService $sns) {
    $sns->publish([
        'email'   => 'your-email@example.com',
        'subject' => 'Demo Alert Email',
        'message' => 'This email flowed through SNS → Lambda → SQS → Laravel!',
        'extra'   => ['time' => now()],
    ]);

    return 'Alert sent to SNS.';
});

🔧 5. Run Laravel SQS Worker
php artisan queue:work sqs


Keep this running.

🎉 6. Test the Entire Pipeline

Open in browser:

http://localhost:8000/send-demo-alert


Expected behavior:

Laravel sends message → SNS

SNS triggers Lambda

Lambda transforms message → sends to SQS

Laravel worker consumes SQS

Laravel job sends the email

🎉 Email received successfully

🧹 Recommended .gitignore
/vendor/
/node_modules/
/.env
/.idea/
/.vscode/

/storage/*.key
/public/storage

infra/terraform/.terraform/
infra/terraform/terraform.tfstate
infra/terraform/terraform.tfstate.backup
lambda/sns-email-to-sqs.zip

🤝 Contributing

PRs, issues, and suggestions are welcome.
This project is built for demo, learning, and AWS event-driven architecture exploration.
