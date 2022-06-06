// Module's variables.
variable "datadog_aws_account_id" {
  type        = string
  description = "The AWS account ID Datadog's integration servers use for all integrations"
  default     = "464622532012"
}

variable "datadog_role_name" {
  type        = string
  description = ""
  default     = "DatadogAWSIntegrationRole"
}

variable "datadog_policy_name" {
  type        = string
  description = ""
  default     = "DatadogAWSIntegrationPolicy"
}

variable "datadog_lambda_fowarder_name" {
  type        = string
  description = ""
  default     = "datadog-forwarder"
}

variable "datadog_cloudformation_template" {
  type        = string
  description = ""
  default     = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"
}

// Shared variables.
variable "region" { type = string }
variable "dd_site" { type = string }
variable "dd_api_key" { type = string }
variable "dd_app_key" { type = string }
variable "log_collection_services" { type = list }
