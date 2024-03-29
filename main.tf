resource "aws_secretsmanager_secret" "dd_api_key" {
  count                   = "${var.create_datadog_forwarder == true ? 1 : 0}"
  name                    = "datadog_api_key"
  description             = "Encrypted Datadog API Key"
  recovery_window_in_days = "0"
}

resource "aws_secretsmanager_secret_version" "dd_api_key" {
  count         = "${var.create_datadog_forwarder == true ? 1 : 0}"
  secret_id     = aws_secretsmanager_secret.dd_api_key[0].id
  secret_string = var.dd_api_key
}

# Datadog Forwarder to ship logs from S3 and CloudWatch, as well as observability data from Lambda functions to Datadog.
# https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/logs_monitoring
# https://docs.datadoghq.com/logs/guide/forwarder/#terraform
resource "aws_cloudformation_stack" "datadog_forwarder" {
  count        = "${var.create_datadog_forwarder == true ? 1 : 0}"
  name         = var.datadog_forwarder_function_name
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters   = {
    DdApiKeySecretArn   = aws_secretsmanager_secret.dd_api_key[0].arn,
    DdSite              = var.dd_site,
    DdTags              = var.dd_tags,
    #DdApiKey            = var.dd_api_key
    FunctionName        = var.datadog_forwarder_function_name
    ExcludeAtMatch      = var.exclude_logs_pattern
    }
    template_url = var.datadog_cloudformation_template
}

resource "aws_iam_role" "datadog_integration_role" {
  count              = "${var.create_datadog_forwarder == true ? 1 : 0}"
  name               = var.datadog_role_name
  description        = "Datadog integration role"
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
          "sts:ExternalId": "${datadog_integration_aws.integration[0].external_id}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "datadog_integration_policy" {
  count       = "${var.create_datadog_forwarder == true ? 1 : 0}"
  name        = var.datadog_policy_name
  path        = "/"
  description = "Datadog integration policy provides core datadog integration permissions"
  policy      = "${file("${path.module}/templates/DatadogAWSIntegrationPolicy.json")}"
}

resource "aws_iam_role_policy_attachment" "datadog_policy_attach" {
  count      = "${var.create_datadog_forwarder == true ? 1 : 0}"
  role       = aws_iam_role.datadog_integration_role[0].name
  policy_arn = aws_iam_policy.datadog_integration_policy[0].arn
}

# Create a new Datadog - Amazon Web Services integration
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws
resource "datadog_integration_aws" "integration" {
  count                            = "${var.create_datadog_forwarder == true ? 1 : 0}"
  account_id                       = data.aws_caller_identity.current.account_id
  role_name                        = var.datadog_role_name
  excluded_regions                 = setsubtract(data.aws_regions.all_aws_regions.names, var.aws_regions)
  metrics_collection_enabled       = var.metrics_collection_enabled
  resource_collection_enabled      = var.resource_collection_enabled
  account_specific_namespace_rules = merge(
    { for key in jsondecode(data.http.get_available_metric_rules.response_body) : key => contains(var.metrics_to_collect, key) },
      { for key in var.metrics_to_collect : key => true }
  )
}

# Create a new Datadog - Amazon Web Services integration Lambda ARN.
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws_lambda_arn
resource "datadog_integration_aws_lambda_arn" "main_collector" {
  count      = "${var.create_datadog_forwarder == true ? 1 : 0}"
  account_id = data.aws_caller_identity.current.account_id
  lambda_arn = "${aws_cloudformation_stack.datadog_forwarder[0].outputs.DatadogForwarderArn}"
}

# Create a new Datadog - Amazon Web Services integration log collection.
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws_log_collection
resource "datadog_integration_aws_log_collection" "main" {
  count      = "${var.create_datadog_forwarder == true ? 1 : 0}"
  services   = var.log_collection_services
  account_id = data.aws_caller_identity.current.account_id
  depends_on = [datadog_integration_aws_lambda_arn.main_collector]
}

# Subscribe to datadog-forwarder.
resource "aws_cloudwatch_log_subscription_filter" "datadog_log_subscription_filter" {
  name            = "${each.value.name}"
  for_each        = var.cloudwatch_log_groups
  filter_pattern  = ""
  log_group_name  = "${each.value.name}"
  destination_arn = "arn:aws:lambda:${var.datadog_forwarder_aws_region}:${data.aws_caller_identity.current.account_id}:function:datadog-forwarder"

  depends_on = [
    aws_cloudformation_stack.datadog_forwarder
  ]
}

# Subscribe to datadog-forwarder for list.
resource "aws_cloudwatch_log_subscription_filter" "datadog_log_subscription_filter_for_list" {
  name            = "${each.key}"
  for_each        = var.cloudwatch_log_groups_as_list
  filter_pattern  = ""
  log_group_name  = "${each.key}"
  destination_arn = "arn:aws:lambda:${var.datadog_forwarder_aws_region}:${data.aws_caller_identity.current.account_id}:function:datadog-forwarder"

  depends_on = [
    aws_cloudformation_stack.datadog_forwarder
  ]
}