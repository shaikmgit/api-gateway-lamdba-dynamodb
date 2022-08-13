data "archive_file" "lambda_yourapp_catch_all" {
  type        = "zip"
  source_dir  = "${path.module}/client"
  output_path = "${path.module}/zip/catch_all.zip"
}

resource "aws_s3_object" "lambda_yourapp_catch_all" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "catch_all.zip"
  source = data.archive_file.lambda_yourapp_catch_all.output_path
  etag = filemd5(data.archive_file.lambda_yourapp_catch_all.output_path)
}

resource "aws_lambda_function" "catch_all_yourapp_func" {
  function_name = "CatchAll_yourapp"
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_yourapp_catch_all.key
  runtime = "nodejs12.x"
  handler = "catch-all.handler"
  source_code_hash = data.archive_file.lambda_yourapp_catch_all.output_base64sha256
  role = aws_iam_role.catch_all_lambda_yourapp_exec.arn
}

resource "aws_iam_role" "catch_all_lambda_yourapp_exec" {
  name = "Catch_All_lambda_yourapp_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_apigatewayv2_route" "catch_all_yourapp_rte" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.catch_all_yourapp_int.id}"
}

resource "aws_apigatewayv2_integration" "catch_all_yourapp_int" {
  api_id = aws_apigatewayv2_api.api.id
  integration_uri    = aws_lambda_function.catch_all_yourapp_func.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_iam_policy" "catch_all_yourapp_lambda_policy" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "StatementId01",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "catch_all__yourapp_lambda_policy" {
  policy_arn = aws_iam_policy.catch_all_yourapp_lambda_policy.arn
  role       = aws_iam_role.catch_all_lambda_yourapp_exec.name
}

resource "aws_lambda_permission" "catch_all_yourapp_perm" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.catch_all_yourapp_func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}



resource "aws_cloudwatch_log_group" "catch_all_yourapp_cw" {
  name = "/aws/lambda/${aws_lambda_function.catch_all_yourapp_func.function_name}"
  retention_in_days = var.log_retention_days
}
