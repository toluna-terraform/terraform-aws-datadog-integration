# AWS Datadog integration module.

Terraform module which creates Datadog integration on AWS.

## <ins>Usage</ins>
```hcl
module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  loggroup_envs               = [<list of strings>]
  dd_api_key                  = <string>
  dd_app_key                  = <string>
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
5. Subscription for each provided log group.
```

## Datadog site.
By default `dd_site` is `"datadoghq.com"`<br>
in order to change the default datadog site:
```hcl
module "datadog" {
  dd_site                     = "<string>"
  source                      = "toluna-terraform/datadog-integration/aws"
  loggroup_envs               = [<list of strings>]
  dd_api_key                  = <string>
  dd_app_key                  = <string>
}
```
## Datadog tags.
By default `dd_tags` is empty<br>
in order to change the default datadog tags:
```hcl
module "datadog" {
  dd_site                     = "<string>"
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_tags                     = <string>
  dd_api_key                  = <string>
  dd_app_key                  = <string>
}
```
Add custom tags to forwarded logs,
comma-delimited string, no trailing comma, e.g., env:prod,stack:classic

## Datadog log collection services.
By default `log_collection_services` is `["lambda"]`<br>
In order to change the default log collection services:
```hcl
module "datadog" {
  log_collection_services     = [<list of strings>]
  source                      = "toluna-terraform/datadog-integration/aws"
  loggroup_envs               = [<list of strings>]
  dd_api_key                  = <string>
  dd_app_key                  = <string>
}
```
`log_collection_services`:<br>
A list of services to collect logs from.<br>
* See [the api docs](https://docs.datadoghq.com/api/latest/aws-logs-integration/#get-list-of-aws-log-ready-services) for more details on which services are supported.<br/><br/>
* Also you can check it by running the following command:<br>
```
curl -X GET "https://api.datadoghq.com/api/v1/integration/aws/logs/services" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}"
```


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | 3.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | 3.17.0 |

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
| [datadog_integration_aws.integration](https://registry.terraform.io/providers/DataDog/datadog/3.17.0/docs/resources/integration_aws) | resource |
| [datadog_integration_aws_lambda_arn.main_collector](https://registry.terraform.io/providers/DataDog/datadog/3.17.0/docs/resources/integration_aws_lambda_arn) | resource |
| [datadog_integration_aws_log_collection.main](https://registry.terraform.io/providers/DataDog/datadog/3.17.0/docs/resources/integration_aws_log_collection) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datadog_aws_account_id"></a> [datadog\_aws\_account\_id](#input\_datadog\_aws\_account\_id) | The AWS account ID Datadog's integration servers use for all integrations | `string` | `"464622532012"` | no |
| <a name="input_datadog_cloudformation_template"></a> [datadog\_cloudformation\_template](#input\_datadog\_cloudformation\_template) | n/a | `string` | `"https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"` | no |
| <a name="input_datadog_forwarder_function_name"></a> [datadog\_forwarder\_function\_name](#input\_datadog\_forwarder\_function\_name) | Datadog forwarder lambda function name | `string` | `"datadog-forwarder"` | no |
| <a name="input_datadog_policy_name"></a> [datadog\_policy\_name](#input\_datadog\_policy\_name) | The set of permissions necessary to use all the integrations for individual AWS services. | `string` | `"DatadogAWSIntegrationPolicy"` | no |
| <a name="input_datadog_role_name"></a> [datadog\_role\_name](#input\_datadog\_role\_name) | Enable Datadog to collect metrics, tags, CloudWatch events, and other data necessary to monitor your AWS environment. | `string` | `"DatadogAWSIntegrationRole"` | no |
| <a name="input_dd_api_key"></a> [dd\_api\_key](#input\_dd\_api\_key) | Shared variables. | `string` | n/a | yes |
| <a name="input_dd_app_key"></a> [dd\_app\_key](#input\_dd\_app\_key) | n/a | `string` | n/a | yes |
| <a name="input_dd_site"></a> [dd\_site](#input\_dd\_site) | n/a | `string` | `"datadoghq.com"` | no |
| <a name="input_log_collection_services"></a> [log\_collection\_services](#input\_log\_collection\_services) | n/a | `list` | <pre>[<br>  "lambda"<br>]</pre> | no |
| <a name="input_loggroup_envs"></a> [loggroup\_envs](#input\_loggroup\_envs) | List of environment log groups | `any` | n/a | yes |

## Outputs

No outputs.

## Authors

Module is maintained by [Evgeny Gigi](https://github.com/evgenygigi).