data "aws_caller_identity" "current" {}

# An array of AWS regions to exclude from metrics collection.
data "aws_regions" "all_aws_regions" {
  all_regions = true
}

# An array of metrics which Datadog collects from your AWS account.
data "http" "get_available_metric_rules" {
  # https://docs.datadoghq.com/api/latest/aws-integration/#list-namespace-rules
  url    = "https://api.datadoghq.com/api/v1/integration/aws/available_namespace_rules"
  method = "GET"

  # Optional request headers
  request_headers = {
    Accept             = "application/json"
    DD-API-KEY         = var.dd_api_key
    DD-APPLICATION-KEY = var.dd_app_key
  }
}