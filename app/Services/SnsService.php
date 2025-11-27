<?php

namespace App\Services;

use Aws\Sns\SnsClient;

class SnsService
{
    protected SnsClient $sns;
    protected string $topicArn;

    public function __construct()
    {
        $this->sns = new SnsClient([
            'region' => env('AWS_DEFAULT_REGION'),
            'version' => '2025-03-31',
            'credentials' => [
                'key' => env('AWS_ACCESS_KEY_ID'),
                'secret' => env('AWS_SECRET_ACCESS_KEY'),
            ]
        ]);

        $this->topicArn = env('AWS_SNS_TOPIC_ARN');
    }

    public function publish(array $message)
    {
        return $this->sns->publish([
            'TopicArn' => $this->topicArn,
            'Message'  => json_encode($message),
        ]);
    }
}
