data "archive_file" "lambda_yourapp_hello-world" {
  type = "zip"
  source_dir  = "${path.module}/client"
  output_path = "${path.module}/zip/hello-world.zip"
}

resource "aws_s3_object" "lambda_yourapp_hello-world" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "hello-world.zip"
  source = data.archive_file.lambda_yourapp_hello-world.output_path
  etag = filemd5(data.archive_file.lambda_yourapp_hello-world.output_path)
}

resource "aws_lambda_function" "hello-world_yourapp_func" {
  function_name = "Hello-World_yourapp"
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_yourapp_hello-world.key
  runtime = "nodejs12.x"
  handler = "hello-world.handler"
  source_code_hash = data.archive_file.lambda_yourapp_hello-world.output_base64sha256
  role = aws_iam_role.hello-world_lambda_yourapp_exec.arn
}

resource "aws_iam_role" "hello-world_lambda_yourapp_exec" {
  name = "Hello-World_lambda_yourapp_role"
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

resource "aws_iam_policy" "hello-world_yourapp_lambda_policy" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CWLogs",
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

resource "aws_iam_role_policy_attachment" "hello-world_yourapp_lambda_policy" {
  policy_arn = aws_iam_policy.hello-world_yourapp_lambda_policy.arn
  role       = aws_iam_role.hello-world_lambda_yourapp_exec.arn
}

resource "aws_lambda_permission" "hello-world_yourapp_perm" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello-world_yourapp_func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_route" "hello-world_yourapp_rte" {
  api_id = aws_apigatewayv2_api.api.id
  route_key = "GET /hello-world"
  target    = "integrations/${aws_apigatewayv2_integration.hello-world_yourapp_int.id}"
}

resource "aws_apigatewayv2_integration" "hello-world_yourapp_int" {
  api_id = aws_apigatewayv2_api.api.id
  integration_uri    = aws_lambda_function.hello-world_yourapp_func.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_cloudwatch_log_group" "hello-world_cw" {
  name = "/aws/lambda/${aws_lambda_function.hello-world_yourapp_func.function_name}"
  retention_in_days = var.log_retention_days
}