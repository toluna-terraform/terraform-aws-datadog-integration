variable "datadog_config" {
}

variable "datadog_aws_account_id" {
  type        = string
  default     = "464622532012"
  description = "The AWS account ID Datadog's integration servers use for all integrations"
}

variable "datadog_forwarder_function_name" {
  type        = string
  default     = "datadog-forwarder"
  description = "Datadog forwarder lambda function name"
}

variable "datadog_role_name" {
  type        = string
  default     = "DatadogAWSIntegrationRole"
  description = "Enable Datadog to collect metrics, tags, CloudWatch events, and other data necessary to monitor your AWS environment."
}

variable "datadog_policy_name" {
  type        = string
  default     = "DatadogAWSIntegrationPolicy"
  description = "The set of permissions necessary to use all the integrations for individual AWS services."
}

variable "datadog_cloudformation_template" {
  type        = string
  description = "Official CloudFormation template provided by Datadog"
  default     = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"
}

variable "dd_api_key" {
  type        = string
  description = "The Datadog API key"
}

variable "dd_app_key" {
  type        = string
  description = "The Datadog APP key"
}

variable "dd_site" {
  type        = string 
  default     = "datadoghq.com"
  description = "Datadog Site to send data to."
}

variable "dd_tags" {
  type        = string
  default     = ""
  description = "Add custom tags to forwarded logs, comma-delimited string, no trailing comma, e.g., env:prod,stack:classic"
}

variable "metrics_collection_enabled" {
  type        = string
  default     = "true"
  description = "Datadog collects metrics for this AWS account."
}

variable "resource_collection_enabled" {
  type        = string
  default     = "false"
  description = "Datadog collects a standard set of resources from your AWS account."
}

variable "exclude_logs_pattern" {
  type        = string
  default     = "\"(START|REPORT|END|TELEMETRY|EXTENSION)"
  description = "This pattern will exclude lambda execution report only ERROR report will be forwarded. By default forwarder will exclude reports of Datadog Agent and Tracer"
}

variable "log_collection_services" {
  type        = list
  default     = []
  description = "A list of services which Datadog will automatically collect logs from. See the api docs (README.md) for more details on which services are supported."
}

variable "cloudwatch_log_groups_as_list" {
  default     = {}
  description = "List of cloudwatch log groups as list."
}

variable "cloudwatch_log_groups" {
  default     = {}
  description = "List of cloudwatch log groups as map."
}

variable "metrics_to_collect" {
  type        = list
  default     = ["lambda"]
  description = "An array of metrics which Datadog collects from your AWS account."
}

variable "aws_regions" {
  type        = list
  default     = ["us-east-1"]
  description = "An array of AWS regions to include for metrics collection."
}

variable "datadog_forwarder_aws_region" {
  type        = string
  default     = "us-east-1"
  description = "A region on which datadog forwarder is deployed."
}

variable "create_datadog_forwarder" {
  default = true
}
