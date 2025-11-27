const AWS = require('aws-sdk');
const sqs = new AWS.SQS();

exports.handler = async (event) => {
    console.log("Event:", JSON.stringify(event));

    const records = event.Records || [];

    for (const record of records) {
        const sns = record.Sns;
        const messageStr = sns.Message;

        let message;
        try {
            message = JSON.parse(messageStr);
        } catch (e) {
            console.error("Failed to parse SNS message:", messageStr);
            continue;
        }

        const payload = {
            job: "App\\Jobs\\ProcessEmailAlert",
            data: message
        };

        const params = {
            QueueUrl: process.env.SQS_URL,
            MessageBody: JSON.stringify(payload),
        };

        console.log("Sending to SQS:", params);

        await sqs.sendMessage(params).promise();
    }

    return { statusCode: 200, body: JSON.stringify('Messages forwarded to SQS') };
};
