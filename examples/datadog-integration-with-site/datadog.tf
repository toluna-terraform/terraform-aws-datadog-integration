module "datadog" {
  dd_site                     = "datadoghq.eu"
  source                      = "toluna-terraform/datadog-integration/aws"
  cloudwatch_log_groups       = ["/aws/lambda/test1","/aws/lambda/test2"]
  dd_api_key                  = "WVOuMv1Bahntpr8No4H34P2GdxPIpAum"
  dd_app_key                  = "fp4E7qcjJ2mQHWZVqXn94o3y88YA6abb"
 }