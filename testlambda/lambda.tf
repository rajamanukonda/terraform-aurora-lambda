# Simple AWS Lambda Terraform Example
# requires 'index.js' in the same directory
# to test: run `terraform plan`
# to deploy: run `terraform apply`

variable "aws_region" {
  default = "us-east-1"
}

provider "aws" {
  region          = "${var.aws_region}"
}

data "archive_file" "lambdapython_zip" {
    type          = "zip"
    source_file   = "rds.py"
    output_path   = "lambda_function_python.zip"
}

resource "aws_lambda_function" "test_lambda_python" {
  filename         = "lambda_function_python.zip"
  function_name    = "test_lambda_python"
  role             = "${aws_iam_role.iam_for_lambda_python_tf.arn}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambdapython_zip.output_base64sha256}"
  runtime          = "python3.7"
}

resource "aws_iam_role" "iam_for_lambda_python_tf" {
  name = "iam_for_lambda_python_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "${aws_iam_role.iam_for_lambda_python_tf.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
