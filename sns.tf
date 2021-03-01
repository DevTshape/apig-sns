# To subscribe SQS to our SNS topic we need to perform 3 steps, which are the following.

# 1. Subscribe SQS to the SNS event message
# 2. Create a SQS queue and SQS dead letter queue
# 3. Create a SQS queue policy

resource "aws_sns_topic" "order_placed_topic" {
  name = "order-placed-topic"
}

resource "aws_sns_topic_subscription" "order_placed_subscription" {
  topic_arn = aws_sns_topic.order_placed_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.order_placed_queue.arn
}
