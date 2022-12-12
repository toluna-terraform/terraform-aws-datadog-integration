# AWS Datadog integration module.

Terraform module which creates Datadog integration on AWS.

## <ins>Usage</ins>
```hcl
module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_api_key                  = "<string>"
  dd_app_key                  = "<string>"
}
```

## <ins>What module does?</ins>
By default this module will provision:
```
1. Role that allows datadog aws account to collect data.
2. Policy that allows datadog account to access different resources.
3. Integration between the AWS account and Datadog portal (by default collects logs from lambda functions).
4. Official datadog cloudformation stack that creates a lambda (by default pointed to datadoghq.com)
    which can forward logs to datadog portal.
```
## <ins>AWS Regions.</ins>
The regions of your AWS account.<br>
By default `aws_regions` is `["us-east-1"]`.<br>
All other regions are excluded by default.<br>
in order to change the default add an attribute `aws_regions` with desired value.<br>
You can find a list of all excluded regions down below in README.md.<br>
```hcl
module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_api_key                  = "<string>"
  dd_app_key                  = "<string>"
  aws_regions                 = ["<list of strings>"]
}
```
## <ins>Log groups.</ins>
Log groups you want to be subscribed to datadog forwarder.<br>
By default `cloudwatch_log_groups` is `{}`.<br>
in order to change the default add an attribute `cloudwatch_log_groups` with desired value.<br>
The value should be a map of maps where each is identified by a string label and have a key `name` with the value of a log group name.<br>
```hcl
{log_group1={name="/aws/lambda/log_group1"},log_group2={name="/aws/ecs/log_group2"}}
```
Please see example in `examples/datadog-integration-with-log-groups` folder.<br>
```hcl
module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_api_key                  = "<string>"
  dd_app_key                  = "<string>"
  cloudwatch_log_groups       = {{map of maps}}
}
```
## <ins>Datadog site.</ins>
Datadog Site to send data to.<br>
By default `dd_site` is `"datadoghq.com"`.<br>
in order to change the default datadog site add an attribute `dd_site` with desired value.<br>
```hcl
module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_api_key                  = "<string>"
  dd_app_key                  = "<string>"
  dd_site                     = "<string>"
}
```
You can find [here](https://docs.datadoghq.com/getting_started/site/) a list of datadog sites.
## <ins>Datadog tags.</ins>
Add custom tags to forwarded logs, comma-delimited string, no trailing comma, e.g., `"env:prod,stack:classic"`<br>
By default `dd_tags` is empty<br>
in order to change the default datadog tags add an attribute `dd_tags` with desired value.<br>
```hcl
module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_api_key                  = "<string>"
  dd_app_key                  = "<string>"
  dd_tags                     = "<string>"
}
```
Add custom tags to forwarded logs,<br>
comma-delimited string,<br>
no trailing comma,<br>
e.g., env:prod,stack:classic

## <ins>Datadog log collection services.</ins>
A list of services which Datadog will automatically collect logs from.<br>
By default `log_collection_services` is empty<br>
In order to change the default log collection services add an attribute `log_collection_services` with desired value.<br>
```hcl
module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_api_key                  = "<string>"
  dd_app_key                  = "<string>"
  log_collection_services     = ["<list of strings>"]
}
```
A list of services to collect logs from :<br>
```json[{"id":"apigw-access-logs","label":"API Gateway Access Logs"},
{"id":"apigw-execution-logs","label":"API Gateway Execution Logs"},
{"id":"elbv2","label":"Application ELB Access Logs"},
{"id":"elb","label":"Classic ELB Access Logs"},
{"id":"cloudfront","label":"CloudFront Access Logs"},
{"id":"lambda","label":"Lambda Cloudwatch Logs"},
{"id":"redshift","label":"Redshift Logs"},
{"id":"s3","label":"S3 Access Logs"}]
```
* You can also see the supported services by running the following command:<br>
```
curl -X GET "https://api.datadoghq.com/api/v1/integration/aws/logs/services" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}"
```
## <ins>Datadog metrics collection.</ins>
Datadog collects metrics for this AWS account.<br>
By default `metrics_collection_enabled` is `"true"`.<br>
In order to change the default `metrics_collection_enabled` add an attribute `metrics_collection_enabled` with desired value.<br>
```hcl
module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_api_key                  = "<string>"
  dd_app_key                  = "<string>"
  metrics_collection_enabled  = "<string>"
}
```
For more info on `metrics_collection_enabled` please visit this [link](https://docs.datadoghq.com/api/latest/aws-integration/).<br>
## <ins>Datadog resource collection.</ins>
Datadog collects a standard set of resources from your AWS account.<br>
By default `resource_collection_enabled` is `"true"`.<br>
In order to change the default `resource_collection_enabled` add an attribute `resource_collection_enabled` with desired value.<br>
```hcl
module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_api_key                  = "<string>"
  dd_app_key                  = "<string>"
  resource_collection_enabled = "<string>"
}
```
For more info on `resource_collection_enabled` please visit this [link](https://docs.datadoghq.com/api/latest/aws-integration/).<br>

## <ins>Datadog excluded logs pattern.</ins>
You can pass a specific logs pattern which you want to be excluded from forwarding.<br>
By default `exclude_logs_pattern` is `"\"(START|END|REPORT) RequestId:\\s"` to exclude Lambda invocation logs<br>
In order to change the default exclude logs pattern add an attribute `exclude_logs_pattern` with desired value.<br>
For more info please visit this [link](https://docs.datadoghq.com/api/latest/aws-integration/).<br>

```hcl
module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_api_key                  = "<string>"
  dd_app_key                  = "<string>"
  exclude_logs_pattern        = "<string>"
}
```
For more information about Datadog forwarder please visit [link](https://docs.datadoghq.com/logs/guide/forwarder/#log-filtering-optional).


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | 3.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | 3.18.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.datadog_forwarder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_cloudwatch_log_subscription_filter.datadog_log_subscription_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_iam_policy.datadog_integration_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.datadog_integration_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.datadog_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [datadog_integration_aws.integration](https://registry.terraform.io/providers/DataDog/datadog/3.18.0/docs/resources/integration_aws) | resource |
| [datadog_integration_aws_lambda_arn.main_collector](https://registry.terraform.io/providers/DataDog/datadog/3.18.0/docs/resources/integration_aws_lambda_arn) | resource |
| [datadog_integration_aws_log_collection.main](https://registry.terraform.io/providers/DataDog/datadog/3.18.0/docs/resources/integration_aws_log_collection) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_regions"></a> [aws\_regions](#input\_aws\_regions) | An array of AWS regions to include for metrics collection. | `list` | <pre>[<br>  "us-east-1"<br>]</pre> | no |
| <a name="input_cloudwatch_log_groups"></a> [cloudwatch\_log\_groups](#input\_cloudwatch\_log\_groups) | List of cloudwatch log groups. | `map(any)` | `{}` | no |
| <a name="input_datadog_aws_account_id"></a> [datadog\_aws\_account\_id](#input\_datadog\_aws\_account\_id) | The AWS account ID Datadog's integration servers use for all integrations | `string` | `"464622532012"` | no |
| <a name="input_datadog_cloudformation_template"></a> [datadog\_cloudformation\_template](#input\_datadog\_cloudformation\_template) | Official CloudFormation template provided by Datadog | `string` | `"https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"` | no |
| <a name="input_datadog_forwarder_function_name"></a> [datadog\_forwarder\_function\_name](#input\_datadog\_forwarder\_function\_name) | Datadog forwarder lambda function name | `string` | `"datadog-forwarder"` | no |
| <a name="input_datadog_policy_name"></a> [datadog\_policy\_name](#input\_datadog\_policy\_name) | The set of permissions necessary to use all the integrations for individual AWS services. | `string` | `"DatadogAWSIntegrationPolicy"` | no |
| <a name="input_datadog_role_name"></a> [datadog\_role\_name](#input\_datadog\_role\_name) | Enable Datadog to collect metrics, tags, CloudWatch events, and other data necessary to monitor your AWS environment. | `string` | `"DatadogAWSIntegrationRole"` | no |
| <a name="input_dd_api_key"></a> [dd\_api\_key](#input\_dd\_api\_key) | The Datadog API key | `string` | n/a | yes |
| <a name="input_dd_app_key"></a> [dd\_app\_key](#input\_dd\_app\_key) | The Datadog APP key | `string` | n/a | yes |
| <a name="input_dd_site"></a> [dd\_site](#input\_dd\_site) | Datadog Site to send data to. | `string` | `"datadoghq.com"` | no |
| <a name="input_dd_tags"></a> [dd\_tags](#input\_dd\_tags) | Add custom tags to forwarded logs, comma-delimited string, no trailing comma, e.g., env:prod,stack:classic | `string` | `""` | no |
| <a name="input_exclude_logs_pattern"></a> [exclude\_logs\_pattern](#input\_exclude\_logs\_pattern) | This pattern will exclude lambda execution report only ERROR report will be forwarded. | `string` | `"\"(START\|END\|REPORT) RequestId:\s"` | no |
| <a name="input_excluded_aws_regions"></a> [excluded\_aws\_regions](#input\_excluded\_aws\_regions) | An array of AWS regions to exclude from metrics collection. | `list` | <pre>[<br>  "us-east-2",<br>  "us-east-1",<br>  "us-west-1",<br>  "us-west-2",<br>  "af-south-1",<br>  "ap-east-1",<br>  "ap-south-2",<br>  "ap-southeast-3",<br>  "ap-south-1",<br>  "ap-northeast-3",<br>  "ap-northeast-2",<br>  "ap-southeast-1",<br>  "ap-southeast-2",<br>  "ap-northeast-1",<br>  "ca-central-1",<br>  "eu-central-1",<br>  "eu-west-1",<br>  "eu-west-2",<br>  "eu-south-1",<br>  "eu-west-3",<br>  "eu-south-2",<br>  "eu-north-1",<br>  "eu-central-2",<br>  "me-south-1",<br>  "me-central-1",<br>  "sa-east-1"<br>]</pre> | no |
| <a name="input_log_collection_services"></a> [log\_collection\_services](#input\_log\_collection\_services) | A list of services which Datadog will automatically collect logs from. See the api docs (README.md) for more details on which services are supported. | `list` | `[]` | no |
| <a name="input_metrics_collection_enabled"></a> [metrics\_collection\_enabled](#input\_metrics\_collection\_enabled) | Datadog collects metrics for this AWS account. | `string` | `"true"` | no |
| <a name="input_resource_collection_enabled"></a> [resource\_collection\_enabled](#input\_resource\_collection\_enabled) | Datadog collects a standard set of resources from your AWS account. | `string` | `"true"` | no |

## Outputs

No outputs.

## Authors

Module is maintained by [Evgeny Gigi](https://github.com/evgenygigi).