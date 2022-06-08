# Store Datadog API key in AWS Secrets Manager
resource "aws_secretsmanager_secret" "dd_api_key" {
  name        = "/${data.aws_caller_identity.current.account_id}/datadog/api-key"
  description = "Encrypted Datadog API Key"
}

resource "aws_secretsmanager_secret_version" "dd_api_key" {
  secret_id     = aws_secretsmanager_secret.dd_api_key.id
  secret_string = "${var.dd_api_key}"
}

# Datadog Forwarder to ship logs from S3 and CloudWatch, as well as observability data from Lambda functions to Datadog.
# https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/logs_monitoring
# https://docs.datadoghq.com/logs/guide/forwarder/#terraform
resource "aws_cloudformation_stack" "datadog_forwarder" {
  name         = "datadog-forwarder"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters   = {
    DdApiKeySecretArn   = aws_secretsmanager_secret.dd_api_key.arn,
    DdSite              = var.dd_site,
    FunctionName        = "datadog-forwarder"
  }
  template_url = var.datadog_cloudformation_template
}

# Create a new Datadog - Amazon Web Services integration
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws
resource "datadog_integration_aws" "integration" {
  account_id                       = data.aws_caller_identity.current.account_id
  role_name                        = var.datadog_role_name
  metrics_collection_enabled       = "true"
  resource_collection_enabled      = "true"
  account_specific_namespace_rules = {
  }
}

resource "aws_iam_role" "datadog-integration-role" {
  name  = var.datadog_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.datadog_aws_account_id}:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${datadog_integration_aws.integration.external_id}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "datadog-integration-policy" {
  name        = var.datadog_policy_name
  path        = "/"
  description = "This IAM policy allows for core datadog integration permissions"
  policy = "${file("${path.module}/templates/DatadogAWSIntegrationPolicy.json")}"
}

resource "aws_iam_role_policy_attachment" "datadog-policy-attach" {
  role       = aws_iam_role.datadog-integration-role.name
  policy_arn = aws_iam_policy.datadog-integration-policy.arn
}

# Create a new Datadog - Amazon Web Services integration Lambda ARN.
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws_lambda_arn
resource "datadog_integration_aws_lambda_arn" "main_collector" {
  account_id = data.aws_caller_identity.current.account_id
  lambda_arn = "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:datadog-forwarder"
}

# Create a new Datadog - Amazon Web Services integration log collection.
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws_log_collection
resource "datadog_integration_aws_log_collection" "main" {
  account_id = data.aws_caller_identity.current.account_id
  services   = var.log_collection_services
}

resource "aws_cloudwatch_log_subscription_filter" "datadog_log_subscription_filter" {
  for_each = var.loggroup_envs
    name            = "${each.value.name}"
    log_group_name  = "${each.value.name}"
    filter_pattern  = ""
    destination_arn = "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:datadog-forwarder"
}