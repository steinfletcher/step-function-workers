provider "aws" {
  profile = "default"
  region = "eu-west-1"
}

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "my-state-machine"
  role_arn = aws_iam_role.sfn_exec_role.arn

  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "Controller",
  "States": {
    "Controller": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.controller.arn}",
      "Next": "Workers"
    },
    "Workers": {
      "Type": "Map",
      "ItemsPath": "$",
      "Iterator": {
         "StartAt": "Worker",
         "States": {
           "Worker": {
             "Type": "Task",
             "Resource": "${aws_lambda_function.worker.arn}",
             "End": true
           }
         }
      },
      "Next": "Collector"
    },
    "Collector": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.collector.arn}",
      "End": true
    }
  }
}
EOF
}

resource "aws_iam_role" "sfn_exec_role" {
  name                 = "sfn_exec_role"
  assume_role_policy   = data.aws_iam_policy_document.sfn_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "sfn_permission_policy_attachment" {
  role       = aws_iam_role.sfn_exec_role.name
  policy_arn = aws_iam_policy.sfn_permission_policy.arn
}

resource "aws_iam_policy" "sfn_permission_policy" {
  name   = "sfn_permission_policy"
  policy = data.aws_iam_policy_document.sfn_permission_policy_document.json
}

data "aws_iam_policy_document" "sfn_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "states.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "sfn_permission_policy_document" {
  statement {
    effect = "Allow"
    resources = [
      aws_lambda_function.controller.arn,
      aws_lambda_function.worker.arn,
      aws_lambda_function.collector.arn,
    ]
    actions = [
      "lambda:InvokeFunction"
    ]
  }
}

resource "aws_lambda_function" controller {
  function_name = "controller"
  handler = "function"
  role = aws_iam_role.iam_for_lambda.arn
  runtime = "go1.x"
  filename = "${path.module}/default_lambda/function.zip"
  source_code_hash = filebase64sha256("${path.module}/default_lambda/function.zip")
  lifecycle {
    ignore_changes = [
      "source_code_hash",
      "last_modified",
      "filename"
    ]
  }
}

resource "aws_lambda_function" worker {
  function_name = "worker"
  handler = "function"
  role = aws_iam_role.iam_for_lambda.arn
  runtime = "go1.x"
  filename = "${path.module}/default_lambda/function.zip"
  source_code_hash = filebase64sha256("${path.module}/default_lambda/function.zip")
  lifecycle {
    ignore_changes = [
      "source_code_hash",
      "last_modified",
      "filename"
    ]
  }
}

resource "aws_lambda_function" collector {
  function_name = "collector"
  handler = "function"
  role = aws_iam_role.iam_for_lambda.arn
  runtime = "go1.x"
  filename = "${path.module}/default_lambda/function.zip"
  source_code_hash = filebase64sha256("${path.module}/default_lambda/function.zip")
  lifecycle {
    ignore_changes = [
      "source_code_hash",
      "last_modified",
      "filename"
    ]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
