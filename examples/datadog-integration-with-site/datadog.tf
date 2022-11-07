module "datadog" {
  dd_site                     = "datadoghq.eu"
  source                      = "toluna-terraform/datadog-integration/aws"
  loggroup_envs               = ["/aws/lambda/test1","/aws/lambda/test2"]
  dd_api_key                  = "456DFGBF4564567DFH"
  dd_app_key                  = "09870EWFSRE7686FFF"
 }