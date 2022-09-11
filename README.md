# Datadog integration module.
Official Datadog documentation was used for this module creation:<br>
https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws<br>
https://docs.datadoghq.com/logs/guide/forwarder/


## <ins>What module does?</ins>
```
1. Creates role that allows datadog aws account to collect data.
2. Creates policy that allows datadog account to access different resources.
3. Creates integration between the AWS account and Datadog portal.
4. Creates official datadog cloudformation stack that creates a lambda which can forward logs to datadog portal.
5. Creates a log subscription for each loggroup.
```

## <ins>Usage</ins>
#### Create a datadog.tf file in terraform/shared and set the following :
```hcl
module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  region                      = "us-east-1"
  app_name                    = local.app_name
  loggroup_envs               = local.loggroup_envs
  dd_api_key                  = data.aws_ssm_parameter.datadog_api_key.value
  dd_app_key                  = data.aws_ssm_parameter.datadog_app_key.value
  dd_site                     = "datadoghq.com"
  log_collection_services     = ["lambda"]
}
```
#### After that add the following lines into data.tf in terraform/shared.
```hcl
data "aws_ssm_parameter" "datadog_api_key" {
    name = "/${data.aws_caller_identity.current.account_id}/datadog/api-key"
}

data "aws_ssm_parameter" "datadog_app_key" {
    name = "/${data.aws_caller_identity.current.account_id}/datadog/app-key"
}
```
#### Now you can apply on shared layer.
## <ins>Flags</ins>
- **region:** *aws region.*<br/><br/>
- **dd_api_key:** *Datadog api key should be created by "Account builder" but now it is created manually.*<br>
for example: "/<aws_caller_identity>/datadog/api-key" ("/<account_id>/datadog/api-key")<br/><br/>

- **dd_app_key:** *Datadog app key should be created by "Account builder" but now it is created manually.*<br/>
for example: "/<aws_caller_identity>/datadog/app-key" ("/<account_id>/datadog/app-key")<br/><br/>
I've used the account ID instead of account name(alias) because account alias cannot be used here as they are globally unique across all AWS products,<br>
meaning if it is already being used by someone else it wont be available for you to use.<br>
AWS does not reserve the names per customer<br>
because it's simply a sub domain for signin for example https://buffet-non-prod.signin.aws.amazon.com/console.

- **dd_site:** *In our case it's datadoghq.com as we don't work yet in EU.<br>
once we will work in EU [this link](https://docs.datadoghq.com/logs/guide/forwarder/#aws-privatelink-support) will be useful:*<br/><br/>

- **log_collection_services:** *A list of services to collect logs from.<br>
See [the api docs](https://docs.datadoghq.com/api/latest/aws-logs-integration/#get-list-of-aws-log-ready-services) for more details on which services are supported.*<br/><br/>

*When this README file was created supported log collections were:*<br>
```json
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

### **Conclusion:**
In case of multi-product accounts like *( Buffet-non-prod or Guilds )*<br>
You have to use datadog integration module only in one product.<br>
The rest will just subscribe to datadog-forwarder lambda in order to send logs.<br></br>

# Manual Lambda subscription example:
```hcl
resource "aws_cloudwatch_log_subscription_filter" "datadog_log_subscription_filter" {
  name            = "datadog_log_subscription_filter"
  log_group_name  = "<your_log_group_name>"
  destination_arn = "arn:aws:lambda:us-east-1:<account_id>:function:datadog-forwarder"
  filter_pattern  = ""
}
```

# <ins>Important to know about Datadog</ins>
## The Datadog agent is:<br>
A lightweight software installed on applications hosts that helps push every log, event, trace, and metric produced by your applications and infrastructure using the Datadog APIs.<br>
Must be integrated on infrastructure level for more info click [here](https://docs.datadoghq.com/integrations/ecs_fargate/?tab=fluentbitandfirelens).

## The Datadog tracer is:<br>
Datadog Application Performance Monitoring (APM or tracing) is used to collect traces from your backend application code.<br>
Must be integrated on application level for more info click [here](https://docs.datadoghq.com/tracing/setup_overview/).
