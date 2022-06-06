# Datadog integration module.
Official Datadog documentation was used for this module creation:<br>
https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws<br>
https://docs.datadoghq.com/logs/guide/forwarder/


## <ins>What module does?</ins>
```yaml
1. Stores the provided datadog api key in secret manager.
2. Creates role that allows datadog aws account to collect data.
3. Creates policy that allows datadog account to access different resources.
4. Creates integration between the AWS account and Datadog portal.
5. Creates official datadog cloudformation stack that creates a lambda which can forward logs to datadog portal.

# After that any1 on this account will be able to use lambda for logs collection
# Lambda subscription example:

# resource "aws_cloudwatch_log_subscription_filter" "datadog_log_subscription_filter" {
#   name            = "datadog_log_subscription_filter"
#   log_group_name  = "bread-evgeny"
#   destination_arn = "arn:aws:lambda:us-east-1:603106382807:function:datadog-forwarder"
#   filter_pattern  = ""
# }
```
## <ins>Usage</ins>
#### in datadog.tf file set the following :
```yaml
  region = <type string>
  dd_api_key = <type string>
  dd_app_key = <type string>
  dd_site = <type string>
  log_collection_services = <type list>
```
- **region:** *aws region.*<br/><br/>
- **dd_api_key:** *Datadog api key should be created by "Account builder" but now it is created manually.*<br>
for example: "/<aws_iam_account_alias>/datadog/api-key" ("/buffet-non-prod/datadog/api-key")<br/><br/>

- **dd_app_key:** *Datadog app key should be created by "Account builder" but now it is created manually.*<br/>
for example: "/<aws_iam_account_alias>/datadog/app-key" ("/buffet-non-prod/datadog/app-key")<br/><br/>


- **dd_site:** *In our case it's datadoghq.com as we don't work yet in EU.<br>
once we will work in EU [this link](https://docs.datadoghq.com/logs/guide/forwarder/#aws-privatelink-support) will be useful:*<br/><br/>

- **log_collection_services:** *A list of services to collect logs from.<br>
See [the api docs](https://docs.datadoghq.com/api/latest/aws-logs-integration/#get-list-of-aws-log-ready-services) for more details on which services are supported.*<br/><br/>

*When this README file was created supported logs were:*<br>
```
[{"id":"apigw-access-logs","label":"API Gateway Access Logs"},
{"id":"apigw-execution-logs","label":"API Gateway Execution Logs"},
{"id":"elbv2","label":"Application ELB Access Logs"},
{"id":"elb","label":"Classic ELB Access Logs"},
{"id":"cloudfront","label":"CloudFront Access Logs"},
{"id":"lambda","label":"Lambda Cloudwatch Logs"},
{"id":"redshift","label":"Redshift Logs"},
{"id":"s3","label":"S3 Access Logs"}]
```
Also you can check it by running the following command:<br>
```
curl -X GET "https://api.datadoghq.com/api/v1/integration/aws/logs/services" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}"
```
# <ins>Very important to know</ins>
### Each AWS account MUST have a "aws_iam_account_alias" setup: (should be done by Account builder)
### "aws_iam_account_alias" is basically the account name. for example (bread-non-prod)
### the alias will be used to create one api key and app key for whole account.
