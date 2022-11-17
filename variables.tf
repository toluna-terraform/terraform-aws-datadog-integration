// Module's variables.
variable "datadog_aws_account_id" {
  type        = string
  description = "The AWS account ID Datadog's integration servers use for all integrations"
  default     = "464622532012"
}

variable "datadog_forwarder_function_name" {
  type        = string
  description = "Datadog forwarder lambda function name"
  default     = "datadog-forwarder"
}

variable "datadog_role_name" {
  type        = string
  description = "Enable Datadog to collect metrics, tags, CloudWatch events, and other data necessary to monitor your AWS environment."
  default     = "DatadogAWSIntegrationRole"
}

variable "datadog_policy_name" {
  type        = string
  description = "The set of permissions necessary to use all the integrations for individual AWS services."
  default     = "DatadogAWSIntegrationPolicy"
}

variable "datadog_cloudformation_template" {
  type        = string
  description = ""
  default     = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"
}

// Shared variables.
variable "dd_api_key" { type = string }
variable "dd_app_key" { type = string }
variable "dd_site" {
  default     = "datadoghq.com"
  type        = string 
}

variable "dd_tags" {
  default     = ""
  type        = string
  description = "Add custom tags to forwarded logs, comma-delimited string, no trailing comma, e.g., env:prod,stack:classic"
}

variable "exclude_logs_pattern" {
  default     = "\"(START|END|REPORT) RequestId:\\s"
  type        = string
  description = "This pattern will exclude lambda execution report only ERROR report will be forwarded"
}

variable "log_collection_services" {
  type        = list
  default     = []
}

variable "loggroup_envs" {
  description = "List of environment log groups"
}