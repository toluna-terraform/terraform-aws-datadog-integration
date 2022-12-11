module "datadog" {
  source                      = "toluna-terraform/datadog-integration/aws"
  dd_api_key                  = "WVOuMv1Bahntpr8No4H34P2GdxPIpAum"
  dd_app_key                  = "fp4E7qcjJ2mQHWZVqXn94o3y88YA6abb"
  cloudwatch_log_groups       = {log_group1={name="/aws/lambda/log_group1"},log_group2={name="/aws/ecs/log_group2"}}
}