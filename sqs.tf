# SQS

# Queue 
# Access policy
# DLQ


resource "aws_sqs_queue" "order_placed_queue" {
  name = "order-placed-queue"
    redrive_policy             = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.order_placed_dlq.arn}\",\"maxReceiveCount\":5}"

}

# Dead letter Q
resource "aws_sqs_queue" "order_placed_dlq" {
  name = "order_placed_dlq"
}

data "aws_iam_policy_document" "order_placed_queue_iam_policy" {
  policy_id = "SQSSendAccess"
  statement {
    sid       = "SQSSendAccessStatement"
    effect    = "Allow"
    actions   = ["SQS:SendMessage"]
    resources = ["${aws_sqs_queue.order_placed_queue.arn}"]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    condition {
      test     = "ArnEquals"
      values   = ["${aws_sns_topic.order_placed_topic.arn}"]
      variable = "aws:SourceArn"
    }
  }
}

# we’re going to add permissions to the SQS queue to be able to send messages on the topic. 
# This is important because without setting the right permissions, it won’t work!
resource "aws_sqs_queue_policy" "order_placed_queue_policy" {
  queue_url = "${aws_sqs_queue.order_placed_queue.id}"
  policy    = "${data.aws_iam_policy_document.order_placed_queue_iam_policy.json}"
}
